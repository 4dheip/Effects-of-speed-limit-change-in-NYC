CREATE DATABASE IF NOT EXISTS Final_Project;
USE Final_Project;
DROP TABLE IF EXISTS violations_data;
CREATE EXTERNAL TABLE violations_data (
    borough STRING,
    precinct INT,
    month INT,
    year INT,
    type STRING,
    count INT
)
row format delimited fields terminated by ','
location '/user/an2426/Speed_Limit_Violations/output';

SELECT COUNT(*) FROM violations_data;

DROP TABLE IF EXISTS csv_dump;

CREATE TABLE csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/an2426/Speed_Limit_Violations/output_violations_data' as
SELECT * FROM violations_data;