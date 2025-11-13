### **Introduction**

Welcome to my SQL Portfolio Project, where I delve into the data job market with a focus on data analyst roles. This project is a personal exploration into identifying the top-paying jobs, in-demand skills, and the intersection of high demand with high salary in the field of data analytics.

Check out my SQL queries here: [project_sql](https://github.com/aayushiguptaeconomist-prog/SQL_Data_Project/tree/0fd51124026ea7dfeeb48baa7d14d9ce05ce14d4/project_sql). 

Check out my Tableau Dashboard visualizing salary trends and demand frequency trends for data analyst skills: [https://public.tableau.com/views/Book1_17630093381640/Dashboard2?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link](https://public.tableau.com/views/DataAnalystInsights_17630728072080/Dashboard1?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

### **Background**

The motivation behind this project stemmed from my desire to understand the data analyst job market better. I aimed to discover which skills are paid the most and in demand, making my job search more targeted and effective. 

The data for this analysis is from Luke Barousse’s SQL Course ([include link to the course](https://www.lukebarousse.com/products/sql-for-data-analytics/categories/2157430710/posts/2186736147)). This data includes details on job titles, salaries, locations, and required skills. 

The questions I wanted to answer through my SQL queries were:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?

### Tools I Used

In this project, I utilized a variety of tools to conduct my analysis:

- **SQL** (Structured Query Language): Enabled me to interact with the database, extract insights, and answer my key questions through queries.
- **PostgreSQL**: As the database management system, PostgreSQL allowed me to store, query, and manipulate the job posting data.
- **Visual Studio Code:** This open-source administration and development platform helped me manage the database and execute SQL queries.

### Analysis

Each query for this project aimed at investigating specific aspects of the data analyst job market. Here’s how I approached each question:

### 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    job_postings_fact.job_location,
    company_dim.name AS company_name,
    job_postings_fact.job_schedule_type,
    job_postings_fact.salary_year_avg,
    job_postings_fact.job_posted_date
FROM
    job_postings_fact
    LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_location = 'Anywhere' AND
    job_postings_fact.salary_year_avg IS NOT NULL
ORDER BY
    job_postings_fact.salary_year_avg DESC
LIMIT
    10;

```

### 2. Skills for Top Paying Jobs

To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
-- Gets the top 10 paying Data Analyst jobs
WITH top_pay_jobs AS (
    SELECT
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        company_dim.name AS company_name,
        job_postings_fact.salary_year_avg
    FROM
        job_postings_fact
        LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_postings_fact.job_location = 'Anywhere' AND
        job_postings_fact.salary_year_avg IS NOT NULL
    ORDER BY
        job_postings_fact.salary_year_avg DESC
    LIMIT
        10
)

SELECT 
    top_pay_jobs.*,
    skills_dim.skills
FROM 
    top_pay_jobs
INNER JOIN skills_job_dim on top_pay_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
        top_pay_jobs.salary_year_avg DESC;

```

### 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC;

```
<img width="974" height="632" alt="Screenshot 2025-11-12 at 10 00 11 PM" src="https://github.com/user-attachments/assets/df066b7d-7c9c-4eef-8737-3be34ce8c694" />

### 4. Skills Based on Salary

Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_sal
FROM
    skills_dim
LEFT JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
LEFT JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skills
ORDER BY
    avg_sal DESC
LIMIT 25;

```
<img width="971" height="631" alt="Screenshot 2025-11-12 at 10 02 40 PM" src="https://github.com/user-attachments/assets/5d449c01-151b-4955-9bce-1b8c15ed5157" />

### 5. Most Optimal Skills to Learn

Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg)) AS avg_sal,
    COUNT(job_postings_fact.job_id) AS demand
FROM
    skills_dim
INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_postings_fact.job_work_from_home = TRUE AND
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skills
ORDER BY
    avg_sal DESC,
    demand DESC;

```
<img width="637" height="631" alt="Screenshot 2025-11-12 at 10 03 41 PM" src="https://github.com/user-attachments/assets/0189abbc-46c1-478e-b29d-d3998491cffe" />

Each query not only served to answer a specific question but also to improve my understanding of SQL and database analysis. Through this project, I learned to leverage SQL's powerful data manipulation capabilities to derive meaningful insights from complex datasets.

### **What I Learned**

Throughout this project, I honed several key SQL techniques and skills:

- **Complex Query Construction**: Learning to build advanced SQL queries that combine multiple tables and employ functions like **`WITH`** clauses for temporary tables.
- **Data Aggregation**: Utilizing **`GROUP BY`** and aggregate functions like **`COUNT()`** and **`AVG()`** to summarize data effectively.
- **Analytical Thinking**: Developing the ability to translate real-world questions into actionable SQL queries that got insightful answers.

### **Insights**

From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs**: High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries**: Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value**: SQL and Python lead in demand and offer for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### **Conclusion**

This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
