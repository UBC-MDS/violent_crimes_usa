# load libraries
library(tidyverse)
library(ggmap)
register_google(key = "")

# load data
crime <- read_csv("data/ucr_crime_1975_2015.csv")
latlon <- read_csv("data/city_latlon.csv")

# identify invalid city names
bad_names <- crime$department_name %>%
  unique() %>% 
  str_subset(pattern = "County|National")

# identify city with missing data
incomplete <- crime %>%
  filter(!department_name %in% bad_names) %>% 
  select(-c(source, url, months_reported)) %>% 
  filter(!complete.cases(.)) %>% 
  select(department_name) %>% 
  unique() %>% 
  pull()

# identify overlapping cities on the map panel
overlaps <- c("Fort Worth, TX", 
              "Arlington, TX", 
              "Mesa, AZ", 
              "Long Beach, CA", 
              "Oakland, CA",
              "Aurora, CO", 
              "Newark, NJ",
              "Baltimore, MD",
              "Honolulu, HI")

# data wrangling pipeline
crime_clean <- crime %>% 
  filter(!department_name %in% bad_names & !department_name %in% incomplete) %>% 
  separate(department_name, into = c("city", "state"), sep = ",") %>% 
  mutate(city = str_replace(city, "Charlotte-Mecklenburg", "Charlotte")) %>%
  mutate(city = str_replace(city, "New York City", "New York")) %>%  
  left_join(latlon, by = c("city" = "locality")) %>%
  separate(address, into = c("cityname", "statecode", "country"), sep = ",") %>% 
  mutate(state = str_to_upper(statecode)) %>% 
  unite("department_name", c(city, state), sep = ",") %>% 
  select(department_name, year, total_pop, violent_per_100k, homs_per_100k, rape_per_100k, rob_per_100k, agg_ass_per_100k, lon, lat) %>%
  filter(!department_name %in% overlaps) %>% 
  write_csv("data/crime_clean.csv")

# fetch lat/lon for each city
#crime_clean$department_name %>% 
    #unique() %>% 
    #geocode(output = "more", source = "google") %>% 
    #write_csv(path = "../data/city_latlon.csv")