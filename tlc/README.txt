Follow the below steps to run the project for the NYC Trip Record data

Website - "http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml"
Data url - "https://s3.amazonaws.com/nyc-tlc/trip+data/"

1. Log into NYU DUMBO account

2. Place all the below files in the directory where the project will be run
   -> tlcProgram.java
   -> tlcProgram.class   
   -> tlcMapper.java
   -> tlcMapper.class  
   -> tlc.jar
   -> tlc_scrapping.py
   -> tlc.sh
   
   The .class files and jar file can be used directly or optionally can be created by compiling and running the .java files
   
3. Give executable permissions to the shell script - tlc.sh

4. Run the shell script using -> ./tlc.sh
   
   The script will do the below processing
      
   -> The tlc_scrapping.py script will be called which will download the data from NYC Trip Record website into tlc_data/  directly which will be created in the directory in which the script is run
   
   -> These csv files will be put into HDFS into the 'Speed_Limit_TLC’ directory previously created on HDFS.     
   
   -> The script will then run the Map Reduce program and store the output in 'Speed_Limit_TLC/output' directory
   
   -> The contents of the output folder will be used to run the analytics queries using Hive. The queries are explicitly written in the shell script. For reference, refer the below files in Analytics folder for the queries:
      	  - tlc_master_table.q
	  - tlc_agg_annual.q
	  - tlc_agg_monthly.q
	  - tlc_aggx_annual.q
	  - tlc_aggx_monthly.q
	  
	  - tlc_speeding_cnt_yr.q
	  
	  - tlc_speeding_cnt_mnth.q
	  
   -> The data from the tables created in Hive will be exported into the below CSV files in the directory in which the shell script was run 
      	  - tlcmaster.csv
	  - tlc_agg_annual.csv
	  - tlc_agg_monthly.csv
	  - tlc_aggx_annual.csv
	  - tlc_aggx_monthly.csv	  
	  - tlc_speeding_cnt_yr.csv	  
	  - tlc_speeding_cnt_mnth.csv

5. Download the CSV files on local machine and load them into Tableau for visualization
   -> Open the below files in Tableau to see visualizations performed for current project
	  - tlc_annual.twbx
	  - tlc_annualx.twbx
	  - tlc_monthly.twbx
	  - tlc_monthlyx.twbx
	  
