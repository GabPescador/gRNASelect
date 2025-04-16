#' Create gRNA dataframes for 96-well plate ordering
#'
#' This function loads the output dataframe of gRNAmismatchFilter.
#' It will split your dataframe into several dataframes for ordering
#' 96-well plates from IDT. e.g., if you specify wells = 93 and you have
#' 215 rows, it will generate 3 dataframes and save them as .csv in the
#' outputpath directory.
#'
#' @param df Dataframe output from gRNAmismatchFilter
#' @param outputpath Path where you want to save the split dataframes
#' @param wells Maximum number of rows each dataframe will have. Default is 93.
#' @param nmax Number of gRNAs per gene you want to select. Default is 3.
#' @return Saves dataframes with maximum number of rows specified by wells as .csv
#' files and excel files for IDT ordering in the outputpath directory
#' @export
gRNA96well <- function(df, outputpath, wells = 93, nmax = 3){
  # wells = number of wells to print in final table
  # nmax = number of gRNAs per gene
  
  randomScores <- df %>%
    dplyr::group_by(`Gene|Longest_transcript`) %>%
    dplyr::slice_sample(n = nmax) %>%
    dplyr::mutate(IDT_Sequence = paste0(seq_23nt, "GTTTCAAACCCCGACCAGTT"))
  
  groups <- rep(1:ceiling(nrow(randomScores) / wells), each = wells)[1:nrow(randomScores)]
  
  df_list <- split(randomScores, groups)
  
  for (i in seq_along(df_list)) {
    write_csv(df_list[[i]], paste0(outputpath, format(Sys.time(), "%Y%m%d_%H-%M"), "_plate_", i, ".csv"))
    
    # Define the number of samples in the input dataframe
    sample_number = nrow(df_list[[i]])
    
    # Define rows and columns
    rows <- LETTERS[1:8]
    columns <- 1:12
    
    # Create combinations of rows and columns
    well_combinations <- expand.grid(rows, columns)
    
    # Filter the combinations based on the number of samples 
    selected_wells <- well_combinations[1:sample_number, ]
    
    # Combine row and column to create well names
    well_names <- paste0(selected_wells$Var1, selected_wells$Var2)
    
    # Generate a new dataframe with well info starting "A1", "B1", etc
    output_df <- data.frame(
      Well = well_names,
      Name = df_list[[i]]$gRNA_name,
      Sequence = df_list[[i]]$IDT_Sequence)
  
    openxlsx::write.xlsx(output_df, paste0(outputpath, format(Sys.time(), "%Y%m%d_%H-%M"), "_IDT_plate_", i, ".xlsx"))
    
  }
  
  
  
  print("Done!")
  print(paste0("Your tables with ", wells, " gRNAs per plate were saved in ", outputpath))
  
}