create view step4 as
(
with t1 as
    (
        select icustay_id,
        -- 计算入ICU时间与出生时间差（结果为秒，再除以一年的秒得到的结果）
        extract('epoch' from (intime - dob)) / 60.0 / 60.0 / 24.0 / 365 as age
        from icustays
        left join patients using (subject_id)
        where icustay_id in 
        -- 下面括号内是我们第一步得到的住院号
        (select icustay_id 
        from icustays
        left join mimiciii.martin using (hadm_id)
        where sepsis=1)
    ),
    -- 把第一步和第二部的表格保存为表t2
    t2 as (
        -- 查询临时表里面年龄大于18岁的病人
        select * from t1 where age > 18
    ),
    -- 病人的入ICU顺序保存为t3
    t3 as (
        select icustay_id,
        -- 每个病人按照进icu时间排序
        rank() over (partition by subject_id order by intime) as icu_order
        from icustays
    ),
    t4 as (
        select t2.*, t3.icu_order
        from t2 
        left join t3 using(icustay_id)
        where t3.icu_order=1
    )

    select t4.icustay_id, t4.age, first_careunit
    from t4
    left join icustays using(icustay_id)
    -- 只选择MICU和SICU
    where first_careunit in ('MICU','SICU')
);









