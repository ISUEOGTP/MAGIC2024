## Modified from:
## https://r.esri.com/assets/arcgisbinding-vignette.html

## NOTE: Although we are including this file within the Posit Cloud workspace 
## for reference, this script will not work properly from a cloud system. 
## It needs to be run from a Windows computer with a valid install of 
# ArcGIS Pro.

# Load Libraries and Data ----

# If you installed R via ArcGIS Pro Options/Geoprocessing, you do not need 
# to repeat these steps. 
install.packages("arcgisbinding", 
                 repos="https://r.esri.com", 
                 type="win.binary")

# Load the binding library
library(arcgisbinding)

# Verify that you have the proper license
arc.check_product()


# Load some sample data
# This is coming from the arcgisbinding package, not Pro or a local file
ozone.path <- system.file("extdata", "ca_ozone_pts.shp",
                          package="arcgisbinding")

# View the path to the shapefile
ozone.path

# use arc.open() to open the dataset and assign it to a variable
ozone.arc.dataset <- arc.open(ozone.path)

# This is a type of arc object
class(ozone.arc.dataset)

# Use arc.shapeinfo() to get geometry information from the arcgisbinding object
# NAD 1983 Albers
arc.shapeinfo(ozone.arc.dataset)


# Access some metadata
ozone.arc.dataset@fields
ozone.arc.dataset@extent



# Use arc.select to select the OZONE field from the data set
# This will turn into into a data frame, a very useful structure in R
# Note that we did not select any SHAPE or geometry fields
ozone.df <- arc.select(object = ozone.arc.dataset, fields = 'OZONE')

# Examine the ozone data frame
ozone.df

# Use arc.shape to get info on the data frame.
arc.shape(ozone.df)

# Now it's also a data.frame, a very useful R object type
class(ozone.df)

# What is the distribution of the Ozone values?
hist(ozone.df$OZONE)

# If we plot this, it only plots the OZONE values
# It does not plot geometry
plot(ozone.df$OZONE, main = "OZONE value by Index ID")


# Convert to SF objects - a standard R Spatial format
ozone.sf <- arc.data2sf(ozone.df)

# Plot the sf object
# Can you guess the state based on these points?
plot(ozone.sf, pch=19)

# Install the mapview package
install.packages("mapview")
library(mapview)
mapview(ozone.sf)




# Output using arc.write ----

# An ArcGIS Pro project folder is included with this data. We will read and
# write to a geodatabase within magic_r_arcgis

# Create a path to the project goedatabase
# Double backslash or forward slash are valid path separators
fgdb_path <- "magic_r_arcgis\\magic_r_arcgis.gdb"
fgdb_path <- "magic_r_arcgis/magic_r_arcgis.gdb"

# Write the arc data
?arc.write       # It's always good to read the documentation
arc.write(path = file.path(fgdb_path, "ozone_from_r"), data = ozone.df, overwrite = TRUE)

# If you did not get an error message it probably worked! 

# Try writing the ozone sf object
arc.write(path = file.path(fgdb_path, "ozone_sf_from_r"), data = ozone.sf, overwrite = TRUE)

# Go into your ArcGIS Pro project and refresh the gdb -- you will see new FeatureClasses
# Drag one of the FeatureClasses onto a map to visualize. 


# Finally, let's open a FeatureClass that is already inside our project -- IowaCounties

?arc.open   # The help file for arc.open

# Set the path of our feature class, change your path as needed
counties_path <- "magic_r_arcgis/magic_r_arcgis.gdb/IowaCounties"

# Open the counties FeatureClass, assign it to a variable
ia_counties <- arc.open(counties_path)

# Turn it into a data frame
ia_counties_df <- arc.select(ia_counties)

library(sf)
# The following lines will produce the same output, except the plot title
plot(st_geometry(arc.data2sf(ia_counties_df)), main = "Plot using nested statements")

# The pipe method might be a little more readable? The choice is yours. 
ia_counties_df |> arc.data2sf() |> st_geometry() |> plot(main = "Plot using pipes")

# Exporting data from Pro just to make a basic plot is not the intended use
# of this package, but it works for our examples.  Ideally, you would use some 
# sort of custom functions or code that is not yet implemented within ArcGIS 
# Pro (or Python), then push the results back in to your Pro project geodatabase. 




