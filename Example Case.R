# TidyCensus data acquisisition example
# Jay Maxwell
# Iowa State University Extension & Outreach

# A few weeks ago Chris asked me to acquire some data for a project. He wanted
# the current and two previous decennial population counts for all the cities 
# in Iowa. This script will use a package called TidyCensus that acts as a wrapper
# for the US Census api. In addition to numeric data, this package also allows
# us to acquire the TIGER\Line data from Census as well. The data is then saved
# to a file geodatabase for visualization in ArcGIS Pro. 



library(tidycensus)
library(sf)

# Use tidycensus::load_variables to get a list of Census variables
# This can be useful if you are not sure what the table / variable name is
?load_variables
var_2020_pl <- load_variables(2020, "pl", cache = TRUE)
var_2020_pl

# Use tidycensus::get_decennial to get 3 previous decennial population
# counts for cities in Iowa
?get_decennial
d2020 <- get_decennial(year = 2020,
              geography = "place",
              state = "IA",
              output = "wide",
              variables = "P1_001N")

d2010 <- get_decennial(year = 2010,
                       geography = "place",
                       state="IA",
                       output = "wide", 
                       variables = "P001001")

d2000 <- get_decennial(year = 2000,
                       geography = "place",
                       state="IA",
                       output = "wide",
                       variables = "P001001")


# tigris accesses TIGER linework via the US Census API
library(tigris)
?places
ia_places <- places(cb = FALSE, state="IA")
ia_places %>% st_geometry() %>% plot()



# Enrich the spatial data by left_join-ing with population counts
library(dplyr)
?left_join

ia_places_pop <- ia_places %>% 
  left_join(d2020, by="GEOID", suffix = c(".x", ".d2020")) %>% 
  left_join(d2010, by="GEOID", suffix = c(".x", ".d2010")) %>% 
  left_join(d2000, by="GEOID", suffix = c(".x", ".d2000")) %>% 
  select(c(1:15, d2020 = "P1_001N", d2010 = "P001001.x", d2000 = "P001001.d2000" )) %>% 
  rename(NAME = "NAME.x")


# We can do a quick plot, but at the default scale we can't really differentiate
# population counts or changes between the years.
ia_places_pop %>% select(d2000, d2010, d2020) %>% plot(main = "Iowa Cities - Decennial Counts")


# Output a shape file (I removed the ALAND attribute because the large values 
# don't play nice without some handling and some records do not get written)
st_write(ia_places_pop %>% select(-ALAND), "data/ia_places_pop.shp", delete_layer = TRUE)



# Write the final output to an esri project geodatabase
# NOTE: This will not work on Posit Cloud!
library(arcgisbinding)
arc.check_product()

fgdb_path <- "magic_r_arcgis/magic_r_arcgis.gdb"
arc.write(path = file.path(fgdb_path, "ia_population_decennial"), data = ia_places_pop, overwrite = TRUE)




# Explore the data for some insights... ----

# Data for mapping (This is covered later!)
# Load a shapefile of all US counties
us_counties_shp <- sf::read_sf("data/cb_2021_us_county_20m/cb_2021_us_county_20m.shp")
# Filter to just Iowa counties
ia_counties <- us_counties_shp %>% dplyr::filter(STATEFP == '19')
# Union the counties to make a state border
ia_state <- st_union(ia_counties)


# Make a data frame of all cities in Iowa that have a lower decennial 2020
# population than the 2010 decennial
# Start with our joined population data, 
# then filter to only places where 2020 population is less than 2010 population
# then calculate the absolute value of the difference,
# then calculate the percentage of difference,
# then select certain columns,
# then arrange in order of difference percentage, descending
# then 

ia_lost_population <- ia_places_pop %>% 
  filter(d2020 < d2010) %>% 
  mutate(pop_diff = abs(d2020-d2010)) %>% 
  mutate(diff_perc = round(100 * pop_diff / d2010,2)) %>% 
  select(GEOID, NAME, d2020, d2010, pop_diff, diff_perc) %>% 
  arrange(desc(diff_perc)) %>% 
  st_centroid()




library(ggplot2)

# Plot 1: size: 2020 Decennial Population,
#         color: population loss = red; population gain = black

ggplot() +
  ggtitle("Iowa Towns that Lost Population between 2020 and 2010") +
  geom_sf(data = ia_counties, fill="white", color="gray80") +
  geom_sf(data = ia_state, fill=NA, linewidth=1.1, color="gray30")+ 
  geom_sf(data = st_centroid(ia_places_pop), aes(size=d2020), color="black") +
  geom_sf(data = ia_lost_population, aes(size=d2020), color="red") +
  labs(size = "2020 Decennial") +
  theme_void()

# Plot 2: size: 2020 Decennial Population,
#         color: lower percentage lost = lighter red
#                higher percentage lost = darker red

ggplot() +
  ggtitle("Iowa Towns that Lost Population between 2020 and 2010") +
  geom_sf(data = ia_counties, fill="white", color="gray80") +
  geom_sf(data = ia_state, fill=NA, linewidth=1) + 
  geom_sf(data = st_centroid(ia_places_pop), aes(size=d2020), color="gray30") +
  geom_sf(data = ia_lost_population, aes(size=d2020, color=diff_perc)) +
  scale_color_gradient(low="#FF9999", high = "#FF0000") +
  labs(size= "2020 Population", color = "Percentage Decrease") +
  theme_void()

# A histogram shows difference percentage is skewed right
# A lot of towns have relatively low percentage loss
hist(ia_lost_population$diff_perc)

# Some basic statistics on the population loss
mean(ia_lost_population$diff_perc)
median(ia_lost_population$diff_perc)  # less effected by outliers


# Which towns have the higest percentage lost?
ia_lost_population %>% 
  select(NAME, d2020, d2010, diff_perc) %>% 
  arrange(desc(diff_perc)) %>% 
  st_drop_geometry() %>% 
  head(10)

# What are the 'big' cities in the  list, and how much population did they lose?
# Clinton, Burlington, Fort Madison, and Keokuk are the biggest cities with
# the largest percentage of loss
ia_lost_population %>% 
  arrange(desc(d2020)) %>% 
  select(NAME, d2020, d2010, diff_perc) %>% 
  st_drop_geometry() %>% 
  head(10)


# Can we better visualize the relation between 2020 population and the 
# percentage of population lost? 
# A scatter plot with tool-tips enabled!

# Make a new ggplot object and call it p
p <- ggplot(ia_lost_population, aes(text=paste("City:",NAME), x=d2020, y = diff_perc)) +
  geom_point() +
  ggtitle("Percent Population Loss x 2020 Decennial Population") +
  labs(x = "2020 Decennial Population", y ="Population Loss (%)")

# pass the ggplot object into the plotly interactive package
library(plotly)
ggplotly(p)

# Population on the bottom, increases as moving left
# Population percentage on left, increases as moving up
# Hover over a point to see the attributes for name, d2020, and diff_perc
