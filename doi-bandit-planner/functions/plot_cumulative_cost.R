#' Plot cumulative cost
#'
#' @param tidy_cost_df output of tidy_cumulative_cost
#' @param pal colors for lines, default rvred and rvgray
#'
#' @return ggplot object
#' 
plot_cumulative_cost <- function(tidy_cost_df, pal=c("#E34949", "#545454")) {
    break_even <- calculate_break_even(tidy_cost_df)
    
    ggplot(tidy_cost_df, aes(sessionIndex, gain, color = testType)) +
        geom_line() +
        scale_color_manual(values = pal) +
        labs(
            x = "Sessions",
            y = "Cumulative Reward Difference",
            caption = "Cumulative Reward Difference is calculated as the cumulative rewards lost or gained relative to the control"
        ) +
        theme_minimal()
}