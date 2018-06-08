Follow the below steps to run the project for the NYPD Motor Vehicle Accidents data

Website - "http://www.nyc.gov/html/nypd/html/traffic_reports/motor_vehicle_collision_data.shtml"
Data url - "http://www.nyc.gov/html/nypd/downloads/zip/traffic_data/"

1. Log into NYU DUMBO account

2. Place all the below files from src folder in the directory where the project will be run
   -> Collision.java
   -> CollisionMapper.java
   -> CollisionMapper.class
   -> Collision.class 
   -> CollisionRec.jar
   -> data_parsing.py
   -> xls2csv.py
   -> xlsx2csv.py
   -> collision_scraping.py
   -> collision_final.sh
   
   The .class files and jar file can be used directly or optionally can be created by compiling and running the .java files
   
3. Give executable permissions to the shell script - collision_final.sh

4. Run the shell script using -> ./collision_final.sh
   
   The script will do the below processing
      
   -> The collision_scraping.py script will be called which will download the data from NYPD Motor Vehicle Accidents website into collisions_data  directly which will be created in the directory in which the script is run
   
   -> The downloaded files will be moved into a new directory - "collision_data_csv" where all the .xlsx and .xls files will be converted into csv files with the use of the following scripts - data_parsing.py, xls2csv.py and xlsx2csv.py. These csv files will be put into HDFS into the 'Speed_Limit_Collisions' directory previously created on HDFS.     
   
   -> The script will then run the Map Reduce program and store the output in 'Speed_Limit_Collisions/output' directory
   
   -> The contents of the output folder will be used to run the analytics queries using Hive. The queries are explicitly written in the shell script. For reference, refer the below files in Analytics folder for the queries:
      - collision_table.q
	  - collision_by_borough.q
	  - collision_by_year.q
	  - collision_by_month.q
	  - collision_by_precinct.q
	  - speed_collisions_by_precinct.q
	  - speed_collisions_by_year.q
	  
   -> The data from the tables created in Hive will be exported into the below CSV files in the directory in which the shell script was run 
      - collision_data.csv
	  - collision_by_borough.csv
	  - collision_by_year.csv
	  - collision_by_month.csv
	  - collision_by_precinct.csv
	  - speed_collision_by_precinct.csv
	  - speed_collision_by_year.csv
	  
5. Download the CSV files on local machine and load them into Tableau for visualization
   -> Open the below files in Tableau to see visualizations performed for current project
      - Final Project.twbx
	  - Collisions_by_precinct.twbx
	  - collisions_by_borough.twbx
	  
References:
-> Dilshod Temirkhodjaev. “xlsx to csv converter – (http://github.com/dilshod/xlsx2csv)”
-> Alexander Mikhailov. “xls to csv converter – “https://github.com/hempalex/xls2csv)”
