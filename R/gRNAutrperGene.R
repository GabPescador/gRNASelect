#' Plot number of gRNAs in different transcript regions
#'
#' This function makes a histogram of gRNAs hits per transcript region.
#' Since this is a ggplot2 object, you can modify the plot by
#' adding + and ggplot2 code.
#'
#' @param df Dataframe output from RNA Fold predictions
#' @return Creates a ggplot
#' @export
# how many gRNAs in each region per gene?
gRNAutrperGene <- function(df) {
  v <- df
  
  v$type <- ifelse(str_detect(v$CDS_UTR, "(?=.*CDS)(?=.*UTR)") == TRUE,
                   "CDS+UTR",
                   ifelse(str_detect(v$CDS_UTR, "CDS") == TRUE,
                          "CDS",
                          "UTR"))
  
  v_count <- v %>%
    group_by(`Gene|Longest_transcript`, type) %>%
    count()
  
  v_count %>%
    ggplot(aes(x=n, fill=type)) +
    geom_histogram(color="black", binwidth = 1) +
    scale_fill_manual(values=c("black", "#44AA99", "#AA4499")) +
    coord_cartesian(xlim=c(0,100))+
    theme_classic()
}