#' Plot number of gRNAs per gene
#'
#' This function makes a histogram of gRNAs hits per gene.
#' Since this is a ggplot2 object, you can modify the plot by
#' adding + and ggplot2 code.
#'
#' @param df Dataframe output from RNA Fold predictions
#' @param binwidth Specifies binwidth from geom_histogram
#' @return Creates a ggplot
#' @export
gRNAperGene <- function(df, binwidth=5){
  z <- df %>%
    dplyr::group_by(`Gene|Longest_transcript`) %>%
    count()
  
  z %>%
    ggplot2::ggplot(aes(x=n)) +
    ggplot2::geom_histogram(binwidth = binwidth, color="white", fill="black", linewidth=0.2) +
    ggplot2::scale_y_continuous(n.breaks = 10) +
    ggplot2::scale_x_continuous(n.breaks = 10) +
    ggplot2::theme_classic() +
    ggplot2::xlab("# gRNAs per gene")
}