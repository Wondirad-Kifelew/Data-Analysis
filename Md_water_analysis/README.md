# MD Water Services: A Data Analysis Using SQL and Power BI
*By Wondirad Abebe Kifelew*

---

### 🌍 **Project Overview**  

This analysis explores access to water sources in Maji Ndogo; a hypothetical place using a mock survey dataset. The goal is to understand the population's dependency on different water sources and identify patterns in usage so that a better infrastructure could be built while using resources effectively and efficiently. SQL was used for querying and cleaning the dataset, and visualizations are added using power bi and can be found in the visualizations directory for a more comprehensive report.

---

### 📂 **Dataset Description**  

The dataset comes from several tables called `water_source`, `location`, `visits` inside the `md_water_services` schema.

---

### 📊 **Analysis Questions & SQL Queries along with their results**  

---

#### 1. 💡 Total Number of People Surveyed (in Millions)

```
SELECT 
    SUM(number_of_people_served) / 1000000 AS Total_surveyed_in_millions
FROM 
    md_water_services.water_source;
```
![Dashboard screenshot](Images/scr2.jpg)

---
2. 🧾 Count of Each Water Source Type (Well, Tap, River, etc.)
```
SELECT 
    type_of_water_source,
    COUNT(*) AS Count
FROM 
    md_water_services.water_source
GROUP BY 
    type_of_water_source;
```
![Dashboard screenshot](Images/scr3-table.jpg)

3. 👥 Average Number of People Sharing Each Type of Water Source
```
SELECT 
    type_of_water_source,
    AVG(number_of_people_served) AS Avg_people_served
FROM 
    md_water_services.water_source
GROUP BY 
    type_of_water_source;
```
![Dashboard screenshot](Images/scr4.jpg)

4. 📈 Total Population by Water Source Type & Rank
```
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
```
![Dashboard screenshot](Images/scr5.jpg)

5. Number of water sources in rural vs urban 
```
SELECT
    location_type, count(location_id) as count   
FROM
    md_water_services.location 
group by
    location_type;
```
![Dashboard screenshot](Images/1.jpg)

6. Shared taps show stagguring numbers
![Dashboard screenshot](Images/2.jpg)

7. Queue waiting times
   
   7.1 Average waiting time
     ```
     SELECT 
         AVG(NULLIF(time_in_queue, 0)) AS avg_queue_time
     FROM 
         md_water_services.visits;
     ```
    ![Dashboard screenshot](Images/3.jpg)
   
    7.2 Queue time by hour of the day
     ```
        SELECT 
            TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
            AVG(time_in_queue) AS avg_queue
        FROM 
            md_water_services.visits
        GROUP BY 
            hour_of_day
        ORDER BY 
            avg_queue DESC;
    
     ```
   ![Dashboard screenshot](Images/5.jpg)

   7.3 Queue time by day of the week
     ```
       SELECT 
            DAYNAME(time_of_record) AS day,
            AVG(NULLIF(time_in_queue, 0)) AS avg_queue
       FROM 
            md_water_services.visits
       GROUP BY 
            DAYNAME(time_of_record)
       ORDER BY 
            avg_queue DESC;

     ```
![Dashboard screenshot](Images/4.jpg)



📌 Key Insights & Findings
- A total of 27.63 million people were surveyed across all water sources.

- The most common water source is well, serving 17.52% of the population.

- Wells or taps tend to serve more people on average than rivers or springs.

- There’s a significant population relying on a small number of highly shared water sources.

- Most water sources are found in rural places

- 43% of the people are using shared taps. Around 2000 people often share one tap.

- The citizens often face long wait times for water, averaging more than 120 minutes:

    • Queues are very long on Saturdays.
    • Queues are longer in the mornings and evenings.
    • Wednesdays and Sundays have the shortest queues.

📢 Recommendations
- Most people will benefit if shared taps are improved first.
  
- Fixing existing infrastructure will help many people. If they have running water again, they won't have to queue, thereby shorting queue times for others.
  
- Most water sources are in rural areas. The teams need to know this as this means they will have to make these repairs/upgrades in
rural areas where road conditions, supplies, and labour are harder challenges to overcome.


📬 Contact
For collaboration, feedback, or job opportunities:

Email: wondiradabebekifelew@gmail.com

Phone: +251-976045777

