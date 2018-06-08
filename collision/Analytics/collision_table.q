create database if not exists Final_Project;

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
location '/user/an2426/Speed_Limit_Collisions/output';

select count(*) from collision_data;

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/an2426/Speed_Limit_Collisions/output_collision_data' as
select * from collision_data;