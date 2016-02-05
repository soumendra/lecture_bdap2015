library(dplyr)
library(ggplot2)

flights <- tbl_df(read.csv("flights.csv", stringsAsFactors = FALSE))
flights$date <- as.Date(flights$date)
weather <- tbl_df(read.csv("weather.csv", stringsAsFactors = FALSE))
weather$date <- as.Date(weather$date)
planes <- tbl_df(read.csv("planes.csv", stringsAsFactors = FALSE))
airports <- tbl_df(read.csv("airports.csv", stringsAsFactors = FALSE))

# filter: keep rows matching the given criteria
# select: pick columns by name
# arrange: reorder rows
# mutate: add new variables
# summarise: reduce variable to values

# Structure
#   - First argument is a data frame
#   - Subsequent arguments say what to do with a data frame
#   - Always returns a dataframe
#   - Never modifies in-place

head(airports)
head(flights)

filter(airports, state=="MS")
airports %>% filter(state=="MS")

select(airports, state)
airports %>% select(city)

# Task
# Find all flights
# To SFO or OAK
# In January
# Delayed by more than an hour
# That departed between midnight and five
# Where the arrival delay was more than twice the departure delay
flights %>% 
  filter(dest %in% c("SFO", "OAK")) %>%
  filter(date < "2011-02-01") %>%
  filter(dep_delay > 60) %>%
  filter(hour >= 0, hour <= 5) %>%
  filter(arr_delay > 2*dep_delay)

# Select the two delay variables
select(flights, arr_delay, dep_delay)
select(flights, arr_delay:dep_delay)
select(flights, ends_with("delay"))
select(flights, contains("delay"))

# Order flights by departure date and time
arrange(flights, date, hour, minute)
# Which flights were most delayed?
arrange(flights, desc(dep_delay))
arrange(flights, desc(arr_delay))
# Which flights caught up the most during the flight?
arrange(flights, desc(dep_delay - arr_delay))

# Compute speed in mph from time (in minutes) and distance (in miles). Which flight flew the fastest?
mutate(flights, speed=(dist*60)/time)

# Add a new variable that shows how much time was made up or lost in flight.
mutate(flights, timegain=dep_delay-arr_delay)

# How did I compute hour and minute from dep?
mutate(flights, hour2 = dep%/%100, minute2 = dep%%100)

flights <- group_by(flights, dep_delay)
