
WITH t1 AS (
    SELECT step4.*, hadm_id, intime, outtime
    FROM step4
    LEFT JOIN icustays USING (icustay_id)        
),
t2 AS (
    SELECT subject_id, hadm_id, chartdate AS echo_time
    FROM noteevents
    WHERE category = 'Echo'
),
t3 AS (
    SELECT t1.*, t2.echo_time
    FROM t1
    LEFT JOIN t2 USING (hadm_id)
),
t4 AS (
    SELECT *
    FROM t3
    -- 只选择入ICU前一天至出ICU期间做的超声，或者没有做超声
    WHERE (echo_time BETWEEN date_trunc('day', intime - INTERVAL '1' DAY) AND outtime OR echo_time IS NULL)
),
t5 AS (
    SELECT icustay_id, age, intime, outtime, MIN(echo_time) AS echo_time
    FROM t4
    GROUP BY icustay_id, age, intime, outtime
),
t6 AS (
    SELECT *
    FROM mimiciii.patients AS p
    LEFT JOIN mimiciii.sofa AS s ON p.subject_id = s.subject_id
),


t7 AS (
    SELECT
        SUM(CASE WHEN t5.echo_time IS NOT NULL THEN 1 ELSE 0 END) AS echo_group,
        SUM(CASE WHEN t5.echo_time IS NULL THEN 1 ELSE 0 END) AS no_echo_group
    FROM t5
)
SELECT 
    t5.*, 
    t6.*, 
    t7.*,
    CASE WHEN t5.echo_time IS NOT NULL THEN 1 ELSE 0 END AS "group"
FROM t5
LEFT JOIN t6 USING (icustay_id)
CROSS JOIN t7;