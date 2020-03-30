library(tidyverse)

raw_board_game <- read_csv("raw_data/bgg_db_1806.csv")

board_game_clean <- raw_board_game %>% 
  select(-bgg_url, -game_id, -image_url, -avg_time, game_name = names) %>%
  mutate(game_name = str_to_lower(game_name), mechanic = str_to_lower(mechanic), category = str_to_lower(category), designer = str_to_lower(designer)) %>%
  separate(col = category, into = c("category_1", "category_2", "category_3", "category_4"), sep = "\\,") %>% 
  pivot_longer(cols = category_1:category_4, names_to = "category_number", values_to = "category", values_drop_na = TRUE) %>% 
  select(-category_number)


write_csv(board_game_clean, path = here::here("clean_data/board_game_clean_data"))

