library(tidyverse)

#reading in clean data
decastar <- read_rds(here::here("raw_data/decathlon.rds"))
decathlon_clean <- read_csv(here::here("clean_data/decathlon_clean.csv"))

# Who had the longest long jump seen in the data?

decathlon_clean %>% 
  filter(event == "long_jump") %>% 
  arrange(desc(score)) %>% 
  select(names, score) %>% 
  head(score, n = 1)

# What was the average 100 m time in each competition?

decathlon_clean %>% 
  group_by(competition) %>% 
  filter(event == "x100m") %>% 
  summarise("mean_score" = mean(score))

# Who had the highest total points across both competitions?

decathlon_clean %>% 
  group_by(names) %>% 
  summarise("total_points" = sum(points)) %>% 
  arrange(desc(total_points)) %>% 
  head(total_points, n = 1)

#What was the shot-put scores for the top three competitors in each competition?

decathlon_clean %>% 
  select(names, points, event, score, competition) %>% 
  filter(competition == "Decastar") %>%
  filter(event == "shot_put") %>%
  arrange(desc(points)) %>% 
  head(n = 3)

decathlon_clean %>% 
  select(names, points, event, score, competition) %>% 
  filter(competition == "OlympicG") %>%
  filter(event == "shot_put") %>%
  arrange(desc(points)) %>% 
  head(n = 3)

# What was the average points for competitors who ran the 400 m in less than 50 seconds vs. those who ran the 400 m in 
# more than 50 seconds?

decathlon_clean %>% 
  filter(event == "x400m") %>% 
  filter(score > 50) %>% 
  summarise("average_points" = mean(points))

decathlon_clean %>% 
  filter(event == "x400m") %>% 
  filter(score < 50) %>% 
  summarise("average_points" = mean(points))
  
  
  
  
