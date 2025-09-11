## Stack Overflow Data Analysis


## 1. Data Preperartion
- Review the data required for analysis 
- Review data structures and ranges
- Define cleaning rules


## 2. Data Cleaning Steps
- Excluded Null data: `creation_date` IS NULL
- Excluded invalid data: `first_answer` >= `question_creation_date`

## 3. Data Exploration Sumary
### Key SQL

#### Questions, Answered Questions, and Answer Rate by Year
```sql
-- Calculate answered rate by Year
SELECT
  EXTRACT(YEAR FROM a.creation_date) AS year,
  COUNT(q.id) AS total_questions,
  COUNT(DISTINCT a.parent_id) AS answered_questions,
  ROUND(SAFE_DIVIDE(COUNT(DISTINCT a.parent_id),COUNT(q.id)),4) AS answered_rate
FROM bigquery-public-data.stackoverflow.posts_questions AS q
JOIN bigquery-public-data.stackoverflow.posts_answers AS a  
ON q.id = a.parent_id 
GROUP BY year
ORDER BY year;

| Row | year | answered_questions | answered_rate | total_questions |
|-----|------|--------------------|---------------|-----------------|
| 1   | 2008 | 56265              | 0.2686        | 209513          |
| 2   | 2009 | 348260             | 0.374         | 931215          |
| 3   | 2010 | 703918             | 0.4832        | 1456666         |
| 4   | 2011 | 1229941            | 0.5432        | 2264350         |
| 5   | 2012 | 1674085            | 0.5929        | 2823422         |
| 6   | 2013 | 2060696            | 0.6217        | 3314677         |
| 7   | 2014 | 2115963            | 0.662         | 3196317         |
| 8   | 2015 | 2144389            | 0.6822        | 3143467         |
| 9   | 2016 | 2119694            | 0.6899        | 3072291         |
| 10  | 2017 | 2038933            | 0.7021        | 2903966         |
| 11  | 2018 | 1818196            | 0.7122        | 2552774         |
| 12  | 2019 | 1720972            | 0.7181        | 2396507         |
| 13  | 2020 | 1808051            | 0.74          | 2443453         |
| 14  | 2021 | 1516794            | 0.7568        | 2004334         |
| 15  | 2022 | 1013610            | 0.7731        | 1311167         |
```

#### Analysis of TTA 
```sql
-- calculate median and percentiles of Time-To-Answer (TTA)
WITH tta AS(
  SELECT 
   q.id, 
   q.creation_date AS question_time,
   MIN(a.creation_date) AS first_answer
FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
JOIN bigquery-public-data.stackoverflow.posts_answers AS a
ON q.id = a.parent_id
GROUP BY 1,2
),
diffs AS(
 SELECT 
  tta.id,
  TIMESTAMP_DIFF(tta.first_answer,tta.question_time, HOUR) AS hour_to_answer,
  TIMESTAMP_DIFF(tta.first_answer,tta.question_time,MINUTE) AS minute_to_answer
 FROM tta
 WHERE tta.first_answer IS NOT NULL
      AND TIMESTAMP_DIFF(tta.first_answer,tta.question_time, HOUR) >= 0
)
SELECT
  APPROX_QUANTILES(diffs.hour_to_answer,100)[OFFSET(50)] AS h_median,
  APPROX_QUANTILES(diffs.hour_to_answer,100)[OFFSET(75)] AS h_75p,
  APPROX_QUANTILES(diffs.minute_to_answer,100)[OFFSET(50)] AS m_median
FROM diffs;

| h_median | h_75p | m_median |
|----------|-------|----------|
| 0        | 5     | 34       |

```
**Insights**
-  **Median(Hour) = 0**: In most cases, answers arrive within the first hour.
-  
