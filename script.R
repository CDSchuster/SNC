library("dplyr")

matrix=read.csv2("symbol_matrix.csv")
filtered=matrix["X", "X2_2"]
