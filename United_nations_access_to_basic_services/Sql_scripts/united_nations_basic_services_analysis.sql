-- UNITED NATIONS - BASIC SERVICES

-- 1. GDP per capita and poverty classification
SELECT 
    Country_name,
    Est_gdp_in_billions,
    Est_population_in_millions,
    Time_period,
    (Est_gdp_in_billions / Est_population_in_millions) * 1000 AS GDP_per_capita,
    (Est_gdp_in_billions / Est_population_in_millions) * (1000 / 365.25) AS GDP_per_capita_per_day,
    IF(Time_period < 2017, 1.90, 2.50) AS Poverty_line,
    CASE
        WHEN (Est_gdp_in_billions / Est_population_in_millions) * (1000 / 365.25) < IF(Time_period < 2017, 1.90, 2.50) THEN 'Low income'
        WHEN (Est_gdp_in_billions / Est_population_in_millions) * (1000 / 365.25) > IF(Time_period < 2017, 1.90, 2.50) THEN 'High income'
        ELSE 'Middle income'
    END AS Income_group
FROM 
    united_nations.access_to_basic_services
WHERE 
    Est_gdp_in_billions IS NOT NULL;


-- 2. Unique ID for countries
SELECT 
    DISTINCT Country_name,
    Time_period,
    Est_population_in_millions,
    CONCAT(
        SUBSTRING(IFNULL(UPPER(Country_name), 'UNKNOWN'), 1, 4),
        SUBSTRING(IFNULL(Time_period, 'UNKNOWN'), 1, 4),
        SUBSTRING(IFNULL(Est_population_in_millions, 'UNKNOWN'), -7)
    ) AS Country_id
FROM 
    united_nations.access_to_basic_services;

-- 3. Rank of water services by country and year
SELECT
    Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    RANK() OVER (PARTITION BY Time_period ORDER BY Pct_managed_drinking_water_services) AS Rank_of_water_services
FROM 
    united_nations.access_to_basic_services;

-- 4. Sub-regions (2020, <60% water access, <4 countries) with GDP ranking
SELECT 
    Region,
    Sub_region,
    MIN(Pct_managed_drinking_water_services),
    MAX(Pct_managed_drinking_water_services),
    COUNT(DISTINCT Country_name) AS number_of_countries,
    AVG(Pct_managed_drinking_water_services),
    SUM(Est_gdp_in_billions) AS Sum_Est_gdp_in_billions
FROM 
    united_nations.access_to_basic_services
WHERE 
    Time_period = 2020
    AND Pct_managed_drinking_water_services < 60
GROUP BY 
    Region, Sub_region
HAVING 
    number_of_countries < 4
ORDER BY 
    Sum_Est_gdp_in_billions;

-- 5. Running average of population by sub-region
SELECT
    Sub_region,
    Country_name,
    Time_period,
    Est_population_in_millions,
    ROUND(AVG(Est_population_in_millions) OVER (
        PARTITION BY Sub_region 
        ORDER BY Time_period
    ), 4) AS Running_average_population
FROM 
    united_nations.access_to_basic_services
WHERE 
    Est_population_in_millions IS NOT NULL;

-- 6. Unemployment across Central and Southern Asia + Sub-Saharan Africa
SELECT 
    Country_name,
    Time_period,
    IFNULL(Pct_unemployment, 19.3) AS Unemployment
FROM 
    united_nations.access_to_basic_services
WHERE 
    Region LIKE "%Central and Southern Asia%" 
    OR Region LIKE "%Sub-Saharan Africa%";

-- 7. Access rate change (ARC) of drinking water services
SELECT
    Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    LAG(Pct_managed_drinking_water_services, 1) OVER(PARTITION BY Country_name ORDER BY Time_period) AS Prev_year_Pct,
    Pct_managed_drinking_water_services - LAG(Pct_managed_drinking_water_services) OVER(PARTITION BY Country_name ORDER BY Time_period) AS ARC
FROM 
    united_nations.access_to_basic_services;