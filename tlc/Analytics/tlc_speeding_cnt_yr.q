use Final_Project;

drop table if exists tlc_speeding_cnt_yr;

create table tlc_speeding_cnt_yr as
select * from (select  year, identifier, count(speed) as count_exceeded_limit from tlcmaster group by year, identifier) A order by A.year ASC;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ','lines terminated by '\n'
location '/user/an2426/Speed_Limit_TLC/output_tlc_count' as
select * from tlc_speeding_cnt_yr;