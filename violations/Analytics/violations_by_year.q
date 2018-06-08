USE Final_Project;

DROP TABLE IF EXISTS violations_by_year;

CREATE TABLE violations_by_year
AS
SELECT year, SUM(count) as total_violations
FROM violations_data
GROUP BY year;
SELECT * FROM violations_by_year;

DROP TABLE IF EXISTS csv_dump;

CREATE TABLE csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/an2426/Speed_Limit_Violations/output_violations_year' as
SELECT * FROM violations_by_year;
