using BinDeps, Compat
@BinDeps.setup

libgeos = library_dependency("libgeos",aliases=["libgeos_c", "libgeos_c-1"])

version = "3.4.2"

provides(Sources, URI("http://download.osgeo.org/geos/geos-$(version).tar.bz2"), [libgeos], os = :Unix)
provides(BuildProcess,Autotools(libtarget = "capi/.libs/libgeos_c."*BinDeps.shlib_ext),libgeos)
provides(AptGet,"libgeos-dev", libgeos)
# TODO: provides(Yum,"libgeos-dev", libgeos)
# TODO: provides(Pacman,"libgeos-dev", libgeos)

@windows_only begin
    using WinRPM
    push!(WinRPM.sources, "http://download.opensuse.org/repositories/home:yeesian/openSUSE_13.1")
    push!(WinRPM.sources, "http://download.opensuse.org/repositories/home:yeesian/windows_mingw_win32_openSUSE_13.1")
    WinRPM.update()
    provides(WinRPM.RPM, "libgeos", [libgeos], os = :Windows)
end

@osx_only begin
    if Pkg.installed("Homebrew") === nothing
        error("Homebrew package not installed, please run Pkg.add(\"Homebrew\")")
    end
    using Homebrew
    provides(Homebrew.HB, "geos", libgeos, os = :Darwin)
end

@BinDeps.install @compat Dict(:libgeos => :libgeos)
