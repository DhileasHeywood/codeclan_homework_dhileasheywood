library(tidyverse)
library(readxl)


excel_sheets(here::here("raw_data/candy_ranking_data/boing-boing-candy-2015.xlsx"))
excel_sheets(here::here("raw_data/candy_ranking_data/boing-boing-candy-2016.xlsx"))
excel_sheets(here::here("raw_data/candy_ranking_data/boing-boing-candy-2017.xlsx"))

candy_2015_raw <- read_excel(here::here("raw_data/candy_ranking_data/boing-boing-candy-2015.xlsx"))
candy_2016_raw <- read_excel(here::here("raw_data/candy_ranking_data/boing-boing-candy-2016.xlsx"))
candy_2017_raw <- read_excel(here::here("raw_data/candy_ranking_data/boing-boing-candy-2017.xlsx"))


