USE Final_Project;

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
LOCATION '/user/an2426/Speed_Limit_TLC/output_tlc_monthly' as
select * from tlc_agg_monthly;"
