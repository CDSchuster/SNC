import pandas as pd
import numpy as np

def loadMatrix(input_file, sig):
    """Reads binary expression matrix in csv file and returns it as a pandas df"""
    exp_matrix=pd.read_csv(input_file, sep=";",index_col=0)
    exp_matrix=exp_matrix.apply(lambda x: x.str.replace(',','.'))
    exp_matrix=exp_matrix.apply(pd.to_numeric)
    matrix_filtered_cols=exp_matrix[["2_2", "2_3", "2_4"]]
    transposed_matrix=matrix_filtered_cols.transpose()
    transposed_matrix = transposed_matrix.loc[:,transposed_matrix.apply(pd.Series.nunique) < 1]
    matrix=transposed_matrix.transpose()
    print(matrix)

loadMatrix("symbol_matrix.csv", 0.5)