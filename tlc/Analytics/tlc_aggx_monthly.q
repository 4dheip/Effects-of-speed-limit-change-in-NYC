USE Final_Project;

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
LOCATION '/user/an2426/Speed_Limit_TLC/output_tlc_monthlyx' as
select * from tlc_aggx_monthly;