
--  MD WATER SERVICES ANALYSIS


-- 1. Total number of people surveyed (in millions)
SELECT 
    SUM(number_of_people_served) / 1000000 AS Total_surveyed_in_millions
FROM 
    md_water_services.water_source;

-- 2. Count of wells, taps, and rivers
SELECT 
    type_of_water_source,
    COUNT(*) AS Count
FROM 
    md_water_services.water_source
GROUP BY 
    type_of_water_source;

-- 3. Average number of people sharing each type of water source
SELECT 
    type_of_water_source,
    AVG(number_of_people_served) AS Avg_people_served
FROM 
    md_water_services.water_source
GROUP BY 
    type_of_water_source;

-- 4. Population by water source type
SELECT 
    type_of_water_source,
    SUM(number_of_people_served) AS population_sharing_it,
    RANK() OVER (ORDER BY SUM(number_of_people_served) DESC) AS rank_by_population,
    ROUND(SUM(number_of_people_served) / 276000) AS percent_of_pop_sharing,
    AVG(number_of_people_served) AS avg_people,
    COUNT(*) AS number_of_sources
FROM 
    md_water_services.water_source
GROUP BY 
    type_of_water_source;

-- 5. Ranking within each water source type
SELECT 
    *,
    DENSE_RANK() OVER (PARTITION BY type_of_water_source ORDER BY number_of_people_served DESC) AS rank_within_type
FROM 
    md_water_services.water_source;

-- 6. Duration of survey
SELECT 
    DATEDIFF(MAX(time_of_record), MIN(time_of_record)) AS days_taken
FROM 
    md_water_services.visits;

-- 7. Average queue time (excluding 0)
SELECT 
    AVG(NULLIF(time_in_queue, 0)) AS avg_queue_time
FROM 
    md_water_services.visits;

-- 8. Queue time by day of week
SELECT 
    DAYNAME(time_of_record) AS day,
    AVG(NULLIF(time_in_queue, 0)) AS avg_queue
FROM 
    md_water_services.visits
GROUP BY 
    DAYNAME(time_of_record)
ORDER BY 
    avg_queue DESC;

-- 9. Queue time by hour of day
SELECT 
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    AVG(time_in_queue) AS avg_queue
FROM 
    md_water_services.visits
GROUP BY 
    hour_of_day
ORDER BY 
    avg_queue DESC;

-- 10. Queue time breakdown per hour per weekday
SELECT
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue END), 0) AS Sunday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue END), 0) AS Monday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue END), 0) AS Tuesday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue END), 0) AS Wednesday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue END), 0) AS Thursday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue END), 0) AS Friday,
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue END), 0) AS Saturday
FROM
    md_water_services.visits
WHERE 
    time_in_queue != 0
GROUP BY 
    hour_of_day
ORDER BY 
    hour_of_day;