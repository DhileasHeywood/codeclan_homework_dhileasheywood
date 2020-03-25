library(ggplot2)
library(dplyr)
library(CodeClanData)


overall_medal_plot <- function(my_medal, my_season){
  
  olympics_overall_medals %>%
    filter(team %in% c("United States",
                       "Soviet Union",
                       "Germany",
                       "Italy",
                       "Great Britain")) %>%
    filter(medal == my_medal) %>%
    filter(season == my_season) %>%
    ggplot() +
    aes(x = team, y = count) +
    geom_col(fill = case_when(
      my_medal == "Gold" ~ "#FFD700",
      my_medal == "Silver" ~ "#C0C0C0",
      my_medal == "Bronze" ~ "#CD7F32"
    )) 
  
}