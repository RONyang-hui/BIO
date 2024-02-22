# 用sql语言生成挑选出mimiciv数据库中查询心肌梗死的icd_code '412','I252','I214'的病人       
SELECT *
FROM patients
WHERE icd_code IN ('412', 'I252', 'I214');

