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

includedir = normpath(joinpath(@__DIR__, "..", "deps", "usr", "include"))
headerfiles = [joinpath(includedir, "geos_c.h")]

wc = init(; headers = headerfiles,
            output_file = joinpath(@__DIR__, "geos_c.jl"),
            common_file = joinpath(@__DIR__, "geos_common.jl"),
            clang_includes = [includedir, CLANG_INCLUDE],
            clang_args = ["-I", includedir],
            header_wrapped = (root, current) -> root == current,
            header_library = x -> "libgeos",
            clang_diagnostics = true,
            )

run(wc)
