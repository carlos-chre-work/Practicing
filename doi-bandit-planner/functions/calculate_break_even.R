#' Calculate Break Even
#'
#' @param tidy_cost_df output of tidy_cumulative_cost
#'
#' @return session index where reward crosses negative to positive if available,
#' will return Inf, if not available.
calculate_break_even <- function(tidy_cost_df) {
    tidy_cost_df %>% 
        filter(gain >= 0) %>% 
        magrittr::use_series(sessionIndex) %>% 
        min()
}