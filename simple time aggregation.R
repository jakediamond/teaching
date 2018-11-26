# Load data
df <- 

# Load libraries
library(lubridate)
library(dplyr)

# Format data, make sure you have the right datetime format from your csv
df$datetime <- as.POSIXct(df$datetime, 
                          format = "%m/%d/%Y %H:%M",
                          tz = "UTC")

# Sum 5 minute data into "week". This can be changed to whatever length
d3 <- rain %>% 
  mutate(wk = week(datetime)) %>% 
  group_by(wk) %>% 
  summarize(week.sum = sum(rain_m))

