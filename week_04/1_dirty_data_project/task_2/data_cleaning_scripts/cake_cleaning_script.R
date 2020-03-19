library(tidyverse)

# importing the data
cake_ingredients_raw <- read_csv(here::here("raw_data/cake-ingredients-1961.csv"))
ingredient_code_raw <- read_csv(here::here("raw_data/cake_ingredient_code.csv"))

# transforming the cake_ingredients_raw file into a longer format and dropping NA values
cake_ingredients_long <- cake_ingredients_raw %>% 
  pivot_longer(
    cols = AE:ZH, 
    names_to = "code", 
    values_to = "amount"
  ) %>% 
  drop_na()

# joining the two tables together, so the information is all in the same place. 
cake_ingredients_joined <- left_join(cake_ingredients_long, ingredient_code_raw, by = "code")

# removing the code column, putting the ingredients, cake, and column names into lowercase, and saving as a .csv file
cake_ingredients_clean <- cake_ingredients_joined %>%
  janitor::clean_names() %>% 
  select(-code) %>% 
  mutate(ingredient = str_to_lower(ingredient)) %>% 
  mutate(cake = str_to_lower(cake)) %>% 
  write_csv(path = here::here("clean_data/cake_ingredients_clean.csv"))
