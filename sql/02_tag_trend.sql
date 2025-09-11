-- Calculate popular tag trend by year and month
WITH question_tag AS(
  SELECT
    id,
    tag,
    creation_date
  FROM bigquery-public-data.stackoverflow.posts_questions
  CROSS JOIN UNNEST(IFNULL(
    SPLIT(tags,'|'),[]))
    AS tag
)
SELECT
  COUNT(*) AS total,
  question_tag.tag AS tag_type,
  FORMAT_DATE('%Y%m',DATE(creation_date)) AS ym
FROM question_tag
WHERE tag IN('sql','python','javascript')   -- limited major tags
GROUP BY ym, tag_type
ORDER BY ym, tag_type;


-- Calculate response speed by tag
WITH data AS(
  SELECT
    id, creation_date, tags
  FROM bigquery-public-data.stackoverflow.posts_questions
),
tta AS(
  SELECT
   q.id,
   q.creation_date AS question_created,
   MIN(a.creation_date) AS first_answer
 FROM data AS q
 JOIN bigquery-public-data.stackoverflow.posts_answers AS a
 ON q.id = a.parent_id
 GROUP BY 1,2
),
diff AS(
  SELECT
    tta.id,
    TIMESTAMP_DIFF(first_answer, question_created, MINUTE) AS minute_to_answer
  FROM tta
  WHERE first_answer >= question_created
),
question_tags AS(
  SELECT
    data.id,
    LOWER(TRIM(tag)) AS tag  --standarize tag names
  FROM data
  CROSS JOIN UNNEST(
    IFNULL(SPLIT(data.tags,'|'),[]) --split tags by '|' and avoid Null errors
  ) AS tag
)
SELECT
  question_tags.tag,
  COUNT(*) AS answered_qs,   -- total questions having each tag
  APPROX_QUANTILES(diff.minute_to_answer,100)[OFFSET(50)] AS p50_minutes,
  APPROX_QUANTILES(diff.minute_to_answer,100)[OFFSET(90)] AS p90_minutes,
  AVG(diff.minute_to_answer) AS avg_minutes
FROM diff
JOIN question_tags
ON diff.id = question_tags.id
GROUP BY tag
HAVING answered_qs >= 100  -- Limit only having enough data volume
ORDER BY p50_minutes
LIMIT 100;

| Row | tag        | answered_qs | p50_minutes | p90_minutes | avg_minutes        |
|-----|------------|-------------|-------------|-------------|--------------------|
| 1   | yugabytedb | 286         | 0           | 2939        | 2128.2412587412591 |
| 2   | c++-faq    | 167         | 3           | 23          | 1810.8562874251509 |
| 3   | sizeof     | 1906        | 4           | 39          | 3768.624344176289  |
| 4   | scjp       | 283         | 4           | 42          | 3429.9999999999995 |
| 5   | jquery-on  | 159         | 4           | 46          | 3362.4968553459112 |


