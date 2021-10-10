python3 matrix_filter.py -i genename_matrix.csv -e 2_2=0 2_3=1 2_4=0 -s 0.5 -o search01.csv
python3 matrix_filter.py -i genename_matrix.csv -e 2_2=0 2_3=-1 2_4=0 -s 0.5 -o search02.csv
python3 matrix_filter.py -i genename_matrix.csv -e 2_2=1 2_3=-1 2_4=1 -s 0.5 -o search03.csv
python3 matrix_filter.py -i genename_matrix.csv -e 2_2=1 2_3=0 2_4=1 -s 0.5 -o search04.csv
python3 matrix_filter.py -i genename_matrix.csv -e 2_2=0 2_3=1 2_4=0 -s 0.5 -o search05.csv
python3 matrix_filter.py -i genename_matrix.csv -e 2_2=0 2_3=-1 2_4=0 -s 0.5 -o search06.csv
python3 matrix_filter.py -i genename_matrix.csv -e 2_2=-1 2_3=0 2_4=-1 -s 0.5 -o search07.csv
python3 matrix_filter.py -i genename_matrix.csv -e 2_2=-1 2_3=1 2_4=-1 -s 0.5 -o search08.csv
python3 matrix_filter.py -i genename_matrix.csv -e 1_2=1 1_3=1 1_4=1 2_1=1 -s 0.5 -o search09.csv
python3 matrix_filter.py -i genename_matrix.csv -e 1_2=-1 1_3=-1 1_4=-1 2_1=-1 -s 0.5 -o search10.csv
python3 matrix_filter.py -i genename_matrix.csv -e 1_1=1 1_2=1 1_3=1 1_4=1 2_1=1 -s 0.5 -o search11.csv
python3 matrix_filter.py -i genename_matrix.csv -e 1_1=-1 1_2=-1 1_3=-1 1_4=-1 2_1=-1 -s 0.5 -o search12.csv
