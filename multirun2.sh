python3 matrix_filter.py -i gb_matrix.csv -e 2_2=1 2_3=1 2_4=1 -s 0.5 -o search01.csv
python3 matrix_filter.py -i gb_matrix.csv -e 2_2=-1 2_3=-1 2_4=-1 -s 0.5 -o search02.csv
python3 matrix_filter.py -i gb_matrix.csv -e 2_2=1 2_3=1 2_4=0 -s 0.5 -o search03.csv
python3 matrix_filter.py -i gb_matrix.csv -e 2_2=-1 2_3=-1 2_4=0 -s 0.5 -o search04.csv
