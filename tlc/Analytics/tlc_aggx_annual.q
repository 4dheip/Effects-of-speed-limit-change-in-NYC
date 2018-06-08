use Final_Project;

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
location '/user/an2426/Speed_Limit_TLC/output_tlc_annualx' as
select * from tlc_aggx_annual;