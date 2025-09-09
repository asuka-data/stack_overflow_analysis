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

**Key Insights**
-  **Python**: The number of questions concerning python is increasing.
-  **Median(Minute) = 34**: On average, it takes about **34 minutes** for the first answer.
-  **75percentile = 5 hours**: 75% of questions receive their first answer within **5 hours***.

  
## Suggestions
- **Repeat coupon** : Deliver repeat coupons after first purchase to convert *one_time* into *repeat*,
- **Weekend Advertisement** : Run targeting Ads on weekend
- **Key Products** : Use top selling products for the ad image
- **Stock Monitoring** : Decrease sales opotunity loss by monitoring high-selling product stock

##  Dashboard
![thelook_ecommerce Dashboard](img/dashboard.png)

--- 

##  Repository Structure
```
stack_overflow_analysis/
├── sql/
│ ├── 01_cleaning.sql
│ ├── 02_monthly_sales.sql
│ ├── 03_cohort.sql
├── results/
│ └── exploration_summary.md
├── img/
│ └── dashboard.png
└── README.md
```
---

##  Contact
Created by Asuka Osuki – [LinkedIn](www.linkedin.com/in/asuka-osuki-24958b32b) 
