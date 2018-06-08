USE Final_Project;

drop table if exists tlc_speeding_cnt_mnth;

create table tlc_speeding_cnt_mnth as
select * from (select identifier, year, month, count(speed) as count_exceeded_limit from tlcmaster group by identifier, year, month)A order by A.year ASC, A.month ASC, A.identifier ASC;

drop table if exists csv_dump;

create table csv_dump row format delimited
fields terminated by ','lines terminated by '\n'
location '/user/an2426/Speed_Limit_TLC/output_tlc_coutnmt' as
select * from tlc_speeding_cnt_mnth;