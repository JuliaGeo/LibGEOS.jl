using Clang.LibClang
using Clang.Generators
using MacroTools
using GEOS_jll
using JuliaFormatter: format

"Functions that return a Cstring are wrapped in unsafe_string to return a String"
function rewrite(ex::Expr)
    if @capture(ex, function fname_(fargs__)
        @ccall lib_.cname_(cargs__)::rettype_
    end)

        # bind the ccall such that we can easily wrap it
        cc = :(@ccall $lib.$cname($(cargs...))::$rettype)

        cc′ = if rettype == :Cstring
            # do not try to free a const char *
            # this is the only function returning such type
            if cname == :GEOSversion
                :(unsafe_string($cc))
            else
                :(transform_c_string($cc))
            end
        else
            cc
        end

        # stitch the modified function expression back together
        f = :(function $fname($(fargs...))
            $cc′
        end) |> prettify

        return f
    end
    return ex
end

function rewrite!(dag::ExprDAG)
    for n in dag.nodes
        map!(rewrite, n.exprs, n.exprs)
    end
end

cd(@__DIR__)

include_dir = joinpath(GEOS_jll.artifact_dir, "include") |> normpath

# wrapper generator options
options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()
push!(args, "-I$include_dir")

header_dir = include_dir
headers = [joinpath(header_dir, "geos_c.h")]

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx, BUILDSTAGE_NO_PRINTING)
rewrite!(ctx.dag)
build!(ctx, BUILDSTAGE_PRINTING_ONLY)

# run JuliaFormatter on the whole package
format(joinpath(@__DIR__, ".."))
