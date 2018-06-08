USE Final_Project;

DROP TABLE IF EXISTS collisions_by_year;

CREATE TABLE collisions_by_year
AS
SELECT year, SUM(collision_at_intersection) as total_collision, SUM(collision_injured_count) as total_injured, SUM(collision_killed_count) as total_killed
FROM collision_data
GROUP BY year;

drop table if exists csv_dump;

create table csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/an2426/Speed_Limit_Collisions/output_collision_year' as
select * from collisions_by_year;