#' Plot ATGC%
#'
#' This function makes a boxplot of ATGC% content of all gRNAs.
#' Since this is a ggplot2 object, you can modify the plot by
#' adding + and ggplot2 code.
#'
#' @param df Dataframe output from RNA Fold predictions
#' @return Creates a ggplot
#' @export
# Plots atgc%
# Since this is a ggplot, you can easily include annotations or changes with + after the function
gRNAatgcPlot <- function(df){
  df_melt <- reshape2::melt(df, measure.vars = c("Average_score", "G_Percentage", "C_Percentage", "A_Percentage", "T_Percentage"))
  
  df_melt %>%
    filter(!variable == "Average_score") %>%
    ggplot(aes(x=variable, y=value)) +
    geom_boxplot() +
    annotate(geom="text",
             y=max(dplyr::filter(df_melt, !variable == "Average_score")[,"value"]),
             x=c(1,2,3,4),
             hjust=0.5,
             label=c(paste0("mean = ", round(mean(dplyr::filter(df_melt, variable == "G_Percentage")[,"value"]),2)),
                     paste0("mean = ", round(mean(dplyr::filter(df_melt, variable == "C_Percentage")[,"value"]),2)),
                     paste0("mean = ", round(mean(dplyr::filter(df_melt, variable == "A_Percentage")[,"value"]),2)),
                     paste0("mean = ", round(mean(dplyr::filter(df_melt, variable == "T_Percentage")[,"value"]),2)))) +
    annotate(geom="text",
             y=min(dplyr::filter(df_melt, !variable == "Average_score")[,"value"]),
             x=0.5,
             hjust=0,
             label=paste0("n = ",nrow(df))) +
    theme_classic() +
    xlab("") +
    ylab("Percentage (%)") +
    ggtitle("ATGC")
}