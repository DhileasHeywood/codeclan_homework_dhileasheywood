library(tidyverse)

# importing the data
cake_ingredients_raw <- read_csv(here::here("raw_data/cake-ingredients-1961.csv"))
ingredient_code_raw <- read_csv(here::here("raw_data/cake_ingredient_code.csv"))

# transforming the cake_ingredients_raw file into a longer format and dropping NA values
cake_ingredients_long <- cake_ingredients_raw %>% 
  pivot_longer(
    cols = AE:ZH, 
    names_to = "ingredient", 
    values_to = "amount"
  ) %>% 
  drop_na()
