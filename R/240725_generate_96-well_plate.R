aj_96well_by_column <- function(input_df){
  # Define the number of samples in the input dataframe
  sample_number = nrow(input_df)
  
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
    Name = input_df$unique_id,
    Sequence = input_df$oligo_seq)
  
  return(output_df)
}