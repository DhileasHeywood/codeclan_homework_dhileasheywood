library(tidyverse)
# Loading in cleaned data

clean_cakes <- read_csv(here::here("clean_data/cake_ingredients_clean.csv"))

# Which cake has the most cocoa in it?
clean_cakes %>% 
  filter(ingredient == "cocoa") %>% 
  arrange(desc(ingredient)) %>% 
  head(n = 1)

# For sponge cake, how many cups of ingredients are used in total?
clean_cakes %>% 
  filter(cake %in% "sponge") %>% 
  filter(measure == "cup") %>% 
  summarise(total_number_cups = sum(amount))

# How many ingredients are measured in teaspoons?
clean_cakes %>% 
  filter(measure %in% "teaspoon") %>% 
  summarise(ingredients_measured_in_tsp = length(unique(ingredient)))

# Which cake has the most unique ingredients?
clean_cakes %>% 
  group_by(cake) %>% 
  summarise(count_ingredients = length(unique(ingredient))) %>% 
  arrange(desc(count_ingredients)) %>% 
  head(n = 1)

# Which ingredients are used only once?
clean_cakes %>% 
  group_by(ingredient) %>% 
  summarise(count_ingredients = n()) %>% 
  filter(count_ingredients == 1)
