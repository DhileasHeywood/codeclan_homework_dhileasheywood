library(tidyverse)
library(janitor)
library(leaps)
library(fastDummies)

# GOAL: Model the average price of the avocados. 
# SCENARIO: work for a company that sells avocados, and wants to maximise profit. They want me to make a model that shows the 
# most important predictors of avocado price in the USA. 

avocado <- read_csv("data/avocado.csv")

# Background information on the dataset, taken from the Kaggle page https://www.kaggle.com/neuromusic/avocado-prices):
#The table below represents weekly 2018 retail scan data for National retail volume (units) and price. Retail scan data 
#comes directly from retailers’ cash registers based on actual retail sales of Hass avocados. Starting in 2013, the table 
#below reflects an expanded, multi-outlet retail data set. Multi-outlet reporting includes an aggregation of the following 
#channels: grocery, mass, club, drug, dollar and military. The Average Price (of avocados) in the table reflects a per unit 
#(per avocado) cost, even when multiple units (avocados) are sold in bags. The Product Lookup codes (PLU’s) in the table are 
#only for Hass avocados. Other varieties of avocados (e.g. greenskins) are not included in this table.

glimpse(avocado)

# Variable names are not in snake case. Converting them using clean_names()
avocado <- clean_names(avocado)

unique(avocado$type)
unique(avocado$region)
# Selecting variables that will be useful in model building. x1 is just row number and would lead to overfitting. As would the 
# date and year variables. 

# Changing names of numerically-named variables, after confirming what product it refers to on the Hass Avocado Board website
# 4046 are 'Small' avocados, 4225 are 'Large', and 4770 are 'All Sizes'

# Changing type column to logical 'organic' column, as there are only two values of this variable. Organic and conventional.

# Since the region column is categorical, I'm splitting it into dummy variables, so that it can potentially be included. 
# I'm also removing the totalUS values, because those will include all of the other values.
avocado_tidy <- avocado %>% 
  select(-x1, -date, -year, small = x4046, large = x4225, all_sizes = x4770, organic = type) %>% 
  mutate(organic = ifelse(organic == "organic", TRUE, FALSE)) %>% 
  filter(region != "TotalUS", region != "SouthCentral", region != "West", region != "Southeast", region != "Midsouth", region != "Northeast") %>% 
  dummy_cols(select_columns = "region", remove_first_dummy = TRUE, remove_selected_columns = TRUE) %>% 
  clean_names()
  

# I'm going to remove 20% of my data and save it to test the model. I'll use the remaining 80% to train it. 

# creating a variable equal to the number of rows of avocado_tidy
n_avocado <- nrow(avocado_tidy)

# randomly creating an index of the variables in avocado_tidy to remove as a test dataset. 
test_index <- sample(1:n_avocado, size = n_avocado * 0.2)

# creating the test and training sets. 
test_avocado <- slice(avocado_tidy, test_index)
train_avocado <- slice(avocado_tidy, -test_index)

# I'm going to generate models using three different methods, and compare the outputs, before deciding which to use. 

avocado_forward <- regsubsets(average_price ~ ., data = train_avocado, nvmax = 61, method = "forward")

sum_avocado_forward <- summary(avocado_forward)

plot(avocado_forward, scale = "adjr2")

avocado_backward <- regsubsets(average_price ~ ., data = train_avocado, nvmax = 61, method = "backward")

plot(avocado_backward, scale = "adjr2")

# I changed this to false because it was TOO BIG. IT TAKES AGES. 
avocado_exhaustive <- regsubsets(average_price ~ ., data = train_avocado, nvmax = 61, method = "exhaustive", really.big = FALSE)






