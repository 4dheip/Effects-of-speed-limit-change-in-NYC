create database if not exists Final_Project;

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
location '/user/an2426/Speed_Limit_TLC/output';

select count(*) from tlcmaster;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ','  lines terminated by '\n'
location '/user/an2426/Speed_Limit_TLC/output_tlc_data' as
select * from tlcmaster;