#' Plot number of gRNAs per gene
#'
#' This function makes a histogram of gRNAs per gene.
#' Since this is a ggplot2 object, you can modify the plot by
#' adding + and ggplot2 code.
#'
#' @param df Dataframe output from RNA Fold predictions
#' @param binwidth Bin sizes for geom_histogram
#' @return Creates a ggplot
#' @export
gRNAperGene <- function(df, binwidth=5){
  z <- df %>%
    group_by(`Gene|Longest_transcript`) %>%
    count()
  
  z %>%
    ggplot(aes(x=n)) +
    geom_histogram(binwidth = binwidth, color="white", fill="black", linewidth=0.2) +
    scale_y_continuous(n.breaks = 10) +
    scale_x_continuous(n.breaks = 10) +
    theme_classic() +
    xlab("# gRNAs per gene")
}
