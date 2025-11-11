/*
Ques: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest paying Data Analyst jobs from first query.
- Add the specific skills required for these roles.
*/

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


-- Export the data in CSV file to visualize it later on Tableau
