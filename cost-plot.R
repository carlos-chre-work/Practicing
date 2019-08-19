library(tidyverse)

## run simulation script
source("DOIsim.R")

## load helper functions
list.files("./doi-bandit-planner/functions", full.names = TRUE) %>% 
    purrr::walk(source)

tidy_sim_data <- tidy_cumulative_cost(dataForAnalysis)
gg <- plot_cumulative_cost(tidy_sim_data) %>% 
    print()