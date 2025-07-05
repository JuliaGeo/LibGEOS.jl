module LibGEOSMakieExt
using Makie: Makie
using LibGEOS: LibGEOS

GeoInterface.@enable_makie Makie LibGEOS.AbstractGeometry

end
