#' Plot RNA Fold scores
#'
#' This function makes a boxplot of RNA Fold scores of all gRNAs.
#' Since this is a ggplot2 object, you can modify the plot by
#' adding + and ggplot2 code.
#'
#' @param df Dataframe output from RNA Fold predictions
#' @return Creates a ggplot
#' @export
# plots RNAFold Scores
# Since this is a ggplot, you can easily include annotations or changes with + after the function
gRNAScorePlot <- function(df) {
  df_melt <- reshape2::melt(df, measure.vars = c("Average_score", "G_Percentage", "C_Percentage", "A_Percentage", "T_Percentage"))
  
  df_melt %>%
    dplyr::filter(variable == "Average_score") %>%
    ggplot(aes(x=variable, y=value)) +
    geom_sina() +
    geom_boxplot() +
    annotate(geom="text",
             y=max(dplyr::filter(df_melt, variable == "Average_score")[,"value"]),
             x=0.5,
             hjust=0,
             label=paste0("mean = ", round(mean(dplyr::filter(df_melt, variable == "Average_score")[,"value"]),4))) +
    annotate(geom="text",
             y=max(dplyr::filter(df_melt, variable == "Average_score")[,"value"]),
             x=1.5,
             hjust=1,
             label=paste0("n = ",nrow(df))) +
    theme_classic() +
    xlab("") +
    ylab("RNA Fold Score") +
    ggtitle("Score")
}