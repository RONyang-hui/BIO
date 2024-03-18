-- MIMIC-IV数据库获取特定患者的实验室指标

--患者纳排标准
-- 1，提取心肌梗死患者数据
-- 2.患者年龄在18-60岁之间
-- 3.排除肝脏功能有问题的患者


-- 获取icd_code编码可以从这两张表中获取diagnoses_icd,d_icd_diagnoses
-- 但是无法判断具体是哪一个icd_code，所以可以从整理的汇总表中获取
-- 1，从汇总表查询心肌梗死的icd_code '412'，'I252','I214'


SELECT d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title, COUNT(diagnoses_icd.icd_code) AS code_count
-- 从d_icd_diagnoses_count表中选择icd_code, icd_version, long_title以及满足条件的诊断总数
FROM mimiciv_derived.d_icd_diagnoses_count AS d_icd_diagnoses
-- 将d_icd_diagnoses_count表与diagnoses_icd表进行连接
INNER JOIN mimiciv_hosp.diagnoses_icd
ON d_icd_diagnoses.icd_code = diagnoses_icd.icd_code
-- 按icd_code, icd_version, long_title进行分组
GROUP BY d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title
-- 按诊断总数倒序排序
ORDER BY code_count DESC
LIMIT 10;


SELECT d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title, COUNT(diagnoses_icd.icd_code) AS code_count
-- 从d_icd_diagnoses_count表中选择icd_code, icd_version, long_title以及满足条件的诊断总数
FROM mimiciv_derived.d_icd_diagnoses_count AS d_icd_diagnoses
-- 将d_icd_diagnoses_count表与diagnoses_icd表进行连接
INNER JOIN mimiciv_hosp.diagnoses_icd
ON d_icd_diagnoses.icd_code = diagnoses_icd.icd_code
-- 过滤出long_title包含'myocardial infarction'的记录
WHERE d_icd_diagnoses.long_title ILIKE '%rheumatoid arthritis%'
-- 按icd_code, icd_version, long_title进行分组
GROUP BY d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title
-- 按诊断总数倒序排序
ORDER BY code_count DESC;




select * from mimiciv_derived.d_icd_diagnoses_count
    where long_title ilike '%rheumatoid arthritis%' limit 10;


-- 2, 查询18-60岁之间的患者
select age.hadm_id,age.age from mimiciv_derived.age as age 
    where age.age﹥=18 and age.age﹤=60 limit 100;

-- 3，查询患者的首次入ICU记录
select icud.stay_id,icud.hadm_id from mimiciv_derived.icustay_detail as icud
    where icud.first_icu_stay = True limit 100;

-- 从汇总表查询肝功能有问题的患者icd_code '5715','5712'
SELECT d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title, COUNT(diagnoses_icd.icd_code) AS code_count
-- 从d_icd_diagnoses_count表中选择icd_code, icd_version, long_title以及满足条件的诊断总数
FROM mimiciv_derived.d_icd_diagnoses_count AS d_icd_diagnoses
-- 将d_icd_diagnoses_count表与diagnoses_icd表进行连接
INNER JOIN mimiciv_hosp.diagnoses_icd
ON d_icd_diagnoses.icd_code = diagnoses_icd.icd_code
-- 过滤出long_title包含'myocardial infarction'的记录
WHERE d_icd_diagnoses.long_title ILIKE '%Cirrhosis of liver%'
-- 按icd_code, icd_version, long_title进行分组
GROUP BY d_icd_diagnoses.icd_code, d_icd_diagnoses.icd_version, d_icd_diagnoses.long_title
-- 按诊断总数倒序排序
ORDER BY code_count DESC;




SELECT DISTINCT (ICUD.hadm_id) AS HADM_ID
FROM mimiciv_derived.age as age,
     mimiciv_derived.icustay_detail as ICUD,
     mimiciv_hosp.diagnoses_icd as dia
     where dia.hadm_id = age.hadm_id and age.hadm_id = icud.hadm_id
     -- 查询患有心肌梗死的患者
     and dia.icd_code in ('7140','M069','M0600')

    -- 筛查年龄患者
     and age.age >= 18 and age.age <= 60
    -- 只获取患者的首次入院记录
    and icud.first_icu_stay = True
    limit 100;



SELECT 
    d_labitems.itemid, 
    d_labitems.label, 
    d_labitems.fluid, 
    COUNT(labevents.itemid) AS labcode_count
FROM 
    mimiciv_hosp.labevents AS labevents
INNER JOIN 
    mimiciv_hosp.d_labitems AS d_labitems
ON 
    d_labitems.itemid = labevents.itemid
WHERE d_labitems.label ILIKE '%neutrophil%'
GROUP BY 
    d_labitems.itemid, 
    d_labitems.label, 
    d_labitems.fluid
ORDER BY 
    labcode_count DESC
LIMIT 10;


with neutrophil as (
    select
        lab.hadm_id,
        MAX(lab.valuenum) AS num,
        MAX(lab.valueuom) AS uom
    from
        mimiciv_hosp.labevents as lab
    where
        lab.hadm_id in (
            select distinct(icud.hadm_id) 
            from mimiciv_derived.age as age
            join mimiciv_derived.icustay_detail as icud on age.hadm_id = icud.hadm_id
            join mimiciv_hosp.diagnoses_icd as dia on dia.hadm_id = age.hadm_id
            where dia.icd_code in ('412', 'I252', 'I214') 
                and dia.icd_code not in ('5717', '5712') 
                and age.age >= 18 and age.age <= 60 
                and icud.first_icu_stay = True
        )
        and itemid = 51256
    group by lab.hadm_id
    limit 100
)
select * from neutrophil;  -- Example: Selecting data from the "neutrophil" CTE



with lymphocytes as (
    select
        lab.hadm_id,
        MAX(lab.valuenum) AS num,
        MAX(lab.valueuom) AS uom
    from
        mimiciv_hosp.labevents as lab
    where
        lab.hadm_id in (
            select distinct(icud.hadm_id) 
            from mimiciv_derived.age as age
            join mimiciv_derived.icustay_detail as icud on age.hadm_id = icud.hadm_id
            join mimiciv_hosp.diagnoses_icd as dia on dia.hadm_id = age.hadm_id
            where dia.icd_code in ('7140','M069','M0600') 
                and age.age >= 18 and age.age <= 60 
        )
        and itemid = 51244
    group by lab.hadm_id
)
select * from lymphocytes;  -- Example: Selecting data from the "lymphocytes" CTE


-- 定义一个名为neutrophil的公共表表达式(CTE)，用于计算每次住院的最大中性粒细胞计数及其计数单位
with neutrophil as (
    select
        lab.hadm_id,
        MAX(lab.valuenum) AS neutrophil_num, -- 计算最大中性粒细胞计数
        MAX(lab.valueuom) AS neutrophil_uom -- 获取中性粒细胞计数的计数单位
    from
        mimiciv_hosp.labevents as lab
    where
        lab.hadm_id in (
            -- 子查询，根据特定条件筛选住院记录
            select distinct(icud.hadm_id) 
            from mimiciv_derived.age as age
            join mimiciv_derived.icustay_detail as icud on age.hadm_id = icud.hadm_id
            join mimiciv_hosp.diagnoses_icd as dia on dia.hadm_id = age.hadm_id
            where dia.icd_code in ('412', 'I252', 'I214') 
                and dia.icd_code not in ('5717', '5712') 
                and age.age >= 18 and age.age <= 60 
                and icud.first_icu_stay = True
        )
        and itemid = 51256 -- 筛选中性粒细胞计数的实验室事件
    group by lab.hadm_id
    limit 100 -- 限制结果数量以提高性能
),
-- 定义另一个公共表表达式(CTE)，用于计算每次住院的最大淋巴细胞计数及其计数单位
lymphocytes as (
    select
        lab.hadm_id,
        MAX(lab.valuenum) AS lymphocyte_num, -- 计算最大淋巴细胞计数
        MAX(lab.valueuom) AS lymphocyte_uom -- 获取淋巴细胞计数的计数单位
    from
        mimiciv_hosp.labevents as lab
    where
        lab.hadm_id in (
            -- 子查询，根据特定条件筛选住院记录
            select distinct(icud.hadm_id) 
            from mimiciv_derived.age as age
            join mimiciv_derived.icustay_detail as icud on age.hadm_id = icud.hadm_id
            join mimiciv_hosp.diagnoses_icd as dia on dia.hadm_id = age.hadm_id
            where dia.icd_code in ('412', 'I252', 'I214') 
                and dia.icd_code not in ('5717', '5712') 
                and age.age >= 18 and age.age <= 60 
                and icud.first_icu_stay = True
        )
        and itemid = 51244 -- 筛选淋巴细胞计数的实验室事件
    group by lab.hadm_id
    limit 100 -- 限制结果数量以提高性能
)
-- 查询，选择住院ID、中性粒细胞计数、中性粒细胞计数单位、淋巴细胞计数和淋巴细胞计数单位
select n.hadm_id, n.neutrophil_num, n.neutrophil_uom, l.lymphocyte_num, l.lymphocyte_uom
from neutrophil n
left join lymphocytes l on n.hadm_id = l.hadm_id;






SELECT CBC.*, ICUD.*
FROM mimiciv_derived.complete_blood_count AS CBC
LEFT JOIN (
    SELECT DISTINCT ICUD.hadm_id AS HADM_ID
    FROM mimiciv_derived.age AS age,
         mimiciv_derived.icustay_detail AS ICUD,
         mimiciv_hosp.diagnoses_icd AS dia
    WHERE dia.hadm_id = age.hadm_id
      AND age.hadm_id = icud.hadm_id
      AND dia.icd_code IN ('7140', 'M069', 'M0600')
      AND age.age >= 18 AND age.age <= 70
) AS Subquery
ON CBC.hadm_id = Subquery.HADM_ID
LEFT JOIN mimiciv_derived.icustay_detail AS ICUD
ON CBC.hadm_id = ICUD.hadm_id