library(tidyverse)
# Loading in the cleaned data

clean_birds <- read_csv(here::here("clean_data/seabirds_clean.csv"), guess_max = 49019)

# Which bird had the most individual sightings? Including the common name, scientific name, as well as species abbreviation
clean_birds %>% 
  group_by(species_abbreviation) %>% 
  mutate(species_count = n()) %>% 
  select(common_name, scientific_name, species_abbreviation, species_count) %>% 
  arrange(desc(species_count)) %>% 
  head(n = 1)

# Which bird had the highest total count?
clean_birds %>% 
  group_by(species_abbreviation) %>% 
  mutate(total_count = sum(count)) %>% 
  select(common_name, scientific_name, species_abbreviation, total_count) %>% 
  arrange(desc(total_count)) %>% 
  head(n = 1)

# Which bird had the highest total count above a latitude of -30?
clean_birds %>% 
  filter(lat > -30) %>% 
  group_by(species_abbreviation) %>% 
  mutate(total_count = sum(count)) %>% 
  select(common_name, scientific_name, species_abbreviation, total_count) %>% 
  arrange(desc(total_count)) %>% 
  head(n = 1)

# How many different types of birds were only ever seen in groups of 1?
clean_birds %>% 
  group_by(species_abbreviation) %>% 
  filter(count == 1) %>% 
  summarise(sightings_of_1 = n()) %>%
  summarise(number_of_species = length(species_abbreviation))

# How many penguins were seen?
penguins <- clean_birds %>% 
  filter(str_detect(common_name, pattern = "penguin")) %>% 
  filter(!is.na(count)) %>% 
  summarise(number_of_penguins_seen = sum(count))
  
  
  
  





  