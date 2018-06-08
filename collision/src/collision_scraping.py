import os
import re
import StringIO
import zipfile
import requests

file_count = 0
data_dir = "collisions_data/"
collision_url = "http://www.nyc.gov/html/nypd/downloads/zip/traffic_data/"

if not os.path.exists(data_dir):
    os.makedirs(data_dir)

#downloading data for years 2013-2016
for year in range(2013, 2017):
    for month in range(1, 13):
        if(year > 2015 or (year == 2015 and month > 6)):
            file_part_name = "col"
        else:
            file_part_name = "acc"

        file_name = "%04d_%02d_%s_excel.zip" % (year, month, file_part_name)

        if os.path.isfile(data_dir + file_name):
            print "File %s was already downloaded" % file_name

        response = requests.get(collision_url + file_name, stream=True)
        cont_length = response.headers.get('content-length')

        if cont_length is None or response.status_code == 404:
            print "File %s doesn't exist" % file_name

        print "Downloading and extracting %s" % file_name
        file_count += 1

        zipped_file = zipfile.ZipFile(StringIO.StringIO(response.content))
        zipped_file.extractall("%s/%04d/%02d" % (data_dir, year, month))

print "Downloaded %d files" % file_count

for root, _, filenames in os.walk(data_dir):
    for filename in [f for f in filenames
                     if f.startswith("city") or f.startswith("bkh") or f.startswith("mnh") or f.startswith("bxh") or f.startswith("qnh") or f.startswith("sih")]: 
        os.remove(os.path.join(root, filename))

#unzipping the files and renaming them
for year in range(2013, 2017):
    for month in range(1, 13):
        unzipped_dir = "%s/%04d/%02d" % (data_dir, year, month)
        
        if os.path.isdir(unzipped_dir):
            for file_name_old in os.listdir(unzipped_dir):
                os.rename(os.path.join(unzipped_dir, file_name_old), os.path.join(unzipped_dir, "%04d-%02d-%s" % (year, month, file_name_old)))
