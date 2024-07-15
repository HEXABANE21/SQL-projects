create database corona;
use corona;
select * From corona_virus;


-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values
select * 
FROM corona_Virus
where Province IS NULL OR 
      country_Region IS NULL OR
      latitude IS NULL OR
      Longitude IS NULL OR
      Date IS NULL OR
      Confirmed IS NULL OR
      Deaths IS NULL OR
      Recovered IS NULL ;

-- Q2. If NULL values are present, update them with zeros for all columns. 
-- No Null Values found in the data . 

-- Q3. check total number of rows
SELECT count(*) AS Count_of_rows
From corona_virus;


-- Q4. Check what is start_date and end_date

-- Step 1: Add a new date column
ALTER TABLE corona_Virus ADD COLUMN Date_ DATE;
SET sql_safe_updates = 0;

-- Step 2: Update the new column with converted date values
UPDATE corona_Virus SET Date_ = STR_TO_DATE(date,'%d-%m-%Y');
SET sql_safe_updates = 1;

-- Step 3: Drop the old text column
ALTER TABLE corona_Virus DROP COLUMN date;

-- Step 4: Rename the new column to the original column name
ALTER TABLE corona_Virus CHANGE COLUMN Date_ Date DATE;

-- Step 5: Check for the start and end date
Select min(date) AS Start_date,
       max(date) AS End_date
from corona_virus;


-- Q5. Number of month present in dataset
SELECT TIMESTAMPDIFF(MONTH, '2020-01-22', '2021-06-13') AS Total_Months;


-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT  year(date) AS YEAR, monthname(date) AS MONTH, 
		avg(confirmed) AS AVG_CONFIMED_CASES, 
        avg(deaths) AS AVG_DEATHS, 
		avg(recovered) AS AVG_RECOVERED
FROM corona_virus
GROUP BY monthname(date), year(date);

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 


WITH MONTHLYCOUNTS AS(
SELECT 
YEAR(DATE) AS YEAR,
MONTH(DATE) AS MONTH,
CONFIRMED,
DEATHS,
RECOVERED,
ROW_NUMBER() OVER (PARTITION BY YEAR(DATE), MONTH(DATE), 
CONFIRMED, 
DEATHS, 
RECOVERED 
ORDER BY COUNT(*) DESC) AS M
FROM CORONA_VIRUS
GROUP BY YEAR(DATE), MONTH(DATE), CONFIRMED, DEATHS, RECOVERED
)
SELECT YEAR, MONTH, CONFIRMED, DEATHS, RECOVERED
FROM MONTHLYCOUNTS
WHERE M = 1;


-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT YEAR(DATE) AS YEAR, 
MIN(CONFIRMED) AS MIN_cases, 
MIN(DEATHS) AS MIN_deaths, 
MIN(RECOVERED) AS MIN_recovered
FROM corona_virus
GROUP BY YEAR;


-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT YEAR(DATE) AS YEAR, 
MAX(CONFIRMED) AS MAX_cases, 
MAX(DEATHS) AS MAX_deaths, 
MAX(RECOVERED) AS MAX_recovered
FROM corona_virus
GROUP BY YEAR;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT YEAR(DATE) AS YEAR, 
MONTH(DATE) AS MONTH, 
SUM(CONFIRMED) AS Total_cases, 
SUM(DEATHS) AS Total_deaths, 
SUM(RECOVERED) AS Total_recovered
FROM corona_virus
GROUP BY YEAR, MONTH;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT  SUM(CONFIRMED) AS Total_confirmed_cases, 
        CAST(avg(CONFIRMED) AS DECIMAL(10, 2)) AS Avg_cases, 
        CAST(variance(CONFIRMED) AS DECIMAL(10, 2)) AS Variance, 
        CAST(stddev(CONFIRMED) AS DECIMAL(10, 2)) AS standard_deviation
FROM corona_virus;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT  YEAR(DATE) AS YEAR,MONTH(DATE) AS MONTH,
        SUM(DEATHS) AS Total_cases, 
		CAST(avg(DEATHS) AS DECIMAL(10, 2)) AS Avg_cases, 
        CAST(variance(DEATHS) AS DECIMAL(10, 2)) AS Variance, 
         CAST(stddev(DEATHS) AS DECIMAL(10, 2)) AS standard_deviation
FROM corona_virus
GROUP BY YEAR, MONTH;


-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT  SUM(RECOVERED) AS Recovered_cases,
        CAST(avg(RECOVERED) AS DECIMAL(10, 2)) AS Avg_cases, 
        CAST(variance(RECOVERED) AS DECIMAL(10, 2))AS Variance, 
        CAST(stddev(RECOVERED) AS DECIMAL(10, 2)) AS standard_deviation
FROM corona_virus;



-- Q14. Find Country having highest number of the Confirmed case
SELECT 
country_region, 
SUM(CONFIRMED) AS Total_cases
FROM corona_virus
GROUP BY country_region
order by Total_cases desc
LIMIT 1;

-- Q15. Find Country having lowest number of the death case
SELECT 
country_region, 
SUM(CONFIRMED) AS Total_cases
FROM corona_virus
GROUP BY country_region
order by Total_cases 
LIMIT 1;

-- Q16. Find top 5 countries having highest recovered case
SELECT 
country_region, 
SUM(RECOVERED) AS Recovered_cases
FROM corona_virus
GROUP BY country_region
order by Recovered_cases desc
LIMIT 5;
