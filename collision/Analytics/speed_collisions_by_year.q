USE Final_Project;

DROP TABLE IF EXISTS speed_collisions_by_year;

CREATE TABLE speed_collisions_by_year
AS
select c.year, c.total_collision, c.total_killed, c.total_injured, v.total_violations from collisions_by_year c join violations_by_year v on (c.year = v.year);

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/an2426/Speed_Limit_Collisions/output_speed_collision_year/' as
select * from speed_collisions_by_year;
