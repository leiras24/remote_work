WITH
  overwhelmed AS (
  SELECT
    Age,
    Gender,
    Region,
    Industry,
    Job_Role AS Job,
    Work_Arrangement,
    Hours_Per_Week,
    Mental_Health_Status AS Mental_Health,
    Burnout_Level,
    Work_Life_Balance_Score,
    Physical_Health_Issues,
    Social_Isolation_Score,
    (CASE
        WHEN Salary_Range = '$40K-60K' THEN 50000
        WHEN Salary_Range = '$60K-80K' THEN 70000
        WHEN Salary_Range = '$80K-100K' THEN 90000
        WHEN Salary_Range = '$100K-120K' THEN 110000
        WHEN Salary_Range = '$120K+' THEN 140000
    END
      ) AS salary,
    (
      CASE
        WHEN Hours_Per_Week > 45 THEN 1
        ELSE 0
    END
      +
      CASE
        WHEN Mental_Health_Status <> 'None' THEN 1
        ELSE 0
    END
      +
      CASE
        WHEN Burnout_Level = 'Medium' THEN 1
        WHEN Burnout_Level = 'High' THEN 2
        ELSE 0
    END
      +
      CASE
        WHEN Work_Life_Balance_Score = 3 THEN 1
        WHEN Work_Life_Balance_Score < 2 THEN 2
        ELSE 0
    END
      +
      CASE
        WHEN Social_Isolation_Score BETWEEN 2 AND 3 THEN 1
        WHEN Social_Isolation_Score > 4 THEN 2
        ELSE 0
    END
      ) AS risk_score
  FROM
    `buoyant-lattice-448512-t4.remote1.health_remote`)
SELECT
  *,
  CASE
    WHEN risk_score <= 2 THEN 'Healthy'
    WHEN risk_score BETWEEN 3 AND 4 THEN 'At Risk'
    WHEN risk_score BETWEEN 5 AND 6 THEN 'Unhealthy'
    WHEN risk_score >= 7 THEN 'Very Unhealthy'
END
  AS staff_health
FROM
  overwhelmed