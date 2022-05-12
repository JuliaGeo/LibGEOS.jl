using Clang.Generators
using MacroTools
using GEOS_jll
using JuliaFormatter: format

function rewriter(dag::ExprDAG)
    for n in dag.nodes
        map!(rewriter, n.exprs, n.exprs)
    end
end

"Functions that return a Cstring are wrapped in unsafe_string to return a String"
function rewriter(x::Expr)
    if @capture(x, function f_(fargs__)
        ccall(fname_, rettype_, argtypes_, argvalues__)
    end)
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

cd(@__DIR__)

include_dir = joinpath(GEOS_jll.artifact_dir, "include") |> normpath

# wrapper generator options
options = load_options(joinpath(@__DIR__, "generate.toml"))

args = get_default_args()
push!(args, "-I$include_dir")

header_dir = include_dir
headers = [joinpath(header_dir, "geos_c.h")]

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx, BUILDSTAGE_NO_PRINTING)
rewriter(ctx.dag)
build!(ctx, BUILDSTAGE_PRINTING_ONLY)

# run JuliaFormatter on the whole package
format(joinpath(@__DIR__, ".."))
