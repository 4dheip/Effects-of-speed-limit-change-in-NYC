This files describes each of the files used for analytics

1. tlc_master_table.q
   -> This files creates an external table 'tlcmaster' which contains the identifier(xlimit for exceeded speed limit or wlimit for within speed limit), year, month, speed, distance, time, tip and fare fields. The data is added into the table from the output directory where the Map Reduce program is run
   -> A csv_dump table is created in which data from the newly created 'tlcmaster' table is dumped and stored in HDFS for further processing

2. tlc_speeding_cnt_mnth.q
   -> This files creates a table 'tlc_speeding_cnt_mnth' which contains the identifier, year, month, count of records of exceeded speed limit fields
   -> A csv_dump table is created in which data from the newly created 'tlc_speeding_cnt_mnth' table is dumped and stored in HDFS for further processing

3. tlc_speeding_cnt_yr.q
   -> This files creates a table 'tlc_speeding_cnt_yr' which contains the year, identifier, count of exceeded speed limit fields
   -> A csv_dump table is created in which data from the newly created 'tlc_speeding_cnt_yr' table is dumped and stored in HDFS for further processing

4. tlc_agg_annual.q
   -> This files creates a table 'tlc_agg_annual' which contains year, average speed, average distance, average time, average tip(for tip > 0), average fare, tip count, total records and tip percentage ,i.e percentage of number of trips for which tip was paid by the total trips, fields for each year. The data is added into the table from the contents of the 'tlc_master' table
   -> A csv_dump table is created in which data from the newly created 'tlc_agg_annual' table is dumped and stored in HDFS for further processing

5. tlc_agg_monthly.q
   -> This files creates a table 'tlc_agg_monthly' which contains year, month, average speed, average distance, average time, average tip(for tip > 0), average fare, tip count, total records and tip percentage ,i.e percentage of number of trips for which tip was paid by the total trips, fields for each month of each year. The data is added into the table from the contents of the 'tlc_master' table
   -> A csv_dump table is created in which data from the newly created 'tlc_agg_monthly' table is dumped and stored in HDFS for further processing

6. tlc_aggx_annual.q
   -> This files creates a table 'tlc_aggx_annual' which contains year, average speed, average distance, average time, average tip (for tip > 0), average fare and total records of exceeded limits fields. The data is added into the table from the contents of the 'tlc_master' table
   -> A csv_dump table is created in which data from the newly created 'tlc_aggx_annual' table is dumped and stored in HDFS for further processing

7. tlc_aggx_monthly.q
   -> This files creates a table 'tlc_aggx_monthly' which contains year, month, average speed, average distance, average time, average tip (for tip > 0), average fare and total records of exceeded limits fields. The data is added into the table from the contents of the 'tlc_master' table
   -> A csv_dump table is created in which data from the newly created 'tlc_aggx_monthly' table is dumped and stored in HDFS for further processing

