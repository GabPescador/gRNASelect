#' Filter gRNAs based on mismatches to other transcripts
#'
#' This function loads the output dataframes from gRNADesign module mismatch.
#' It will filter gRNAs and keep only the ones that have 4 or more
#' mismatches to any other zebrafish transcript.
#'
#' @param path Path to a folder containing all files from gRNADesign module mismatch
#' @param data Dataframe of gRNAs selected to go to gRNADesign module mismatch
#' @param extension Extension of files in path. Default is csv
#' @return Generates a dataframe with filtered gRNAs
#' @export
# Mismatch function
gRNAmismatchFilter <- function(path, data, extension = "csv"){
  # path = path to where all files are
  # extension = extension of files, default is csv
  # data = your original data frame
  pattern <- paste0("*.", extension)
  
  print("Loading Tables...")
  
  df <- list.files(path = path,
                   pattern = pattern,
                   full.names = TRUE) %>%
    tidytable::map_df(~{
      data <- data.table::fread(.x)
      data$FileName <- basename(.x)  # Add the file name as a new column
      return(data)
    })
  
  # transforming to same name as input table
  df$gRNA_name <- paste0(stringr::str_split_fixed(df$FileName, "_", n=Inf)[,4],
                         "_",
                         stringr::str_split_fixed(df$FileName, "_", n=Inf)[,5],
                         "_",
                         stringr::str_split_fixed(df$FileName, "_", n=Inf)[,6],
                         "_",
                         stringr::str_split_fixed(df$FileName, "_", n=Inf)[,7]) %>%
    stringr::str_sub(end=-5) # takes out the .csv from the filenames
  
  # Takes out the unique gene ID
  df$Gene_ID <- stringr::str_split_fixed(df$`Gene/transcript`, "\\|", n=Inf)[,2]
  
  print("Checking for mismatches...")
  
  # Now we can check if each gRNA has only > 5 mismatches
  df_counts <- df %>%
    dplyr::group_by(gRNA_name, mismatches) %>%
    dplyr::summarise(count = length(mismatches))
  
  df_counts$Transcript_ID <- stringr::str_split_fixed(df_counts$gRNA_name, "_", n=Inf)[,1]
  df_counts$Gene_ID <- stringr::str_split_fixed(df_counts$gRNA_name, "_", n=Inf)[,2]
  
  # filter gRNAs that have 1, 2 or 3 mismatches
  df_counts1 <- df_counts %>%
    dplyr::filter(mismatches %in% c(1,2,3))
  
  # keeping only gRNAs that have 0, 4 or 5 mismatches
  df_counts2 <- df_counts %>%
    dplyr::filter(!gRNA_name %in% df_counts1$gRNA_name)
  
  # Checking which gRNAs have more than 1 geneID with 0 mismatches
  df_counts3 <- dplyr::filter(df_counts2, mismatches == 0 & count > 1)
  
  # Filter this from the first table to check if it is different transcripts from same gene
  df_counts4 <- dplyr::filter(df, gRNA_name %in% df_counts3$gRNA_name & mismatches == 0)
  
  # Get the gRNA names that are from 0 mismatches with different gene ids
  df_counts5 <- df_counts4 %>%
    dplyr::filter(!str_detect(df_counts4$gRNA_name, df_counts4$Gene_ID))
  
  df_counts6 <- df_counts2 %>%
    dplyr::filter(!gRNA_name %in% df_counts5$gRNA_name)
  
  df_final <- dplyr::filter(data, gRNA_name %in% df_counts6$gRNA_name)
  
  print("Done!")
  
  return(df_final)
}