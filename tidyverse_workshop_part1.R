# 
# Purpose: Introduction to data wrangling in R
# Coder: Jake Diamond
# Date: October 23, 2018
# 

# Clear work space, a good idea to do at the beginning of code
rm(list = ls())

# Install packages (only need to do this once per computer)
install.packages("tidyverse")

# Load packages, useful if you need functions outside of "base R"
library(tidyverse)

# Working directory - a good idea, but not necessary for today
setwd("")

# Must-know base functions
?str
?class
?head
?tail

# A few more
c(2, 4, 6)
2:6
seq(2, 3, by = 0.5)
rep(1:2, times = 3)
rep(1:2, each = 3)

# Get a test dataframe
df <- iris

# Try some functions
str(df)
class(df)
head(df)
tail(df)
df

# Let's use our first "dplyr" verb: filter (filters data conditionally)
?filter
# Let's get only data where the Species is "setosa"
filter(df, Species == "setosa")
# Now the same thing, but also Sepal.Width greater than 3.5
filter(df, Species == "setosa" & Sepal.Width > 3.5)
filter(df, Species == "setosa", Sepal.Width > 3.5)
# Now how about all data for species not "setosa"
filter(df, Species != "setosa")
# Now how about all data for species not "setosa" nor "versicolor", 
# and Sepal.Length less than 6
filter(df, 
       !(Species == "setosa" | Species == "versicolor"),
       Sepal.Length < 6)
filter(df,
       !(Species %in% c("setosa", "versicolor")),
       Sepal.Length < 6)

# Next verb: select (selects individual columns)
?select
# Select columns by name
select(df, Species, Sepal.Width)
# Anti-select columns by name
select(df, -Species)
# More specific conditions
select(df, contains("."))
select(df, starts_with("Sepal"))

# Next verb: mutate (adds new columns to dataframe)
mutate(df, species_cap = toupper(Species))
mutate(df, sep.wid.norm = Sepal.Width / mean(Sepal.Width))
# Multiple new columns
mutate(df, 
       sep.wid.norm = Sepal.Width / mean(Sepal.Width),
       pet.wid.norm = Petal.Width / mean(Petal.Width))
# Refer to new column within the verb call
mutate(df,
       sep.ratio = Sepal.Width / Sepal.Length,
       ln.sep.ratio = log(sep.ratio))

# Next verb: summarize (summarizes data to one row)
summarize(df,
          sep.w.mean = mean(Sepal.Width),
          sep.w.sd = sd(Sepal.Width),
          sep.w.n = n(),
          sep.w.iqr = IQR(Sepal.Width))

# Next verb: group_by (groups data for verbs)
group_by(df, Species)

# Key component: piping (allows for easy coding!)
# This is the big one
# Let's try it out: we want to get the sepal width data for only "setosa"
df %>%
  filter(Species == "setosa") %>%
  select(Sepal.Width)
# OK now let's find the mean sepal width for every species
df %>%
  group_by(Species) %>%
  summarize(sep.w.mean = mean(Sepal.Width, na.rm = TRUE))
# How about the mean and sd for every variable?
df %>%
  group_by(Species) %>%
  summarize_all(funs(mean, sd))
# How about: normalize the petal length for all but setosa by its mean, 
# then find the variance of that new normalized variable
df %>%
  filter(Species != "setosa") %>%
  group_by(Species) %>%
  select(Petal.Length) %>%
  transmute(pet.len.norm = Petal.Length / mean(Petal.Length)) %>%
  summarize(var.pet.len.norm = var(pet.len.norm))

# Quick example for graphing in ggplot2
df %>%
  ggplot(aes(x = Petal.Length,
             y = Petal.Width,
             color = Species)) + 
  geom_point() +
  stat_smooth(method = "lm")

# Get data into "long" format...currently in "wide"
?gather
df_l <- df %>%
  gather(key = type,
         value = measurement,
         Sepal.Length:Petal.Width)

#We will come back to this, but now we can easily plot all the data
df_l %>%
  ggplot(aes(x = measurement,
             fill = Species)) +
  geom_histogram() + 
  facet_wrap(~type)


