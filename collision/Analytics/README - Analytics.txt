This files describes each of the files used for analytics

1. collision_table.q
   -> This files creates an external table 'collision_data' which contains the borough, precinct, year, month, collision_at_intersection, collision_injured_count and collision_killed_count fields. The data is added into the table from the output directory where the Map Reduce program is run
   -> A csv_dump table is created in which data from the newly created 'collision_data' table is dumped and stored in HDFS for further processing
   
2. collision_by_borough.q
   -> This files creates a table 'collisions_by_borough' which contains the borough, year, sum of collisions, sum of injured and sum of killed fields. The data is added into the table from the contents of the 'collision_data' table
   -> A csv_dump table is created in which data from the newly created 'collisions_by_borough' table is dumped and stored in HDFS for further processing

3. collision_by_year.q
   -> This files creates a table 'collisions_by_year' which contains the year, sum of collisions, sum of injured and sum of killed fields. The data is added into the table from the contents of the 'collision_data' table
   -> A csv_dump table is created in which data from the newly created 'collisions_by_year' table is dumped and stored in HDFS for further processing
   
4. collision_by_month.q
   -> This files creates a table 'collision_by_month' which contains the year, month, sum of collisions, sum of injured and sum of killed fields. The data is added into the table from the contents of the 'collision_data' table
   -> A csv_dump table is created in which data from the newly created 'collision_by_month' table is dumped and stored in HDFS for further processing
   
5. collision_by_precinct.q
   -> This files creates a table 'collision_by_precinct' which contains the year, sum of collisions, sum of injured and sum of killed fields. The data is added into the table from the contents of the 'collision_data' table
   -> A csv_dump table is created in which data from the newly created 'collision_by_precinct' table is dumped and stored in HDFS for further processing
   
6. speed_collisions_by_year.q
   -> This files creates a table 'speed_collisions_by_year' which joins the two tables - 'collisions_by_year' and 'violations_by_year' on year field. This table contains the year, sum of collisions, sum of injured, sum of killed fields and sum of speeding violations. e
   -> A csv_dump table is created in which data from the newly created 'speed_collisions_by_year' table is dumped and stored in HDFS for further processing
   
7. speed_collisions_by_precinct.q
   -> This files creates a table 'speed_collisions_by_precinct' which joins the two tables - 'collisions_by_precinct' and 'violations_by_precinct' on year, month and precinct fields. This table contains the precinct, year, month, sum of collisions, sum of injured, sum of killed fields and sum of speeding violations. e
   -> A csv_dump table is created in which data from the newly created 'speed_collisions_by_precinct' table is dumped and stored in HDFS for further processing