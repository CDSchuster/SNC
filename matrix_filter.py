import pandas as pd
import argparse
import matplotlib.pyplot as plt
import numpy as np


def plot_histogram(exp_matrix):
    values=[round(item, 3) for col in exp_matrix for item in exp_matrix[col]]
    print(np.mean(values), np.std(values))
    plt.hist(values, range=[-2, 2], bins=500)
    plt.savefig("histogram.png")
    return True


def loadMatrix(input_file, sig):
    """Reads binary expression matrix in csv file and returns it as a pandas df"""
    exp_matrix=pd.read_csv(input_file, sep=";",index_col=0)
    exp_matrix=exp_matrix.apply(lambda x: x.str.replace(',','.'))
    exp_matrix=exp_matrix.apply(pd.to_numeric)
    plot_histogram(exp_matrix)
    for col in exp_matrix:
        exp_matrix[col]=exp_matrix[col].apply(lambda x: 0 if abs(x)<sig else x/abs(x))
    return exp_matrix.astype(int)


def select_rows(matrix, equal_to, diff_than, significance, outfile):
    """Slices expression matrix according to user-given criteria"""
    matrix=loadMatrix(matrix, float(significance))
    if equal_to!=None:
        equal_dict={crit.split("=")[0]:int(crit.split("=")[1]) for crit in equal_to}
        for key in equal_dict.keys(): matrix=matrix.loc[matrix[key] == equal_dict[key]]
    if diff_than!=None:
        diff_dict={crit.split("=")[0]:int(crit.split("=")[1]) for crit in diff_than}
        for key in diff_dict.keys(): matrix=matrix.loc[matrix[key] != diff_dict[key]]
    transposed_matrix=matrix.transpose()
    transposed_matrix = transposed_matrix.loc[:,transposed_matrix.apply(pd.Series.nunique) != 1]
    matrix=transposed_matrix.transpose()
    matrix.to_csv(outfile, sep=",")
    return matrix


def parse_arguments():
    """parses all necessary arguments"""
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", dest="matrix", nargs=1,
                        help="The expression matrix to be analyzed")
    parser.add_argument("-e", dest="equal_to", nargs='+',
                        help="Rows to filter by column value")
    parser.add_argument("-d", dest="diff_than", nargs='+',
                        help="Rows to filter by column difference to value")
    parser.add_argument("-s", dest="significance", nargs=1,
                        help="standard deviation cut for significance")
    parser.add_argument("-o", dest="outf", nargs=1,
                        help="Output file")
    return parser.parse_args()


def main():
    args=parse_arguments()
    select_rows(args.matrix[0], args.equal_to, args.diff_than, args.significance[0], args.outf[0])


if __name__ == "__main__":
    main()
