using Clang.Generators
using Clang
using MacroTools
using GEOS_jll
using JuliaFormatter: format

function return_type_is_const_char(cursor::Clang.CLFunctionDecl)
    result_type = Clang.getCanonicalType(Clang.getCursorResultType(cursor))
    if result_type isa CLPointer
        destination = Clang.getPointeeType(result_type)
        return destination isa CLChar_S && Clang.isConstQualifiedType(destination)
    end
    return false
end

"Functions that return a Cstring are wrapped in unsafe_string to return a String"
function rewrite(ex::Expr, cursor::Clang.CLFunctionDecl)
    if @capture(ex, function fname_(fargs__)
        @ccall lib_.cname_(cargs__)::rettype_
    end)
        # bind the ccall such that we can easily wrap it
        cc = :(@ccall $lib.$cname($(cargs...))::$rettype)

        cc′ = if rettype == :Cstring
            # do not try to free a const char *
            if return_type_is_const_char(cursor)
                :(unsafe_string($cc))
            else
                :(string_copy_free($cc))
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
        if !isa(n.cursor, Clang.CLFunctionDecl)
            continue
        end
        map!(e -> rewrite(e, n.cursor), n.exprs, n.exprs)
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
