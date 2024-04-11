
# Piping, filtering, selecting Data ----
# One of the components of the tidyverse
# Not necessary to load entire tidyverse set if you only plan on using
# only one or two tools

library(dplyr)            

# dplyr (and now base R) allow you to "pipe" data from function to function by
# using a special operator: 
#        %>%  (dplyr)     or    |>  (base R)


# Dplyr also has built in functions like filter() and select() as alternatives
# to the data frame slicing methods covered earlier


# Instead of multiple nested function...
#         final_output <- function3(function2(function1(input_data)))


# Or multiple assignments...
#        out1 <- function1(input_data)
#        out2 <- function2(out1)
#        final_output <- function3(out2)


# The output of one function becomes the input of the next function
#        final_output <- input_data %>% function1() %>% function2() %>% function3()





# Try it out using mtcars data set
?mtcars

# View the first 8 rows of the mtcars data set
head(mtcars, 8)

# Which cars are the most efficient?
effecient_cars <- mtcars %>%  # Take the mtcars data set, then
  filter(mpg > 25) %>%        # filter for cars that meet our "efficient" cutoff, then
  select(mpg, cyl, wt) %>%    # Keep the fields miles per gallon, # of cylinders, and weight, then
  arrange(desc(mpg))          # arrange the data by mpg, high to low. 

# This table is assigned to the variable efficient_cars
effecient_cars

# Of the 8-cylinder cars, which ones are heaviest?
car_8cyl <- mtcars %>% 
  filter(cyl==8) %>% 
  select(mpg, wt) %>% 
  arrange(desc(wt))

head(car_8cyl, 3)     # Limits the output to the first 3 elements

# What is the average weight of a car, by cylinder count?
mtcars %>% 
  group_by(cyl) %>% 
  summarise(avg_wt = mean(wt))











# Pivot data from wide to long ----

library(tidyr)
library(stringr)
# Make a data frame
df <- data.frame(
  city = c("Cedar Falls", "Iowa City", "Ames"),
  d2000 = c(36145, 62220, 50731 ),
  d2010 = c(39260, 67862, 58965 ),
  d2020 = c(40713, 74828, 66427 ))

# Verify data frame
df

df_long <- df %>% pivot_longer(cols = starts_with("d2"),
                               names_to = "decennial",
                               values_to = "population") %>% 
  mutate(decennial = as.numeric(str_replace(decennial, "d2", "2")))

# A long data set
df_long



# Visualize with ggplot ---- 

library(ggplot2)

ggplot(data = df_long,
       aes(x = city, y=population, fill = as.factor(decennial))) +
  geom_bar(stat="identity", position="dodge") +
  geom_text(aes(label=population), position=position_dodge(width=0.9),
            vjust=-0.5,
            size=3,
            color="black",
            fontface="bold") +
  labs(tile = "title",
       x = "City",
       y = "Population",
       fill = "Decennial") +
  theme_minimal()












# Read and Plot geographic data ----
library(sf)

# Open a shapefile of Iowa counties
?read_sf
ia_counties_shp <- sf::read_sf("data/ia_counties_shp.shp")

# Take a look at the CRS
?st_crs
sf::st_crs(ia_counties_shp)

# Plot the geometry
?st_geometry
plot(sf::st_geometry(ia_counties_shp))



# Open a shapefile of all US counties
us_counties_shp <- sf::read_sf("data/cb_2021_us_county_20m/cb_2021_us_county_20m.shp")

# Examine the Coordinate Reference System
sf::st_crs(us_counties_shp)

# Plot the counties -- this is not a great looking plot...
plot(sf::st_geometry(us_counties_shp))

# Use filter to select just Iowa counties 
ia_counties <- us_counties_shp %>% dplyr::filter(STATEFP == '19')

# All three of these plot statements are equivalent
plot(st_geometry(ia_counties), main="Compound Statement Plot")

ia_counties |> st_geometry() |> plot(main="Base-R Pipe Statement Plot")

ia_counties %>% st_geometry() %>%  plot(main="dplyr Pipe Statement Plot")













# st_union & st_combine ----
# Union all the counties to make a single feature
ia_state <- st_union(ia_counties)

# Running the st_union dropped all of our attributes, and our object is now a
# sfc object, which is basically a geometry-only type of object
class(ia_state)   

# Plot the Unioned counties
ia_state %>% st_geometry() %>% plot(main ="Counties ST_UNION", axes=TRUE)

# Combine is similar, but keeps the internal boundaries
ia_combine <- st_combine(ia_counties)
ia_combine %>% st_geometry() %>% plot(main = "Counties ST_COMBINE",axes=TRUE)



# Filter four counties from central IA, union their geometry into a 
# single polygon, then turn that into an sf object
four_county_area <- ia_counties %>% 
  filter(NAME %in% c("Polk", "Dallas", "Boone", "Story")) %>% 
  st_union() %>% 
  st_sf()

# This is an sf and data.frame, not an sfc
class(four_county_area)

# Plot the geometry - does that look like the expected outcome?
four_county_area %>% st_geometry() %>% plot()

# Plot multiple layers together to view

dev.off() # This will clear out all the existing and previous plots
plot(st_geometry(ia_state), lwd=2)
plot(st_geometry(ia_counties), add=TRUE)
plot(st_geometry(four_county_area), col='steelblue', add=TRUE)








# Turn non-spatial data into a spatial object ----
# Now we read in some X-Y coordinates into a non-spatial data frame
?read.csv
seats <- read.csv("data/ia_co_seats.csv", header = T)

# The head function will display the first n rows of your data frame
?head
head(seats, 8)

#
?st_as_sf
# Turn the seats into POINT data, assign a CRS based on well-known ID
seats_sf <- st_as_sf(seats, coords = c("x","y"), crs=4326)
plot(st_geometry(seats_sf))

# Plot multiple layers together to view
plot(st_geometry(ia_state), lwd=2)
plot(st_geometry(ia_counties), add=TRUE)
plot(st_geometry(seats_sf), pch=19, cex=0.5,col="blue", add=TRUE)


#project counties to match seats points layers
#us_counties_shp <- st_transform(us_counties_shp, crs=st_crs(seats_sf))




# Remember the data set of all US counties? We will use that as our base map
# But limit the x and y view to max values we determine below using the
# bounding box of our spatial data

# Use st_bbox() to find the min and max X and Y values
?st_bbox
xmin <- st_bbox(seats_sf)[1] * 1.05
xmax <- st_bbox(seats_sf)[3] * .95
ymin <- st_bbox(seats_sf)[2]
ymax <- st_bbox(seats_sf)[4]





# Plot multiple layers together to view
plot(st_geometry(us_counties_shp), xlim=c(xmin, xmax), ylim=c(ymin, ymax),
     lwd=1, main="Iowa County Seat Locations")
plot(st_geometry(ia_state), border="red", lwd=2.5, add=TRUE)
plot(st_geometry(seats_sf), col="blue", pch=19, cex=.5, add=TRUE)

# Even though our Ymin and Ymax were not changed from the bounding box results,
# The plot() function will try to maintain the same aspect-ration in its output









# Displaying geometry functions in SF ----
# Let's make a three-sided polygon using the centroids of three Iowa
# counties as vertices

# First, filter the counties, find their centroids, extract the coordinates
?sf::st_centroid
?sf::st_coordinates
tri_county_coords <- ia_counties %>% 
  filter(NAME %in% c("Tama", "Delaware", "Henry")) %>% 
  st_centroid() %>% 
  st_coordinates()

# These are the centroids of the counties selected above
tri_county_coords

# In order to make a closed polygon, we need to repeat the first & last coord
# The rbind function will append the rows of parameter 2, on to the rows of 
# parameter 1. In this case, parameter 2 is the first row of the data frame
tri_county_coords <- rbind(tri_county_coords, tri_county_coords[1,])
tri_county_coords

# Turn the coordinates into a list, pass it to st_polygon,
# turn that into an sfc object, then turn that into an sf object
?list
?st_polygon
?st_sfc
?st_sf

triangle <- tri_county_coords %>% 
  list() %>% 
  st_polygon() %>% 
  st_sfc(crs = st_crs(ia_counties)) %>% 
  st_sf()

# It's a triangle!
triangle |> st_geometry() |> plot()

# We can add the plot axes and see that this object has spatial information
triangle |> st_geometry() |> plot(axes=TRUE)


# Plot multiple layers together to view
plot(st_geometry(ia_state), lwd=2, axes=TRUE)
plot(st_geometry(ia_counties), add=TRUE)
plot(st_geometry(four_county_area), col='red', add=TRUE)
plot(st_geometry(triangle), col='green', add=TRUE)



# Save a spatial object as a shapefile ----
?st_write
st_write(triangle, "data/ia_triangle.shp", delete_layer = TRUE )

# Supports postgres database connections
# Does not support esri file geodatabase
# This will open just fine in Pro









# Create a buffer around a point ----
# First, filter the counties, find their centroids, extract the coordinates
cherokee_centroid <- ia_counties %>% 
  filter(NAME =="Cherokee") %>% 
  st_centroid()

# Make a 50 KM buffer around the cetroid of Cherokee county
cherokee_buffer <- cherokee_centroid %>% 
  st_buffer(dist=50000)

# It looks like a circle!
cherokee_buffer %>% st_geometry() %>% plot()

# And it has geographic information
cherokee_buffer %>% st_geometry() %>% plot(axes=TRUE)





# Plot multiple layers together to view ----
# This uses the sf implementation of plot()
plot(st_geometry(ia_state), lwd=2)
plot(st_geometry(ia_counties), add=TRUE)
plot(st_geometry(four_county_area), col='red', add=TRUE)
plot(st_geometry(triangle), col='green', add=TRUE)
plot(st_geometry(cherokee_buffer), col="steelblue", add=TRUE)



# Make a map using ggplot ----
dev.off()
?geom_sf
ggplot() +
  geom_sf(data = ia_state, fill="white") +
  geom_sf(data = ia_counties, fill="grey90") +
  geom_sf(data = four_county_area, fill="red") +
  geom_sf(data = triangle, fill="green") +
  geom_sf(data =cherokee_buffer, fill="steelblue") +
  theme_void()




# Make a map using MapView ----
#install.packages("mapview")
library(mapview)
mapview(ia_state, col.region="white", lwd=3,
        basemaps = "Esri.WorldImagery") + 
  mapview(ia_counties, col.region="grey80") + 
  mapview(four_county_area, col.region="red") +
  mapview(triangle, col.region="green") +
  mapview(cherokee_buffer, col.region="steelblue")





# Spatial Intersections ----
# So now we have some geographic areas that overlay with Iowa counties
# Let's try to figure out which counties intersect these geometries

?st_intersection
?pull
cherokee_buffer %>% 
  st_intersection(ia_counties) %>% 
  pull(NAME.1)

triangle %>% 
  st_intersection(ia_counties) %>% 
  pull(NAME)



