module LibGEOSMakie
using GeoInterfaceMakie: GeoInterfaceMakie
using LibGEOS: LibGEOS

GeoInterfaceMakie.@enable LibGEOS.AbstractGeometry

end
