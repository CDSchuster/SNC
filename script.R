library("dplyr")

matrix=read.csv2("symbol_matrix.csv")

filtered_cols=select(matrix, "X", "X2_2", "X2_3", "X2_4")

filtered_rows_cols=filter(filtered_cols, X2_2>0.5 | X2_3 >0.5 | X2_4>0.5 | X2_2 < -0.5 | X2_3 < -0.5 | X2_4 < -0.5)
colnames(filtered_rows_cols)=c("Gene symbol", "2_2", "2_3", "2_4")
write.csv2(filtered_rows_cols, file="filtered_data.csv")
