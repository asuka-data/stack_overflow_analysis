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

## Key Insights
-  **Python**: The number of questions concerning python is increasing.
-  **Median(Minute) = 34**: On average, it takes about **34 minutes** for the first answer.
-  **75percentile = 5 hours**: 75% of questions receive their first answer within **5 hours***.

  
## Suggestions

---

##  Dashboard
- Sample Visual(Trend lines by year)
![Stack Overflow Dashboard](results/img/Dashboard.png)

- Tableau Public
  [View Interactive Dashboard on Tableau Public](https://public.tableau.com/views/StackOverflow_17575488423400/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

--- 

##  Repository Structure
```
stack_overflow_analysis/
├── sql/
│   ├── 01_question_trend.sql
│   ├── 02_tag_trend.sql
│   └── 03_tta.sql
├── results/
│   ├── report.md
│   └── img/
│       ├── Dashboard.png
│       ├── trend-plot.png
│       └── tag_popularity.png
└── README.md
```
---

##  Contact
Created by Asuka Osuki – [LinkedIn](www.linkedin.com/in/asuka-osuki-24958b32b) 
