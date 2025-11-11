/* 
Question: What are the most optimal skills to learn (aka it's in high demand and a high paying skill)?
- Identify skills in high demand and associated with high average salaries for data analyst roles
- Concentrates on remote positions with specified salaries
*/

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
HAVING
    COUNT(job_postings_fact.job_id) > 10
ORDER BY
    avg_sal DESC,
    demand DESC;