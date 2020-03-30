library(tidyverse)
library(plotly)

board_game_data <- read_csv(here::here("clean_data/board_game_clean_data"))
board_game_data


overview_category <- function(min_count, max_count){
  
  board_game_data %>% 
    group_by(category) %>% 
    summarise(category_count = n()) %>% 
    filter(category_count >= min_count, category_count <= max_count) %>% 
    plot_ly(x = ~category, y = ~category_count, type = "bar")

}

overview_year <- function(min_year, max_year){
  
  board_game_data %>%
    filter(year >= min_year, year <= max_year) %>% 
    group_by(year) %>% 
    summarise(year_count = n()) %>% 
    ggplot() +
    aes(x = year, y = year_count) +
    geom_col()
  
}

overview_year(1900, 2017)


ggplot(board_game_data) +
  geom_point(aes(x = max_time, y = rank, colour = geek_rating)) +
  scale_y_reverse() 



