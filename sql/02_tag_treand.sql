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
