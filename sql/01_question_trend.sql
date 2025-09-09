-- Calculate date range 
SELECT
  MIN(DATE(creation_date)) AS min_date,
  MAX(DATE(creation_date)) AS max_date
FROM bigquery-public-data.stackoverflow.posts_questions;


-- Calculate total questions by Year
SELECT
  COUNT(*) AS total,
  EXTRACT(YEAR FROM creation_date) AS year
FROM bigquery-public-data.stackoverflow.posts_questions
GROUP BY year
ORDER BY year;


-- Calculate total questions by Year and Month
SELECT
  COUNT(*) AS total,
  FORMAT_DATE('%Y%m',DATE(creation_date)) AS ym
FROM bigquery-public-data.stackoverflow.posts_questions
GROUP BY ym
ORDER BY ym;


-- Calculate average answers per question by Year
SELECT
  COUNT(a.id) AS total_answers,
  COUNT(DISTINCT a.parent_id) AS answered_questions,
  SAFE_DIVIDE(COUNT(DISTINCT a.parent_id),COUNT(a.id)) AS avg_per_questions,
  EXTRACT(YEAR FROM creation_date) AS year
FROM bigquery-public-data.stackoverflow.posts_answers AS a   
GROUP BY year
ORDER BY year;


-- Calculate answered rate by Year
SELECT
  COUNT(DISTINCT q.id) AS total_questions,
  COUNT(DISTINCT a.parent_id) AS answered_questions,
  SAFE_DIVIDE(COUNT(DISTINCT a.parent_id),COUNT(q.id)) AS answered_rate,
  EXTRACT(YEAR FROM a.creation_date) AS year
FROM bigquery-public-data.stackoverflow.posts_questions AS q
JOIN bigquery-public-data.stackoverflow.posts_answers AS a  
ON q.id = a.parent_id 
GROUP BY year
ORDER BY year;
