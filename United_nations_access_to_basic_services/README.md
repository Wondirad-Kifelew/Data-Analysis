# United Nations: Access to Basic Services (SQL Analysis)

*By Wondirad Abebe Kifelew*

---
![By weekday](Images/4.jpg)
---

### 🌍 **Project Overview**

This SQL-based data analysis explores the accessibility of basic services, especially **managed drinking water**, across countries using data from the **United Nations**.

The goal is to:

- Understand disparities in water access and economic conditions.
- Rank countries and subregions by GDP and water service availability.
- Track population growth and unemployment trends.

This analysis was performed using **SQL** to extract insights, supported by **Power BI** visualizations.

---

### 📂 **Dataset Description**

The analysis uses a single table from the `united_nations.access_to_basic_services` dataset, which includes:

- GDP estimates  
- Population data  
- Water service availability  
- Unemployment rates  
- Time period and regional info

---

### 📊 **Analysis Questions & SQL Queries with Results**

---

#### 1. 💰 GDP per Capita and Poverty Classification

```sql
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
```

![By weekday](Images/4.jpg)

---

### 2. 🔢 Unique ID for Countries
```
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
```

![By weekday](Images/4.jpg)

---


### 3. 🏆 Water Services Rank by Country and Year
```
SELECT
    Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    RANK() OVER (PARTITION BY Time_period ORDER BY Pct_managed_drinking_water_services) AS Rank_of_water_services
FROM
    united_nations.access_to_basic_services;
```

![By weekday](Images/4.jpg)

---


### 4. 📉 Sub-regions with Low Water Access & GDP Ranking
```
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
```

![By weekday](Images/4.jpg)

---


### 5. 👥 Running Average of Population by Sub-region
```
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
```

![By weekday](Images/4.jpg)

---


### 6. 📉 Unemployment in Key Regions
```
SELECT
    Country_name,
    Time_period,
    IFNULL(Pct_unemployment, 19.3) AS Unemployment
FROM
    united_nations.access_to_basic_services
WHERE
    Region LIKE "%Central and Southern Asia%"
    OR Region LIKE "%Sub-Saharan Africa%";
```

![By weekday](Images/4.jpg)

---


### 7. 🔁 Access Rate Change (ARC) of Drinking Water
```
SELECT
    Country_name,
    Time_period,
    Pct_managed_drinking_water_services,
    LAG(Pct_managed_drinking_water_services, 1) OVER(PARTITION BY Country_name ORDER BY Time_period) AS Prev_year_Pct,
    Pct_managed_drinking_water_services - LAG(Pct_managed_drinking_water_services) OVER(PARTITION BY Country_name ORDER BY Time_period) AS ARC
FROM
    united_nations.access_to_basic_services;
```

![By weekday](Images/4.jpg)

---


### 📌 Key Insights
- Many low-income countries fall below the poverty line defined by the World Bank ($1.90 or $2.50/day).
- Some sub-regions have very low water access (<60%) and very few countries in them.
- Central & Southern Asia and Sub-Saharan Africa show high unemployment rates.
- There's a clear improvement or decline in water access rates across time in certain countries.
- Countries with rising GDP don't always show parallel improvements in basic services.
  
  ---

### 📢 Recommendations
- Focus infrastructure and aid efforts on low-access subregions with <4 countries.
- Develop employment projects in Sub-Saharan Africa and Southern Asia.
- Monitor GDP growth in relation to water service improvements.
- Identify best practices in countries showing consistent improvement in water access.

  ---

###  📬 Contact
** For collaboration, feedback, or job opportunities: **
📧 Email: wondiradabebekifelew@gmail.com
📞 Phone: +251-976045777
