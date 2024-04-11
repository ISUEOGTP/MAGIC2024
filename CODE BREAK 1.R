## Base R Intro Script
## Jay Maxwell & Chris Seeger
## Iowa State University Extension & Outreach
##
## MAGIC - Conference 2024


# A line of code begining with # is a comment and will not run

# Getting Started ----
# Placing 4 dashes at the end of a comment will turn it into a "section"
# that will show up on the outline view. You can collapse a section by
# clicking on the small arrow next to the line 10. 

# Ctrl + Shift + O   (capital letter O) will show/hide the document outline
# You can quickly navigate to different sections of your code using the 
# outline. 


# To run a line of code, place cursor on the line, press control-enter (Windows)
#                                                        command-enter (Mac)
# Place the cursor after the second 1, and press the key-command to run


1 + 1



# To run MULTIPLE lines of code, highlight a block of code, press control-enter (Windows)
#                                                                 command-enter (Mac)

1 + 1
2 * 2


# The output shows up in the CONSOLE window below. The Console can also be used
# to run code. After the command prompt, >, enter 3*3 in the console and press
# enter to execute the command.


# Operators ----

# Computers do TWO things very fast: perform calculation & make comparisons

## Arithmetic Operators ----

1 + 1           # Addition
6 - 3           # Subtraction
4 * 2           # Multiplication
16 / 5          # Division
2^3             # Exponent


## Comparison Operators ----
# The result of a comparison TRUE or FALSE.   This is called a "Logical" type 
# in R. Other languages will call it a Boolean.

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


# The "usual way" of assignment in most languages uses  =  to assign values
# This works in R!
myVariable2 = 10
myVariable2


# This does not work! = only assigns from right to left
10 = myVariable


# When a variable is created it will appear in the Environment tab in the 
# upper right pane. 




# Functions ----

# Functions are reusable bit of code that (usually) take some type of input,
# perform a calculation or comparison, then return some type of output. 
# R has many built-in functions for math, statistics, string operations 
# and more. 

# You can also write your own functions and reuse them. This is better than 
# copy-pasting blocks of code numerous times. 

# A few examples.... too many to cover them all!

## Math Functions ----



sqrt(144)           # Calculate the square root of 144
round(3.14159, 3)   # Round the 3.14159 to 3 decimals
floor(3.14159)      # Find the first integer less than 3.14159
ceiling(3.14159)    # Find the first integer greater than the 3.14159


## Statistics Functions ----

# Most statistical functions need a vector of data
# (Vector data structures are discussed later)
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




# Primitive Data Types ----

# The basic building block of a more complex data structure

3.14159         # Numeric, a continuous number. AKA: real, double
42L             # Integer, a whole number. "L" for "Long Integer"
TRUE            # Logical, ie, TRUE or FALSE, T or F, 1 or 0. AKA: boolean.
"some words"    # character, a sequence of letters, numbers, and symbols. 
# AKA: string



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
# We get the first, third, and fifth elements of charVector and myVector
# This is important later!


# Data Frames ----

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

# If this seems confusing, that's because because it is!
# To help make selecting and filtering rows of data easier and more intuitive 
# we will use the dplyr from the tidyverse during the next coding break. 




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



# Extending R: Installing Packages ----

# Third-party packages provide extra functionality by providing 
# both functions and data. Before writing your own complex function, do some 
# searching to see if somebody has already written a package to solve your
# problems

# install.packages will install from a repository of software approved and 
# hosted by CRAN - Comprehensive R Archive Network
# Note, the two lines below will fail beacuse there is no package called 
# "package_name" hosted on CRAN
install.packages("package_name")     # To install a package
library(package_name)                # To load the package into your environment


# These lines will install some packages used later during the workshop
# These packages have already been installed on the Workshop cloud instance

# install.packages("sf")             # Simple Features, a spatial data package
# install.packages("tidyverse")      # A very popular data-science tool package
# Must have version 1.4 (released May 27, 2023) 
# or higher for this demo code.

# After a package has been installed, you need to library() it to add it to the 
# active environment
library(sf)
library(tidyverse)   # This will load 10 packages, you can load tidyverse
# packages singly if you want to conserve resources






