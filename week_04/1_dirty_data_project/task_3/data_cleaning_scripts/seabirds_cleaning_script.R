library(tidyverse)
library(readxl)
library(janitor)

# Reading in the raw data. We only need two of the sheets, so that's all I'm reading in.
seabirds_ship_data_raw <- read_excel(here::here("raw_data/seabirds.xls"), sheet = "Ship data by record ID", guess_max = 12310)
seabirds_bird_data_raw <- read_excel(here::here("raw_data/seabirds.xls"), sheet = "Bird data by record ID", guess_max = 49019)

# Dropping unexplained/unintelligably columns. 
# They're not needed for the analysis that's being performed here.
# Cleaning the column names so they're more self explanatory
# Moving all names to lower for easier analysis

seabirds_bird_data_dropped <- seabirds_bird_data_raw %>% 
  select(`RECORD ID`:AGE, SEX, COUNT) %>% 
  clean_names() %>% 
  rename(
    common_name = species_common_name_taxon_age_sex_plumage_phase,
    scientific_name = species_scientific_name_taxon_age_sex_plumage_phase
  ) %>% 
  mutate(
    common_name = str_to_lower(common_name),
    scientific_name = str_to_lower(scientific_name)
  )

# Dropping columns and cleaning names for the ship data.
seabirds_ship_data_dropped <- seabirds_ship_data_raw %>% 
  select(`RECORD ID`:LONG) %>% 
  clean_names()

# Joining the two tables so that the data needed for analysis is all in the same place. 
seabirds_clean <- left_join(seabirds_bird_data_dropped, seabirds_ship_data_dropped, by = "record_id")


write_csv(seabirds_clean, path = here::here("clean_data/seabirds_clean.csv"))


  
  
  
  
  
  
  