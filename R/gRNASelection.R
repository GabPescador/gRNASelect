#' Selects gRNAs based on their RNA Fold scores
#'
#' This function uses RNA Fold scores to select top, bottom and random
#' gRNAs. type2 column specifies criteria of choice to be either 'TOP' and 'BOT' scores,
#' 'RANDOM' if randomly selected and 'Less than 10' if less than 10 gRNAs exist for that gene
#'
#' @param df Dataframe containing RNA Fold scores
#' @param minN Cut-off for minimum number of gRNAs every transcript should have. Default is 10
#' @param randomN Number of gRNAs to be selected apart from Top and Bottom RNA Fold scores. Default is 8
#' @return Generates a dataframe with selected gRNAs
#' @export
# Selects gRNAs per gene based on: 1) how many minimum we want; 2) top and bottom scores; and, 3) number of random scores
gRNASelection <- function(df, minN = 10, randomN = 8){
  # minN sets the cutoff for all gRNAs less than that number
  # randomN sets how many random gRNAs we are picking after taking the Top and Bottom scores per gene
  
  z <- df %>%
    dplyr::group_by(`Gene|Longest_transcript`) %>%
    count()
  
  # First gets all gRNAs with less than a certain number available
  lessThan10 <- dplyr::filter(z, n <= minN)
  lessThan10_seq <- dplyr::filter(df, `Gene|Longest_transcript` %in% lessThan10$`Gene|Longest_transcript`)
  lessThan10_seq$type2 <- "Less than 10"
  
  df <- dplyr::filter(df, !`Gene|Longest_transcript` %in% lessThan10$`Gene|Longest_transcript`)
  
  # Max scores of each gene
  topScores <- df %>%
    dplyr::group_by(`Gene|Longest_transcript`, type) %>% # for each unique sample
    dplyr::arrange(-Average_score) %>%
    dplyr::slice_head()
  topScores$type2 <- "TOP"
  
  # Bottom scores of each gene
  botScores <- df %>%
    dplyr::group_by(`Gene|Longest_transcript`, type) %>% # for each unique sample
    dplyr::arrange(-Average_score) %>%
    dplyr::slice_tail()
  botScores$type2 <- "BOT"
  
  # Filter out the ones we already picked
  dfFilter <- dplyr::filter(df, !seq_23nt %in% topScores$seq_23nt)
  dfFilter <- dplyr::filter(df, !seq_23nt %in% botScores$seq_23nt)
  
  # Now we can select 8 more at random from our sequences
  randomScores <- dfFilter %>%
    dplyr::group_by(`Gene|Longest_transcript`, type) %>% # for each unique sample
    dplyr::slice_sample(n = randomN)
  randomScores$type2 <- "RANDOM"
  
  # Now we can put all together
  finaldf <- rbind(lessThan10_seq, topScores, botScores, randomScores)
  
}