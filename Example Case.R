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
library(tigris)
library(dplyr)
library(ggplot2)
library(plotly)




# Use tidycensus::load_variables to get a list of Census variables
# This can be useful if you are not sure what the table / variable name is
# ?load_variables
# var_2020_pl <- load_variables(2020, "pl", cache = TRUE)
# View(var_2020_pl)

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
?places
ia_places <- places(cb = FALSE, state="IA")
# ia_places %>% st_geometry() %>% plot()



# Enrich the spatial data by left_join-ing with population counts
?full_join


ia_places_pop <- ia_places %>% 
  full_join(d2020, by="GEOID", suffix = c(".x", ".d2020")) %>% 
  full_join(d2010, by="GEOID", suffix = c(".x", ".d2010")) %>% 
  full_join(d2000, by="GEOID", suffix = c(".x", ".d2000")) %>% 
  select(c(1:15, d2020 = "P1_001N", d2010 = "P001001.x", d2000 = "P001001.d2000" )) %>% 
  rename(NAME = "NAME.x")

# This object has all the usual fields you find in a US Census Shapefile,
# and we have added 3 fields of decennial population data
View(ia_places_pop)

# Output a shape file (I removed the ALAND attribute because the large values 
# don't play nice without some handling and some records do not get written)
st_write(ia_places_pop %>% select(-ALAND), "data/ia_places_pop.shp", 
         delete_layer = TRUE)



# Write the final output to an esri project geodatabase
# NOTE: This will not work on Posit Cloud!
# library(arcgisbinding)
# arc.check_product()
# 
# fgdb_path <- "magic_r_arcgis/magic_r_arcgis.gdb"
# arc.write(path = file.path(fgdb_path, "ia_population_decennial"), data = ia_places_pop, overwrite = TRUE)




# Explore the data for some insights... ----

# Data for mapping (This is covered later!)
# Load a shapefile of all US counties
us_counties_shp <- sf::read_sf("data/cb_2021_us_county_20m/cb_2021_us_county_20m.shp")
# Filter to just Iowa counties
ia_counties <- us_counties_shp %>% dplyr::filter(STATEFP == '19')
# Union the counties to make a state border
ia_state <- st_union(ia_counties)


# Goal: Make a data frame of population change in Iowa cities between 
# 2010 and 2010

# Start with our joined population data, 
# then calculate the count difference between decennials
# then calculate the percentage of difference,
# then select certain columns,
# then arrange in order of difference percentage, descending
# then 

ia_pop_change <- ia_places_pop %>% 
  mutate(diff_count = d2020-d2010) %>% 
  mutate(diff_perc = round(100 * diff_count / d2010,2)) %>% 
  select(GEOID, NAME, d2020, d2010, diff_count, diff_perc) %>% 
  arrange(desc(diff_perc)) %>% 
  st_centroid()


# Plot 1: Plot the growth / decline of Iowa cities

# Seperate the data into a growth data frame and a loss data frame
ia_lost_population <- ia_pop_change %>% 
  filter(diff_perc < 0) 

ia_gain_population <- ia_pop_change %>% 
  filter(diff_perc >= 0)


# Plot 1 - Illustrates the communities that have lost population
# Bigger circle = more population lost
g <- ggplot() +
  ggtitle("Population Change Between 2020 and 2010") +
  geom_sf(data = ia_counties, fill="white", color="gray80") +
  geom_sf(data = ia_state, fill=NA, linewidth=1.1, color="gray30")+ 
  geom_sf(data = ia_lost_population, 
          aes(size=-diff_perc, text=paste("City:",NAME) ), 
          color="red", alpha=.75) +
  geom_sf(data = ia_gain_population, 
          aes(size=diff_perc, text=paste("City:",NAME)),
          color="steelblue", alpha=.75)+
  theme_void() +
  theme(legend.position = "none") +
  labs(caption = "Blue = growth | red = decline")

g

ggplotly(g)



# Some basic statistics on the population loss
mean(ia_lost_population$diff_perc)
median(ia_lost_population$diff_perc)  # less effected by outliers


# Which towns have the highest percentage lost?

# Start with our lost population data set,
# then select only the fields we want,
# then arrange by percent change,
# then drop the geomoetry data,
# then select only the first 10 records
ia_lost_population %>% 
  select(NAME, d2020, d2010, diff_perc) %>% 
  arrange(diff_perc) %>% 
  st_drop_geometry() %>% 
  head(10)










# Can we better visualize the relation between 2020 population and the 
# percentage of population lost/gained? 
# A scatter plot with tool-tips enabled!


# Make a new ggplot object and call it p
g <- ggplot(ia_pop_change, 
            aes(text=paste("City:",NAME), x=d2020, y = diff_perc)) +
  geom_point(aes(size=d2020)) +
  #scale_color_gradient2(low="red", high="blue") +
  geom_hline(yintercept  = 0, color="red", linetype="dashed") +
  geom_vline(xintercept = 5000, color="steelblue") +
  ggtitle("Percent Population Change by 2020 Decennial Population") +
  labs(x = "2020 Decennial Population", y ="Population Change (%)")

g
# pass the ggplot object into the plotly interactive package
ggplotly(g)

# Population on X, increases as moving left
# Population percentage on Y, increases as moving up
# Hover over a point to see the attributes for name, d2020, and diff_perc
