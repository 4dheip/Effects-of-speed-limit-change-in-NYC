Follow the below steps to run the project for the NYPD Moving Violation Summonses data

Website - "http://www.nyc.gov/html/nypd/html/traffic_reports/traffic_summons_reports.shtml"
Data url - "http://www.nyc.gov/html/nypd/downloads/zip/traffic_data/"

1. Log into NYU DUMBO account

2. Place all the below files in the directory where the project will be run
   -> TrafficViolation.java
   -> TrafficViolationMapper.java
   -> TrafficViolationMapper.class
   -> TrafficViolation.class 
   -> TrafficViolation.jar
   -> xlsx2csv.py
   -> violations_scraping.py
   -> violations_final.sh
   
   The .class files and jar file can be used directly or optionally can be created by compiling and running the .java files
   
3. Give executable permissions to the shell script - violations_final.sh

4. Run the shell script using -> ./violations_final.sh
   
   The script will do the below processing
      
   -> The violations_scraping.py script will be called which will download the data from NYPD Motor Vehicle Accidents website into violations_data  directly which will be created in the directory in which the script is run
   
   -> The downloaded files will be moved into a new directory - "violations_data_csv" where all the .xlsx files will be converted into csv files with the use of the scripts - xlsx2csv.py. These csv files will be put into HDFS into the 'Speed_Limit_Violations' directory previously created on HDFS.     
   
   -> The script will then run the Map Reduce program and store the output in 'Speed_Limit_Violations/output' directory
   
   -> The contents of the output folder will be used to run the analytics queries using Hive. The queries are explicitly written in the shell script. For reference, refer the below files in Analytics folder for the queries:
      	  - violations_table.q
	  - violations_by_borough.q
	  - violations_by_year.q
	  - violations_by_month.q
	  - violations_by_precinct.q
	  
   -> The data from the tables created in Hive will be exported into the below CSV files in the directory in which the shell script was run 
          - violations_data.csv
	  - violations_by_borough.csv
	  - violations_by_year.csv
	  - violations_by_month.csv
	  - violations_by_precinct.csv
	  
5. Download the CSV files on local machine and load them into Tableau for visualization
   -> Open the below files in Tableau to see visualizations performed for current project
	  - violations_by_precinct.twbx
	  - violations_by_borough.twbx
	  
References:
-> Dilshod Temirkhodjaev. “xlsx to csv converter – (http://github.com/dilshod/xlsx2csv)”
