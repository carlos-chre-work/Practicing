#' Tidy Cumulative Cost
#'
#' @param cost_df output of simulation
#'
#' @return tidy tibble with cumulative costs calculated
tidy_cumulative_cost <- function(cost_df) {
    cost_df %>% 
        as_tibble() %>% 
        arrange(sessionIndex) %>% 
        mutate(
            bandit = cumsum(costHistory),
            ABn = cumsum(abCostHistory)
        ) %>% 
        gather("testType", "gain", bandit, ABn)
}