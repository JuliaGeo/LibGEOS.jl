module LibGEOSRecipesBaseExt
using RecipesBase: RecipesBase
using LibGEOS: LibGEOS

GeoInterface.@enable_plots RecipesBase LibGEOS.AbstractGeometry

end
