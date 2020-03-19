library(tidyverse)
library(janitor)

#importing the raw decathlon data.
decathlon_raw <- read_rds(here::here("raw_data/decathlon.rds"))

# I don't want to lose the names data, so I'm adding it as a column.
names <- rownames(decathlon_raw)
rownames(decathlon_raw) <- NULL
decathlon_names <- cbind(names, decathlon_raw)

# The names don't fit in the snake_case format, so I'm changing those, and also transforming the tibble into the long format.
decathlon_clean <- decathlon_names %>% 
  clean_names() %>% 
  mutate(names = str_to_lower(names)) %>% 
  pivot_longer(
    x100m:x1500m, 
    names_to = "event", 
    values_to = "score"
      ) 

# saving the cleaned data as a .csv file in the clean_data folder of the project.
write_csv(decathlon_clean, path = here::here("clean_data/decathlon_clean.csv"))



