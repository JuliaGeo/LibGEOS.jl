module LibGEOSMakieExt
using GeoInterfaceMakie: GeoInterfaceMakie
using LibGEOS: LibGEOS

GeoInterfaceMakie.@enable Makie LibGEOS.AbstractGeometry

end
