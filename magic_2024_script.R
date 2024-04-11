## Spatial Data Science and R
## Jay Maxwell & Chris Seeger
## Iowa State University Extension & Outreach
##
## MAGIC - Conference 2024


# Inspirational Map ----

# Acquire US Census data via the API using tidyCensus
# Visualize the data using ggplot

library(tidyverse)
library(tidycensus)    # Make sure tidyCensus is 1.4!

# Data acquisition
ia_income <- get_acs(
  geography = "county",
  variables = "B19013_001",   # Median Household Income in the past 12 months
  state = "IA",
  year = 2022,
  geometry = TRUE,
  cb = TRUE, # US Census Cartographic Boundary geometry data by default. 
            # Can specify TIGER/Line with FALSE
)

ia_income


# Choropleth map of IA Census Tracts
ia_income %>% 
  ggplot(aes(fill = estimate)) +
  geom_sf() +
  scale_fill_distiller(palette = "Oranges", direction = 1) +
  labs(title = " Median Income by County",
       caption = "Data Source: 2022 5-year ACS, US Census Bureau",
       fill = "ACS estimate") +
  theme_void()


# A quick and easy slippy map using mapView
library(mapview)
mapview(ia_income, zcol="estimate")



# Getting Started ----


# Why R?
# How can R benefit GIS professionals?



# Install R:         https://cran.r-project.org/
# Install RStudio:   https://posit.co/products/open-source/rstudio/

# Tour of RStudio


# Coding in RStudio

# Code can entered in the console or saved in a .R script

# Lines beginning with hash / pound sign are comments and do not run
# To run a line of code, place cursor on the line, press control-enter (Windows)
#                                                        command-enter (Mac)
# To run MULTIPLE lines of code, highlight a block of code, press control-enter (Windows)
#                                                                 command-enter (Mac)

# Extending R: Installing Packages

# Third-party packages provide extra functionality by providing 
# both functions and data. Before writing your own complex function, do some 
# searching to see if somebody has already written a package to solve your
# problems

# install.packages will install from a repository of software approved and 
# hosted by CRAN - Comprehensive R Archive Network

install.packages("PackageName")     # To install a package
library(PackageName)                # To load the package into your environment

# To install multiple packages
install.packages(c("package1", "package2", "package3"))    



install.packages("tidyverse")      # A very popular data-science oriented package
install.package("tidycensus")      # A package to acquire US Census data via the API
                                   # Must have version 1.4 (released May 27, 2023) 
                                   # or higher for this demo code.

# After a package has been installed, you need to library() it to add it to the 
# active environment
library(tidyverse)
library(tidycensus)



# Operators ----

# Computers do TWO things very fast: perform calculation & make comparisons

## Arithmetic Operators ----

1 + 1           # Addition
6 - 3           # Subtraction
4 * 2           # Multiplication
16 / 5          # Division
2^3             # Exponent


## Comparison Operators ----
# The result of a comparison is Logical: TRUE or FALSE
1 < 5           # Less than
10 > 2          # Greater than
2 <= 2          # Less than or equal to
7 >= 9          # Greater than or equal to
10 == 4         # Equal to
5 != 4          # Not equal to


## Assignment Operators ----
# A variable "holds" a value assigned to it for later reference. A variable can 
# be over-written with new values. 

# The "R way" of assigning a value (20) to a variable, Right to Left, using <-
myVariable <- 10

# When an assignment is made, output is not automatically generated
# To see the results, run the variable

myVariable


# The "usual way" of assignment in most languages, use =
# This works in R!
myVariable2 = 10
myVariable2


# This does not work! = only assigns from right to left
10 = myVariable






# Functions ----

# Functions are reusable bit of code that (usually) take some type of input,
# perform a calculation or comparison, then return some type of output. 
# R has many built-in functions for math, statistics, string operations 
# and more. 
# You can write your own functions and reuse them. This is better than 
# copy-pasting blocks of code. 

# A few examples.... too many to cover them all!

## Math Functions ----



sqrt(144)           # Calculate the square root of 144
round(3.14159, 3)   # Round the 3.14159 to 3 decimals
floor(3.14159)      # Find the first integer less than 3.14159
ceiling(3.14159)    # Find the first integer greater than the 3.14159


## Statistics Functions ----

# Most statistical functions need a vector of data
data <- c(120, 101, 97, 132, 140, 105)    #Chris' typical bowling scores

mean(data)          # Calculate the mean of the input
sd(data)            # Calculate the standard deviation
max(data)           # Find the largest element in the vector
min(data)           # Find the smallest element in the vector
sum(data)           # Sum all the elements of the vector


answer <- sqrt(144)   # The result of a function can be assigned to a variable
answer                # But the assignment will not always generate output





## Build your own functions ----

# Declare a simple function with no input
# When the function code has been run, it will appear in the "Functions" section
# of the environment pane. 

hello_function <- function(name="Bob") {         # The function is named hello_function
  print(paste0("Hello ", name,"! Welcome to MAGIC 2023"))               # It returns "Hello world" as output
}
hello_function()
hello_function("Jerry")



# Values passed into a function are called arguments, and are only available 
# inside of the body of the function
doubleFunction <- function(argument1) {
  return(argument1 * 2)
}

doubleFunction(8)
doubleFunction(7)

# This object will not be found
argument1


# A function with two arguments
addFunction <- function(arg1, arg2) {
  # You can place all the code you want
  # inside of the function brackets {}
  return(arg1 + arg2)
}

addFunction(20, 22)
addFunction(100, 400)







# Primitive Data Types ----

# The basic building block of a more complex data structure

3.14159         # Numeric, a continuous number. AKA: real, double
42L             # Integer, a whole number. "L" for "Long Integer"
TRUE            # Logical, ie, TRUE or FALSE, T or F, 1 or 0. AKA: boolean.
"some words"    # character, a sequence of letters, numbers, and symbols. AKA: string



# Vectors ----

# Use the c() function to "combine"  like primitive values into a single object
# Behave similar to ARRAYs in other languages
# All elements must be of the SAME type

myVector <- c(10, 20, 30, 40, 50)    # Create a numeric vector of 5 elements
myVector

# Access vector elements using bracket [] notation
# R uses 1 as the beginning position, not 0

myVector[1]    # Access the first element
myVector[0]    # Vectors do not start at 0!
myVector[5]    # Access the last element


# Slicing using   :   (colon)
myVector[1:3]  # Access the first 3 elements
myVector[3:5]  # Access the last 3 elements


# How do we access multiple, non-adjacent items in a vector?
myVector[1,3,5]       # This does not work

# We use another vector!
myVector[c(1,3,5)]    # Access the first, third, and fifth element
one_three_five <- c(1,3,5) # Create a new vector to use as a selection
myVector[one_three_five]   # Use the new vector to select



# Vectors don't have to be solely numeric
charVector <- c("apple", "orange", "pear", "cherry", "banana")
charVector

# Any primitive type can be a vector
logicVector <- c(TRUE, FALSE, TRUE, FALSE, TRUE)
logicVector


# Logical vectors (above) can be used to make selections
# TRUE will select an element, FALSE will omit

charVector[c(TRUE,FALSE,TRUE,FALSE,TRUE)]
myVector[c(T,F,T,F,T)]

charVector[logicVector]
myVector[logicVector]

# Because elements 1, 3, and 5 of the logical vector are true...
# We get the first, third, and fifth elements
# This is important later!


# Data Frames ----

# Primitive -> Vector -> Data Frame

# A data frame is like a spreadsheet page. Data is in a table arranged by 
# columns and rows. If combining multiple vectors into a data frame, the 
# vectors MUST BE THE SAME LENGTH, ie, have the same number of elements.

# Three related vectors
name <- c("Bobby", "Sally", "Steve", "Erin", "Joe")
act_score <- c(23, 34, 31, 25, 32)
college <- c("UNI", "ISU", "Iowa", "Drake", "ISU")

# Basic data frame creation
# The vector names will be the column headers
df <- data.frame(name, act_score, college)
df          # Output to console
View(df)    # View in a new tab

# Accessing data frame content -- similar to vector slicing
# Many different ways to get the same results!
# It takes practice!

# When a single argument is in the brackets, returns COLUMN
df[1]               # Get column by column index, all rows
df["name"]          # Get column by name, all rows

# Slicing works in data frames, too
df[1:2]             # Get multiple columns by index
df[c("name", "act_score")]



# When there are two arguments inside the brackets, separated by a comma,
# first item refers to row(s), second refers to column(s)

# Example: myDF[ROW_index, COL_index]

# When ROW or COL selection is omitted, ALL elements are selected
df[1, ]               # Returns first row, ALL columns
df[ , 1]              # Returns all rows, FIRST column

# Use  -  (minus) to OMIT elements
# Because sometimes it is easier to say 'exclude this' 
# than 'include all these'
df[-(3:5), -2]         # Omits rows 3,4,5, omits column 2
df[1:2 , c(1,3)]       # Returns rows 1,2, and columns 1,3


# Column data can be accessed using $ after the data frame variable name
df$name
df$act_score
df$college

# Element-wise comparisons of data frame columns will output a LOGICAL vector
df$name == "Bobby"           # Compares each element in df$name to "Bobby"
df$name == "Jerry"
df$act_score >= 30           # Numeric comparison



# The logical vectors returned by element comparisons
# can be used to select ROWS from a data frame
df$act_score >= 30        

df[df$act_score >= 30,]   # Returns rows where act_score is greater than or equal to 30, + all columns
df[df$college == "ISU",]  # Returns rows where college is ISU, + all columns

# You can assign selections into a new variable
isu_df <- df[df$college == "ISU",]    
isu_df
class(isu_df)

# How many rows & columns does our subset data frame have?
nrow(isu_df)
ncol(isu_df)

# If this seems confusing, it's because it is!
# To help deal with filtering and selecting data frame elements,
# dplyr to the rescue!



# Piping, filtering, selecting Data ----
# One of the components of the tidyverse
# Not necessary to load entire tidyverse set

library(dplyr)                      

# dplyr (and now base R) allow you to "pipe" data from function to function by
# using a special operator:  %>%  (dplyr)  or   |>  (base R)

# Dplyr also has built in functions like filter() and select() as alternatives
# to the data frame slicing methods covered ealier

# Instead of multiple nested function...
final_output = function3(function2(function1(input_data)))

# Or multiple assignments...
out1 <- function1(input_data)
out2 <- function2(out1)
final_output <- function3(out2)


# The output of one function becomes the input of the next function
final_output <- input_data %>% function1() %>% function2() %>% function3()


# Try it out using mtcars data

# Which cars are the most efficient?
effecient_cars <- mtcars %>% 
  filter(mpg > 25) %>% 
  select(mpg, cyl, wt) %>% 
  arrange(desc(mpg))

effecient_cars

# Of the 8-cylinder cars, which ones are heaviest?
car_8cyl <- mtcars %>% 
  filter(cyl==8) %>% 
  select(mpg, wt) %>% 
  arrange(desc(wt))

head(car_8cyl, 4)     # Limits the output to the first 4 elements

# What is the average weight of a car, by cylinder count?
mtcars %>% 
  group_by(cyl) %>% 
  summarise(avg_wt = mean(wt))



# Plotting Data ----

# A VERY basic scatter plot of our act_scores data
plot(df$act_score, main="Scatterplot of df$act_score")  

# Barplot is a slightly better choice
barplot(df$act_score, 
        names.arg = df$name, 
        main = "Barplot of df$act_score",
        xlab = "Students",
        ylab = "Score"
        )  

# A histogram of our small data set
hist(df$act_score)    


# Built in Data set for practice!
mtcars                # mtcars dataset is great for exploring plots
View(mtcars)          # It is a built-in data set and always available

# What is mtcars? Read the documentation page!
?mtcars

# Show a plot of fuel usage by weight
plot(x = mtcars$wt, y = mtcars$mpg)

# Miles per gallon by weight
# Colored by number of cylinders + simple legend
plot(x = mtcars$wt, 
     y = mtcars$mpg, 
     col= mtcars$cyl,
     pch = 16,
     main= "MPG by Weight",
     xlab = "Weight (in 1000 pounds)",
     ylab = "Miles per gallon")

legend("topright",
       legend = paste0(unique(mtcars$cyl), "-cyl"),
       fill = unique(mtcars$cyl))

# Boxplot of MPG
boxplot(mtcars$mpg)

# Boxplot of fuel usage by number of cylinders
boxplot(mpg ~ cyl, data=mtcars)

# Histogram of mpg
hist(mtcars$mpg)

# Plots can be exported via the Plot window or programmatically











# Showing off with R ----

# Tidycensus + tmap
# Use tidyCensus to get the decennial data for all counties in the state of Iowa
PolkCounty_race <- get_decennial(
  geography = "tract",
  state = "IA",
  county = "Polk",
  variables = c(
    Hispanic = "P2_002N",
    White = "P2_005N",
    Black = "P2_006N",
    Native = "P2_007N",
    Asian = "P2_008N"
  ),
  summary_var = "P2_001N",
  year = 2020,
  geometry = TRUE
) %>%
  mutate(percent = 100 * (value / summary_value))

# View the data in its own window / tab
View(PolkCounty_race)

# To do some mapping we need the tmap package.
install.packages("tmap") 
library(tmap)

polk_hispanic <- filter(PolkCounty_race, 
                         variable == "Hispanic")

# Display Chloropleth of percent black for Polk County
tm_shape(polk_hispanic) + 
  tm_polygons(col = "percent")


tm_shape(polk_hispanic) + 
  tm_polygons(col = "percent",
              style = "quantile",
              n = 5,
              palette = "Purples",
              title = "2020 US Census") + 
  tm_layout(title = "Percent Hispanic",
            frame = FALSE,
            legend.outside = TRUE)


# maybe show a facet of maps for all the races
tm_shape(PolkCounty_race) + 
  tm_facets(by = "variable", scale.factor = 4) + 
  tm_fill(col = "percent",
          style = "quantile",
          n = 6,
          palette = "Blues",
          title = "Percent (2020 Census)",) + 
  tm_layout(bg.color = "grey", 
            legend.position = c(-0.7, 0.15),
            panel.label.bg.color = "white")





# Population Pyramid
# The list of variables containing age / sex breakdowns
myVars <- c("DP1_0026C", "DP1_0027C", "DP1_0028C", "DP1_0029C", "DP1_0030C", "DP1_0031C", "DP1_0032C", "DP1_0033C", "DP1_0034C", "DP1_0035C", "DP1_0036C", "DP1_0037C", "DP1_0038C", "DP1_0039C", "DP1_0040C", "DP1_0041C", "DP1_0042C", "DP1_0043C", "DP1_0050C", "DP1_0051C", "DP1_0052C", "DP1_0053C", "DP1_0054C", "DP1_0055C", "DP1_0056C", "DP1_0057C", "DP1_0058C", "DP1_0059C", "DP1_0060C", "DP1_0061C", "DP1_0062C", "DP1_0063C", "DP1_0064C", "DP1_0065C", "DP1_0066C", "DP1_0067C")

# Use tidyCensus to get the decennial data for all the places (cities/towns)
# in the state of Iowa
ia_pop <- get_decennial(
  sumfile = "dp",
  geography = "place",
  variables = myVars,
  state="IA",
  year = 2020
)

# View the data in its own window / tab
View(ia_pop)


# All of the code to make a population pyramid is in a function
# Must load the function into the environment before running

makePyramid <- function(town) {
  selected_city_df <- ia_pop %>% filter(grepl(town, NAME))
  
  maxValue <- max(selected_city_df$value)
  
  # Data Prep for population pyramid
  df <- selected_city_df %>% 
    # Makes use of the mutate function, to make new columns based on existing data
    mutate(g = str_replace(variable, "DP1_00", ""),
           g = str_replace(g, "C", ""),
           g = as.numeric(g),
           sex = case_when(g < 49 ~ "Male",
                            g >= 49 ~ "Female"),
           value = ifelse(sex =="Male", -value, value),
           category = case_when(g == 26 | g == 50 ~ "0 to 04",
                                g == 27 | g == 51 ~ "05 to 09",
                                g == 28 | g == 52 ~ "10 to 14",
                                g == 29 | g == 53 ~ "15 to 19",
                                g == 30 | g == 54 ~ "20 to 24",
                                g == 31 | g == 55 ~ "25 to 29",
                                g == 32 | g == 56 ~ "30 to 34",
                                g == 33 | g == 57 ~ "35 to 39",
                                g == 34 | g == 58 ~ "40 to 44",
                                g == 35 | g == 59 ~ "45 to 49",
                                g == 36 | g == 60 ~ "50 to 54",
                                g == 37 | g == 61 ~ "55 to 59",
                                g == 38 | g == 62 ~ "60 to 64",
                                g == 39 | g == 63 ~ "65 to 69",
                                g == 40 | g == 64 ~ "70 to 74",
                                g == 41 | g == 65 ~ "75 to 79",
                                g == 42 | g == 66 ~ "80 to 84",
                                g == 43 | g == 67 ~ "85+"
                  )) %>% 
    select(category, sex, value)
 
  ## Basic population pyramid
  df %>% ggplot(aes(x = value, y = category, fill = sex)) +
    geom_col() +
    scale_x_continuous(labels = ~ abs(.x),
                       limits = maxValue * c(-1,1)) +
    scale_fill_manual(values = c("darkred", "navy")) +
    labs(title = paste0("Population Pyramid for ", town, ", Iowa"),
         x = "Count",
         y =element_blank(),
         caption = "Kyle Walker, \"Analyzing US Census Data\" 2023")
   
}  # End makePyramid function



# Use the function to make population pyramids for select Iowa cities

makePyramid("Ames")
makePyramid("Boone")
makePyramid("Sioux City")

# The city with the longest name in the state
makePyramid("Maharishi Vedic City")

# Iowa's lowest population place, 4 people, according to 2020 Decennial
makePyramid("Pioneer")               




# What we didn't do 
# - Load in external shapefile
# - Utilize geoprocessing tools in R
# - Mutate data  <-- briefly used in population pyramid function
# - Customize things plots very much
# - Read an Excel file
# - Read from a Google Sheet
# - Use a Google API (Places, Geocoding)




