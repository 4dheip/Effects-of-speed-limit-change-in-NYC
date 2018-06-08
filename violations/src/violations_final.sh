#!/bin/bash

module load python/gnu/2.7.11

echo -n "Enter user:"
read user

echo -n "Enter password:"
read pass

python violations_scraping.py

BASE_DIR=$PWD

cd violations_data

mkdir violations_data_csv

for i in $(find . -name *.xlsx);
do
 cp $i violations_data_csv;
done

cd violations_data_csv

cp $BASE_DIR/xlsx2csv.py .

hdfs dfs -mkdir /user/$user/Speed_Limit_Violations

for file_name in *.xlsx;
do
 part_file="$(echo $file_name | cut -f1 -d '.')";
 echo $part_file;
 python xlsx2csv.py -d "," $file_name $part_file.csv
done

\rm *.xlsx *.py

cd $BASE_DIR

hdfs dfs -put violations_data/violations_data_csv/*.csv /user/$user/Speed_Limit_Violations

hadoop jar TrafficViolation.jar TrafficViolation /user/$user/Speed_Limit_Violations/*.csv /user/$user/Speed_Limit_Violations/output

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e "CREATE DATABASE IF NOT EXISTS Final_Project;
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
location '/user/$user/Speed_Limit_Violations/output';

SELECT COUNT(*) FROM violations_data;

DROP TABLE IF EXISTS csv_dump;

CREATE TABLE csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Violations/output_violations_data' as
SELECT * FROM violations_data;"

hadoop fs -getmerge /user/$user/Speed_Limit_Violations/output_violations_data $BASE_DIR/violations_data.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e "USE Final_Project;

DROP TABLE IF EXISTS violations_by_borough;
CREATE TABLE violations_by_borough
AS
SELECT borough, year, SUM(count) as total_violations
FROM violations_data
GROUP BY borough, year;

DROP TABLE IF EXISTS csv_dump;

CREATE TABLE csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Violations/output_violations_borough' as
SELECT * FROM violations_by_borough;"

hadoop fs -getmerge /user/$user/Speed_Limit_Violations/output_violations_borough $BASE_DIR/violations_by_borough.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e "USE Final_Project;

DROP TABLE IF EXISTS violations_by_month;

CREATE TABLE violations_by_month
AS
SELECT year, month, SUM(count) as total_violations
FROM violations_data
GROUP BY year, month;
SELECT * FROM violations_by_month;

DROP TABLE IF EXISTS csv_dump;

CREATE TABLE csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Violations/output_violations_month' as
SELECT * FROM violations_by_month;"

hadoop fs -getmerge /user/$user/Speed_Limit_Violations/output_violations_month $BASE_DIR/violations_by_month.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e "USE Final_Project;

DROP TABLE IF EXISTS violations_by_precinct;

CREATE TABLE violations_by_precinct
AS
SELECT precinct, year, month, SUM(count) as total_violations
FROM violations_data
GROUP BY precinct, year, month;

DROP TABLE IF EXISTS csv_dump;

CREATE TABLE csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Violations/output_violations_precinct' as
SELECT * FROM violations_by_precinct;"

hadoop fs -getmerge /user/$user/Speed_Limit_Violations/output_violations_precinct $BASE_DIR/violations_by_precinct.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e "USE Final_Project;

DROP TABLE IF EXISTS violations_by_year;

CREATE TABLE violations_by_year
AS
SELECT year, SUM(count) as total_violations
FROM violations_data
GROUP BY year;
SELECT * FROM violations_by_year;

DROP TABLE IF EXISTS csv_dump;

CREATE TABLE csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Violations/output_violations_year' as
SELECT * FROM violations_by_year;"

hadoop fs -getmerge /user/$user/Speed_Limit_Violations/output_violations_year $BASE_DIR/violations_by_year.csv
