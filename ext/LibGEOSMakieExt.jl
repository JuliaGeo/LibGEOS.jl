module LibGEOSMakieExt

import GeoInterface 
import LibGEOS
import Makie

GeoInterface.@enable_makie Makie LibGEOS.AbstractGeometry

end
