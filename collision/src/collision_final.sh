#!/bin/bash

module load python/gnu/2.7.11

echo -n "Enter user:"
read user

echo -n "Enter password:"
read pass

python collision_scraping.py

BASE_DIR=$PWD

cd collisions_data

mkdir collision_data_csv

for i in $(find . -name *.xlsx);
do
 cp $i collision_data_csv;
done

for j in $(find . -name *.xls);
do
 cp $j collision_data_csv;
done

cd collision_data_csv

cp $BASE_DIR/data_parsing.py .

cp $BASE_DIR/xlsx2csv.py .

cp $BASE_DIR/xls2csv.py .

hdfs dfs -mkdir /user/$user/Speed_Limit_Collisions

for file_name in *.xlsx;
do
 part_file="$(echo $file_name | cut -f1 -d '.')";
 echo $part_file;
 if [[ $part_file =~ "2013" ]]; then
    python data_parsing.py $part_file.csv $file_name
    if [ -s $part_file.csv ]; then
       hdfs dfs -put $part_file.csv /user/$user/Speed_Limit_Collisions
    fi

 elif [[ $part_file =~ "2014-01" || $part_file =~ "2014-02" ]]; then
    python data_parsing.py $part_file.csv $file_name
    if [ -s $part_file.csv ]; then
       hdfs dfs -put $part_file.csv /user/$user/Speed_Limit_Collisions
    fi

 else
    python xlsx2csv.py -d "," $file_name $part_file.csv
    if [ -s $part_file.csv ]; then
       hdfs dfs -put $part_file.csv /user/$user/Speed_Limit_Collisions
    fi
 fi
done

for file_name in *.xls;
do
 part_file="$(echo $file_name | cut -f1 -d '.')";
 echo $part_file;
 if [[ $part_file =~ "2015-06" ]]; then
    continue
 else
    python xls2csv.py $file_name > $part_file.csv
    if [ -s $part_file.csv ]; then
       hdfs dfs -put $part_file.csv /user/$user/Speed_Limit_Collisions
    fi
 fi
done

\rm *.xlsx *.py *.xls

cd $BASE_DIR

hadoop jar CollisionRec.jar Collision /user/$user/Speed_Limit_Collisions/*.csv /user/$user/Speed_Limit_Collisions/output

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " create database if not exists Final_Project;
use Final_Project;
 
DROP TABLE IF EXISTS collision_data; 
CREATE EXTERNAL TABLE collision_data(
    borough STRING,
    precinct INT,
    month INT,
    year INT,
    collision_at_intersection INT,
    collision_injured_count INT,
    collision_killed_count INT
)
row format delimited fields terminated by ','
location '/user/$user/Speed_Limit_Collisions/output'; 

select count(*) from collision_data; 

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Collisions/output_collision_data' as
select * from collision_data;"

hadoop fs -getmerge /user/$user/Speed_Limit_Collisions/output_collision_data $BASE_DIR/collision_data.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

DROP TABLE IF EXISTS collisions_by_borough;

CREATE TABLE collisions_by_borough
AS
SELECT borough, year, SUM(collision_at_intersection) as total_collision, SUM(collision_injured_count) as total_injured, SUM(collision_killed_count) as total_killed
FROM collision_data
GROUP BY borough, year;

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Collisions/output_collision_borough' as
select * from collisions_by_borough;"

hadoop fs -getmerge /user/$user/Speed_Limit_Collisions/output_collision_borough $BASE_DIR/collision_by_borough.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

DROP TABLE IF EXISTS collisions_by_month;

CREATE TABLE collisions_by_month
AS
SELECT year, month, SUM(collision_at_intersection) as total_collision, SUM(collision_injured_count) as total_injured, SUM(collision_killed_count) as total_killed
FROM collision_data
GROUP BY year, month;

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Collisions/output_collision_month' as
select * from collisions_by_month;"

hadoop fs -getmerge /user/$user/Speed_Limit_Collisions/output_collision_month $BASE_DIR/collision_by_month.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e "USE Final_Project;

DROP TABLE IF EXISTS collisions_by_precinct;

CREATE TABLE collisions_by_precinct
AS
SELECT precinct, year, month, SUM(collision_at_intersection) as total_collision, SUM(collision_injured_count) as total_injured, SUM(collision_killed_count) as total_killed
FROM collision_data
GROUP BY precinct, year, month;

DROP TABLE IF EXISTS csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Collisions/output_collision_precinct' as
select * from collisions_by_precinct;"

hadoop fs -getmerge /user/$user/Speed_Limit_Collisions/output_collision_precinct $BASE_DIR/collision_by_precinct.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e "USE Final_Project;

DROP TABLE IF EXISTS collisions_by_year;

CREATE TABLE collisions_by_year
AS
SELECT year, SUM(collision_at_intersection) as total_collision, SUM(collision_injured_count) as total_injured, SUM(collision_killed_count) as total_killed
FROM collision_data
GROUP BY year;

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Collisions/output_collision_year' as
select * from collisions_by_year;" 

hadoop fs -getmerge /user/$user/Speed_Limit_Collisions/output_collision_year $BASE_DIR/collision_by_year.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

DROP TABLE IF EXISTS speed_collisions_by_year;

CREATE TABLE speed_collisions_by_year
AS
select c.year, c.total_collision, c.total_killed, c.total_injured, v.total_violations from collisions_by_year c join violations_by_year v on (c.year = v.year);

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Collisions/output_speed_collision_year/' as
select * from speed_collisions_by_year;"

hadoop fs -getmerge /user/$user/Speed_Limit_Collisions/output_speed_collision_year $BASE_DIR/speed_collision_by_year.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

DROP TABLE IF EXISTS speed_collisions_by_precinct;

CREATE TABLE speed_collisions_by_precinct
AS
select c.precinct, c.year, c.month, c.total_collision, c.total_injured, c.total_killed, v.total_violations from collisions_by_precinct c join violations_by_precinct v on (c.precinct = v.precinct and c.year = v.year and c.month = v.month) group by c.precinct, c.year, c.month, c.total_collision, c.total_injured, c.total_killed, v.total_violations;

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/$user/Speed_Limit_Collisions/output_speed_collision_prec' as
select * from speed_collisions_by_precinct;"

hadoop fs -getmerge /user/$user/Speed_Limit_Collisions/output_speed_collision_prec $BASE_DIR/speed_collision_by_precinct.csv
