#' Plot number of gRNAs in different transcript regions
#'
#' This function makes a histogram of gRNAs hits per transcript region.
#' Since this is a ggplot2 object, you can modify the plot by
#' adding + and ggplot2 code.
#' 
#' It requires a column in your dataframe that specifies location of gRNA as
#' either 'CDS', 'UTR' or 'CDS+UTR'.
#'
#' @param df Dataframe output from RNA Fold predictions
#' @param minLim Minimum limit of x axis for histogram, default is 0
#' @param maxLim Maximum limit of x axis for histogram, default is 100
#' @return Creates a ggplot
#' @export
# how many gRNAs in each region per gene?
gRNAutrperGene <- function(df, minLim = 0, maxLim = 100) {
  v <- df
  
  v$type <- ifelse(str_detect(v$CDS_UTR, "(?=.*CDS)(?=.*UTR)") == TRUE,
                   "CDS+UTR",
                   ifelse(str_detect(v$CDS_UTR, "CDS") == TRUE,
                          "CDS",
                          "UTR"))
  
  v_count <- v %>%
    dplyr::group_by(`Gene|Longest_transcript`, type) %>%
    count()
  
  v_count %>%
    ggplot2::ggplot(aes(x=n, fill=type)) +
    ggplot2::geom_histogram(color="black", binwidth = 1) +
    ggplot2::scale_fill_manual(values=c("black", "#44AA99", "#AA4499")) +
    ggplot2::coord_cartesian(xlim=c(minLim,maxLim))+
    ggplot2::theme_classic()
}