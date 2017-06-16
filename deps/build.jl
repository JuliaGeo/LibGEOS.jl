using BinDeps
@BinDeps.setup

libgeos = library_dependency("libgeos",aliases=["libgeos_c", "libgeos_c-1"], validate = function(path, handle)
    return Libdl.dlsym_e(handle,:initGEOS) != C_NULL && Libdl.dlsym_e(handle,:GEOSDelaunayTriangulation) != C_NULL
end)

version = "3.6.1"

provides(Sources, URI("http://download.osgeo.org/geos/geos-$(version).tar.bz2"), [libgeos], os = :Unix)
provides(BuildProcess,Autotools(libtarget = "capi/.libs/libgeos_c."*BinDeps.shlib_ext),libgeos)
# provides(AptGet,"libgeos-dev", libgeos)
# TODO: provides(Yum,"libgeos-dev", libgeos)
# TODO: provides(Pacman,"libgeos-dev", libgeos)

if is_windows()
    using WinRPM
    push!(WinRPM.sources, "http://download.opensuse.org/repositories/home:yeesian/openSUSE_Leap_42.2")
    WinRPM.update()
    provides(WinRPM.RPM, "libgeos", [libgeos], os = :Windows)
end

if is_apple()
    if Pkg.installed("Homebrew") === nothing
        error("Homebrew package not installed, please run Pkg.add(\"Homebrew\")")
    end
    using Homebrew
    provides(Homebrew.HB, "geos", libgeos, os = :Darwin)
end

@BinDeps.install Dict(:libgeos => :libgeos)
