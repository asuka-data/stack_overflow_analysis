## Stack Overflow Data Analysis


## 1. Data Preperartion
- Review the data required for analysis 
- Review data structures and ranges
- Define cleaning rules


## 2. Data Cleaning Steps
- Excluded Null data: `creation_date` IS NULL
- Excluded invalid data: `first_answer` >= `question_creation_date`

## 3. Data Exploration Sumaary
### Key SQL

#### TTA 
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
