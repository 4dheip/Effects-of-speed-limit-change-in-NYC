import xlrd
import csv
import sys

def open_file(path):
    book = xlrd.open_workbook(path)

    first_sheet = book.sheet_by_index(0)

    row_count = first_sheet.nrows - 1
    column_count = first_sheet.ncols - 1

    print 'row_count = ',row_count
    print 'column_count = ', column_count

    final_string = ''
    final_list = list()
    precinct = 0
    prec_temp_str = ''
    precinct_temp = list()
    prec_num_str = ''
    killed = list()
    injured = list()

    b = open(sys.argv[1],'w')
    a = csv.writer(b)

    for i in range(row_count):
        cells = first_sheet.row_slice(rowx=i,
                                start_colx=0,
                                end_colx=9)

        precinct_string = 'Precinct'
        if precinct_string in cells[0].value:
            precinct_temp = (cells[0].value).split()
            prec_temp_str = str(precinct_temp[0])
            #print 'prec_temp_str= ',prec_temp_str
           # print 'precinct_temp = ',precinct_temp[1]
            for ch in prec_temp_str:
                if ch.isdigit():
                    prec_num_str = prec_num_str + ch
            #print 'prec_num_str = ', prec_num_str
            if prec_num_str != '':
                precinct = int(prec_num_str)

        if type(cells[1].value) == float:
            num_collisions = int(cells[1].value)

        if cells[7].value != '' and type(cells[7].value) != float:
           killed = list(cells[7].value)
        if cells[6].value != '' and type(cells[6].value) != float:
           injured = list(cells[6].value)
        if (injured != '' and len(injured) == 9) and (killed != '' and len(killed) == 9) and precinct_temp[0] != '' and cells[0].value != '':
            if prec_temp_str[0].isdigit():
                final_string = str(precinct) + ' ' + str(num_collisions) + ' ' + injured[8] + ' ' + killed[8]
                final_list = final_string.split()
                a.writerow(final_list)
            else:
                final_string = str(precinct_temp[1]) + ' ' + str(num_collisions) + ' ' + injured[8] + ' ' + killed[8]
                final_list = final_string.split()
                a.writerow(final_list)

            #final_list.append(final_string)
            prec_num_str = ''

    b.close()



if __name__ == "__main__":
    path = sys.argv[2]
    open_file(path)
