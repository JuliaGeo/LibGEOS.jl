#=
Run this file to regenerate `geos_c.jl` and `geos_common.jl`.

It expects a GEOS install in the deps folder, run `build LibGEOS` in Pkg mode
if these are not in place.

The wrapped GEOS version and provided GEOS version should be kept in sync.
So when updating the GEOSBuilder provided version, also rerun this wrapper.
This way we ensure that the provided library has the same functions available
as the wrapped one. Furthermore this makes sure constants in `geos_common.jl`
like `GEOS_VERSION`, which are just strings, are correct.
=#

using Clang
using MacroTools

includedir = normpath(joinpath(@__DIR__, "..", "deps", "usr", "include"))
headerfiles = [joinpath(includedir, "geos_c.h")]

"""
Custom rewriter for Clang.jl's C wrapper

Gets called with all expressions in a header file, or all expressions in a common file.
The expressions get sent to `rewriter(::Expr)`` for
further treatment.
"""
function rewriter(xs::Vector)
    rewritten = Any[]
    for x in xs
        # Clang.jl inserts strings like "# Skipping MacroDefinition: X"
        # keep these to get a sense of what we are missing
        if x isa String
            push!(rewritten, x)
            continue
        end
        @assert x isa Expr

        x2 = rewriter(x)
        push!(rewritten, x2)
    end
    rewritten
end

"Functions that return a Cstring are wrapped in unsafe_string to return a String"
function rewriter(x::Expr)
    if @capture(x,
        function f_(fargs__)
            ccall(fname_, rettype_, argtypes_, argvalues__)
        end
    )
        # it is a function wrapper around a ccall

        # bind the ccall such that we can easily wrap it
        cc = :(ccall($fname, $rettype, $argtypes, $(argvalues...)))

        cc2 = if rettype == :Cstring
            :(unsafe_string($cc))
        else
            cc
        end

        # stitch the modified function expression back together
        x2 = :(function $f($(fargs...))
            $cc2
        end) |> prettify
        x2
    else
        # do not modify expressions that are no ccall function wrappers
        x
    end
end

wc = init(; headers = headerfiles,
            output_file = joinpath(@__DIR__, "..", "src", "geos_c.jl"),
            common_file = joinpath(@__DIR__, "..", "src", "geos_common.jl"),
            clang_includes = [includedir, CLANG_INCLUDE],
            clang_args = ["-I", includedir],
            header_wrapped = (root, current) -> root == current,
            header_library = x -> "libgeos",
            clang_diagnostics = true,
            rewriter = rewriter,
            )

run(wc)

# delete Clang.jl helper files
rm(joinpath(@__DIR__, "..", "src", "LibTemplate.jl"))
rm(joinpath(@__DIR__, "..", "src", "ctypes.jl"))
