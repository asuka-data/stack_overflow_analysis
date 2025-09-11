-- Calculate hour to answer by combining question and answer table
WITH tta AS(
  SELECT 
   q.id, 
   q.creation_date AS question_time,
   MIN(a.creation_date) AS first_answer
FROM `bigquery-public-data.stackoverflow.posts_questions` AS q
JOIN bigquery-public-data.stackoverflow.posts_answers AS a
ON q.id = a.parent_id
GROUP BY 1,2
)
SELECT 
  tta.id,
  TIMESTAMP_DIFF(tta.first_answer,tta.question_time, HOUR) AS hour_to_answer 
FROM tta
WHERE tta.first_answer IS NOT NULL
      AND TIMESTAMP_DIFF(tta.first_answer,tta.question_time, HOUR) >= 0   -- Remove NULL and invalid data
ORDER BY hour_to_answer


-- Calculate TTA by tag
WITH base AS(
  SELECT 
    id, creation_date, tags
  FROM bigquery-public-data.stackoverflow.posts_questions
),
tta AS(
  SELECT
    parent_id,
    MIN(creation_date) AS first_answer
  FROM bigquery-public-data.stackoverflow.posts_answers
  GROUP BY parent_id
),
question_tag AS(
  SELECT
    id,
    tag,
    creation_date
  FROM base
  CROSS JOIN UNNEST(IFNULL(SPLIT(tags,'|'),[])) AS tag
),
diff AS(
  SELECT
   question_tag.tag,
   TIMESTAMP_DIFF(tta.first_answer, question_tag.creation_date, MINUTE) AS minute_to_answer
  FROM question_tag
  JOIN tta
  ON question_tag.id = tta.parent_id
  WHERE tta.first_answer >= question_tag.creation_date
)
SELECT
  tag,
  APPROX_QUANTILES(diff.minute_to_answer,100)[OFFSET(50)] AS median_minute_to_answer,
  APPROX_QUANTILES(diff.minute_to_answer,100)[OFFSET(90)] AS p90_minutes
FROM diff
GROUP BY tag
ORDER BY median_minute_to_answer;
