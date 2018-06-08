This files describes each of the files used for analytics

1. violations_table.q
   -> This files creates an external table 'violations_data' which contains the borough, precinct, year, month, type and count fields. The data is added into the table from the output directory where the Map Reduce program is run
   -> A csv_dump table is created in which data from the newly created 'violations_data' table is dumped and stored in HDFS for further processing
   
2. violations_by_borough.q
   -> This files creates a table 'violations_by_borough' which contains the borough, year and sum of total violations fields. The data is added into the table from the contents of the 'violations_data' table
   -> A csv_dump table is created in which data from the newly created 'violations_by_borough' table is dumped and stored in HDFS for further processing

3. violations_by_year.q
   -> This files creates a table 'violations_by_year' which contains the year and sum of total violations fields. The data is added into the table from the contents of the 'violations_data' table
   -> A csv_dump table is created in which data from the newly created 'violations_by_year' table is dumped and stored in HDFS for further processing
   
4. violations_by_month.q
   -> This files creates a table 'violations_by_month' which contains the year, month and sum of total violations fields. The data is added into the table from the contents of the 'violations_data' table
   -> A csv_dump table is created in which data from the newly created 'violations_by_month' table is dumped and stored in HDFS for further processing
   
5. violations_by_precinct.q
   -> This files creates a table 'violations_by_precinct' which contains the precinct, year, month and sum of total violations fields. The data is added into the table from the contents of the 'violations_data' table
   -> A csv_dump table is created in which data from the newly created 'violations_by_precinct' table is dumped and stored in HDFS for further processing