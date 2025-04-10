# MD Water Services: A Data Analysis Using SQL and Power BI
*By Wondirad Abebe Kifelew*

---

### 🌍 **Project Overview**  

This analysis explores access to water sources in Maji Ndogo; a hypothetical place using a mock survey dataset. The goal is to understand the population's dependency on different water sources and identify patterns in usage so that a better infrastructure could be built while using resources effectively and efficiently. SQL was used for querying and cleaning the dataset, and visualizations are added using power bi and can be found in the visualizations directory for a more comprehensive report.

---

### 📂 **Dataset Description**  

The dataset comes from a table called `water_source` inside the `md_water_services` schema. Each row represents a water source, its type, and the number of people it serves.

![Dashboard screenshot](Images/scr1)

---

### 📊 **Analysis Questions & SQL Queries**  

---

#### 1. 💡 Total Number of People Surveyed (in Millions)

```sql
SELECT 
    SUM(number_of_people_served) / 1000000 AS Total_surveyed_in_millions
FROM 
    md_water_services.water_source;
```
**scr2**

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
**scr3**

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
**scr4**

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
**scr5**

5. 🏅 Ranking Within Each Water Source Type (internal ranking)
```
SELECT 
    *,
    DENSE_RANK() OVER (PARTITION BY type_of_water_source ORDER BY number_of_people_served DESC) AS internal_rank
FROM 
    md_water_services.water_source;
```
**scr6**

📌 Key Insights & Findings
A total of 27.63 million people were surveyed across all water sources.

The most common water source is well, serving 17.52% of the population.

Wells or taps tend to serve more people on average than rivers or springs.

There’s a significant population relying on a small number of highly shared water sources.

📢 Recommendations
Infrastructure Investment: Increase the number of water points in over-utilized categories like well.

Hygiene Campaigns: Focus on rural areas where less protected sources are common.

Monitoring: Use ranking systems to identify sources under strain or at risk.

📬 Contact
For collaboration, feedback, or job opportunities:

Email: wondiradabebekifelew@gmail.com

Phone: +251-976045777

