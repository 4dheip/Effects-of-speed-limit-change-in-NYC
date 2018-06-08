USE Final_Project;

DROP TABLE IF EXISTS speed_collisions_by_precinct;

CREATE TABLE speed_collisions_by_precinct
AS
select c.precinct, c.year, c.month, c.total_collision, c.total_injured, c.total_killed, v.total_violations from collisions_by_precinct c join violations_by_precinct v on (c.precinct = v.precinct and c.year = v.year and c.month = v.month) group by c.precinct, c.year, c.month, c.total_collision, c.total_injured, c.total_killed, v.total_violations;

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/an2426/Speed_Limit_Collisions/output_speed_collision_prec' as
select * from speed_collisions_by_precinct;
