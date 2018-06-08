USE Final_Project;

DROP TABLE IF EXISTS violations_by_precinct;

CREATE TABLE violations_by_precinct
AS
SELECT precinct, year, month, SUM(count) as total_violations
FROM violations_data
GROUP BY precinct, year, month;

DROP TABLE IF EXISTS csv_dump;

CREATE TABLE csv_dump ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
LOCATION '/user/an2426/Speed_Limit_Violations/output_violations_precinct' as
SELECT * FROM violations_by_precinct;
