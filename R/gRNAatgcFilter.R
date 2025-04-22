#' Filter ATGC% content from gRNA dataframe
#'
#' This function filters ATGC% from the output dataframe by
#' RNA Fold Scores.
#'
#' @param df Dataframe output from RNA Fold predictions
#' @param Arange Percentage range of As for filtering. Default is 15:35.
#' @param Trange Percentage range of Ts for filtering. Default is 15:35.
#' @param Crange Percentage range of Cs for filtering. Default is 15:35.
#' @param Grange Percentage range of Gs for filtering. Default is 15:35.
#' @return Generates a dataframe with filtered gRNAs
#' @export
# Filters gRNAs based on ATGC %, default is between 15:35
gRNAatgcFilter <- function(df, Arange=15:35, Trange=15:35, Crange=15:35, Grange=15:35){
  # any range values should work here, defaults to 15:35 as we were using it
  temp <- df %>%
    dplyr::filter(between(A_Percentage, min(Arange), max(Arange)) &
                  between(T_Percentage, min(Trange), max(Trange)) &
                  between(C_Percentage, min(Crange), max(Crange)) &
                  between(G_Percentage, min(Grange), max(Grange)))
  
  temp$type <- ifelse(str_detect(temp$CDS_UTR, "(?=.*CDS)(?=.*UTR)") == TRUE,
                   "CDS+UTR",
                   ifelse(str_detect(temp$CDS_UTR, "CDS") == TRUE,
                          "CDS",
                          "UTR"))
  
  temp
}


# how many gRNAs per gene? creates an histogram
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