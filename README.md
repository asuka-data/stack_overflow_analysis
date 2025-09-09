# Stack Overflow Analysis

## Project Overview
This project anlyzes Stack Overflow data to figure out technical treands and community health using Stack Overflow's puclic data.

---

## Analysis Points
- **Total questions Trend**: Capture technical trends
- **Time to Answer(TTA)**: Measure community health level
- **Suggestions**: Provide insghts for the operational strategies

---

## Data source  
Big Query Public data - [stackoverflow](bigquery-public-data.stackoverflow)
- post_questions - [post_questions](bigquery-public-data.stackoverflow.posts_questions)
- post-answers - [post_answers](bigquery-public-data.stackoverflow.posts_answers)

---

##  Tools Used
- **Google BigQuery**: Data cleaning, transformation, and analysis using SQL
- **Tableau**: Data visualization and dashboard creation
- **GitHub**: Version control and portfolio hosting

---

## Cleaning Rules
- **creation_date IS NOT NULl**: Excluded missing answer data
- **first_answer >= question_creation_date**: Removed invalid data

---

### Key SQL
```sql
-- calculate median and quantiles of Time-To-Answer (TTA)
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
**Shor Insights**
-  **Median(Hour) = 0**: In most cases, answers arrive within the first hour.
-  **Median(Minute) = 34**: On average, it takes about **34 minutes** for the first answer.
-  **75percentile = 5 hours**: 75% of questions receive their first answer within **5 hours***.
