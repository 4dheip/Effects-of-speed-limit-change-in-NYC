#!/bin/bash

echo -n "Enter user:"
read user

echo -n "Enter password:"
read pass

python tlc_scrapping.py

BASE_DIR=$PWD

cd tlc_data/

hdfs dfs -mkdir /user/$user/Speed_Limit_TLC

hdfs dfs -put $PWD/*.csv /user/$user/Speed_Limit_TLC

cd $BASE_DIR

hadoop jar tlc.jar tlcProgram /user/$user/Speed_Limit_TLC/*.csv /user/$user/Speed_Limit_TLC/output

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " create database if not exists Final_Project;

use Final_Project;

drop table if exists tlcmaster;
create external table tlcmaster(
	identifier STRING,
	year STRING,
	month STRING,
	speed DECIMAL(4,2),
	distance DECIMAL(4,2),
	time DECIMAL(4,2),
	tip DECIMAL(4,2),
	fare DECIMAL(4,2))
row format delimited fields terminated by ','
location '/user/$user/Speed_Limit_TLC/output';

select count(*) from tlcmaster; 

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ','  lines terminated by '\n'
location '/user/$user/Speed_Limit_TLC/output_tlc_data' as
select * from tlcmaster;"

hadoop fs -getmerge /user/$user/Speed_Limit_TLC/output_tlc_data $BASE_DIR/tlcmaster.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

drop table if exists tlc_speeding_cnt_mnth;

create table tlc_speeding_cnt_mnth as
select * from (select identifier, year, month, count(speed) as count_exceeded_limit from tlcmaster group by identifier, year, month)A order by A.year ASC, A.month ASC, A.identifier ASC;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ','lines terminated by '\n'
location '/user/$user/Speed_Limit_TLC/output_tlc_countmt' as
select * from tlc_speeding_cnt_mnth;"

hadoop fs -getmerge /user/$user/Speed_Limit_TLC/output_tlc_countmt $BASE_DIR/tlc_speeding_cnt_mnth.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

drop table if exists tlc_speeding_cnt_yr;

create table tlc_speeding_cnt_yr as
select * from (select  year, identifier, count(speed) as count_exceeded_limit from tlcmaster group by year, identifier) A order by A.year ASC;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ','lines terminated by '\n'
location '/user/$user/Speed_Limit_TLC/output_tlc_count' as
select * from tlc_speeding_cnt_yr;"

hadoop fs -getmerge /user/$user/Speed_Limit_TLC/output_tlc_count $BASE_DIR/tlc_speeding_cnt_yr.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

drop table if exists tlc_agg_annual;

create table tlc_agg_annual as
select * from
(select A.year, A.avg_speed, A.avg_distance, A.avg_time, B.avg_tip, A.avg_fare, B.tip_count, A.total_records, round(((B.tip_count/A.total_records) * 100),2) as tip_per  from
(select year, avg(speed) as avg_speed, avg(distance) as avg_distance, avg(time) as avg_time, avg(fare) as avg_fare, count(*) as total_records from tlcmaster group by year) A
join
(select year, avg(tip) as avg_tip, count(tip) as tip_count from tlcmaster where tip > 0 group by year) B
on A.year=B.year) C order by C.year asc;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ','lines terminated by '\n'
location '/user/$user/Speed_Limit_TLC/output_tlc_annual' as
select * from tlc_agg_annual;"

hadoop fs -getmerge /user/$user/Speed_Limit_TLC/output_tlc_annual $BASE_DIR/tlc_agg_annual.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

drop table if exists tlc_aggx_annual;

create table tlc_aggx_annual as
select * from
(select A.year, A.avg_speed, A.avg_distance, A.avg_time, B.avg_tip, A.avg_fare, B.tip_count, A.x_total_records from
(select year, avg(speed) as avg_speed, avg(distance) as avg_distance, avg(time) as avg_time, avg(fare) as avg_fare, count(*) as x_total_records from tlcmaster where identifier = 'xlimit' group by year) A
join
(select year, avg(tip) as avg_tip, count(tip) as tip_count from tlcmaster where tip > 0 and identifier = 'xlimit' group by year) B
on A.year=B.year) C order by C.year asc;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ',' lines terminated by '\n'
location '/user/$user/Speed_Limit_TLC/output_tlc_annualx' as
select * from tlc_aggx_annual;"

hadoop fs -getmerge /user/$user/Speed_Limit_TLC/output_tlc_annualx $BASE_DIR/tlc_aggx_annual.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e "USE Final_Project;

drop table if exists tlc_agg_monthly;

create table tlc_agg_monthly as
select * from
(select A.year, A.month, concat(cast(A.year as varchar(10)),'-',cast(A.month as varchar(10))) as year_month, A.avg_speed, A.avg_distance, A.avg_time, B.avg_tip, A.avg_fare, B.tip_count, A.total_records, round(((B.tip_count/A.total_records) * 100),2) as tip_per  from
(select year, month, avg(speed) as avg_speed, avg(distance) as avg_distance, avg(time) as avg_time, avg(fare) as avg_fare, count(*) as total_records from tlcmaster group by year, month) A
join
(select year, month, avg(tip) as avg_tip, count(tip) as tip_count from tlcmaster where tip > 0 group by year, month) B
on A.year=B.year and A.month=B.month) C order by C.year asc, C.month asc;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ',' lines terminated by '\n'
LOCATION '/user/$user/Speed_Limit_TLC/output_tlc_monthly' as
select * from tlc_agg_monthly;" 

hadoop fs -getmerge /user/$user/Speed_Limit_TLC/output_tlc_monthly $BASE_DIR/tlc_agg_monthly.csv

hive --service beeline -u jdbc:hive2://babar.es.its.nyu.edu:10000/ -n $user -p $pass -e " USE Final_Project;

drop table if exists tlc_aggx_monthly;

create table tlc_aggx_monthly as
select * from
(select A.year, A.month, concat(cast(A.year as varchar(10)),'-',cast(A.month as varchar(10))) as year_month, A.avg_speed, A.avg_distance, A.avg_time, B.avg_tip, A.avg_fare, B.tip_count, A.x_total_records from
(select year, month, avg(speed) as avg_speed, avg(distance) as avg_distance, avg(time) as avg_time, avg(fare) as avg_fare, count(*) as x_total_records from tlcmaster where identifier = 'xlimit' group by year, month) A
join
(select year, month, avg(tip) as avg_tip, count(tip) as tip_count from tlcmaster where tip > 0 and identifier = 'xlimit' group by year, month) B
on A.year=B.year and A.month=B.month) C order by C.year asc, C.month asc;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ',' lines terminated by '\n'
LOCATION '/user/$user/Speed_Limit_TLC/output_tlc_monthlyx' as
select * from tlc_aggx_monthly;"

hadoop fs -getmerge /user/$user/Speed_Limit_TLC/output_tlc_monthlyx $BASE_DIR/tlc_aggx_monthly.csv


