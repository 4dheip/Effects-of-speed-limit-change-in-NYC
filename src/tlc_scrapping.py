import os
import sys
import requests

file_count = 0
data_dir = "tlc_data/"
tlc_url = "https://s3.amazonaws.com/nyc-tlc/trip+data/"

if not os.path.exists(data_dir):
    os.makedirs(data_dir)

for year in range(2013, 2017):
	for month in range(1,13):
                
        	file_name = "yellow_tripdata_%04d-%02d.csv" % (year, month)

        	if os.path.isfile(data_dir + file_name):
            		print "File %s already exists" % file_name

        	response = requests.get(tlc_url + file_name, stream=True)
        	cont_length = response.headers.get('content-length')

        	if cont_length is None:
            		print "File %s not found" % file_name

        	with open(data_dir + file_name, "wb") as output:
            		print "Downloading %s" % file_name
	    		file_count += 1
	    		downloaded = 0
	
			for chunk in response.iter_content(chunk_size=4096):
                		#if chunk:
                    			#downloaded += len(chunk)
                    		output.write(chunk)
                    	print "File %s downloaded" % file_name
print "Total Number of Files Downloaded = %d" % file_count
