# gRNASelect: A package to select gRNAs based on RNA Fold scores and mismatches to the transcriptome
It is specifically designed for the Bazzini Lab at Stowers Institute for Medical Research utilizing the outputs from [gRNADesign](https://github.com/hzuzu/gRNADesign/).

## Instalation
You can install the released version from GitHub with:
```
# install.packages("devtools")
devtools::install_github("GabPescador/gRNASelect")
```

## Example
This is a basic example which shows how the functions select gRNAs per gene based on ATGC% and RNA Fold scores.
```
library(gRNASelect)
head(RNAFoldOutput, n=2)
#>                                         gRNA_name                seq_23nt
                                            <char>                  <char>
1: ENSDART00000136386_ENSDARG00000092856_1107_1129 TTTTTTTTTTTTTTTCGTCAGTC
2:   ENSDART00000136386_ENSDARG00000092856_126_148 CAAATTCAGCCACATTCAAAACC
                 Gene|Longest_transcript Seq_start Seq_end Average_score G_Percentage C_Percentage
                                  <char>     <int>   <int>         <num>        <num>        <num>
1: ENSDART00000136386_ENSDARG00000092856      1107    1129         0.453        8.696       13.043
2: ENSDART00000136386_ENSDARG00000092856       126     148         0.425        4.348       34.783
   A_Percentage T_Percentage      Transcript_ID CDS_UTR
          <num>        <num>             <char>  <char>
1:        4.348       73.913 ENSDART00000136386   3UTR3
2:       43.478       17.391 ENSDART00000136386   5UTR1
```

You can filter gRNAs based on a range of ATGC percentages and easily visualize differences.
```
atgc_filtered <- gRNAatgcFilter(RNAFoldOutput)
cowplot::plot_grid(plotlist = c(gRNAatgcPlot(RNAFoldOutput),
                                gRNAatgcPlot(atgc_filtered)))

```
