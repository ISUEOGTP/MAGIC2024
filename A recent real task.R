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

# Use tidycensus::load_variables to get a list of cencus variables
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


# Write the final output to an esri project geodatabase
# NOTE: This will not work on Posit Cloud!
library(arcgisbinding)
arc.check_product()

fgdb_path <- "magic_r_arcgis/magic_r_arcgis.gdb"
arc.write(path = file.path(fgdb_path, "ia_population_decennial"), data = ia_places_pop, overwrite = TRUE)
