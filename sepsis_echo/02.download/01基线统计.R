

#加载作图的包
library(tableone)
#所有的数据存在表格finaldata里面
#字段加上标签
label(finaldata$icd_chf)<-"CHF"
label(finaldata$icd_afib)<-"AFIB"
label(finaldata$icd_renal)<-"Renal"
label(finaldata$icd_liver)<-"Liver"
label(finaldata$icd_copd)<-"COPD"
label(finaldata$icd_cad)<-"CAD"
label(finaldata$icd_stroke)<-"Stroke"
label(finaldata$icd_malignancy)<-"Malignancy"
label(finaldata$saps)<-"SAPS score"
label(finaldata$sofa)<-"SOFA score"
label(finaldata$elix_score)<-"Elixhauser score"
label(finaldata$vent)<-"Mechanical ventilation use (1st 24h)"
label(finaldata$vaso)<-"Vasoperessor use (1st 24h)"
label(finaldata$sedative)<-"Sedative use (1st 24h)"
label(finaldata$vs_map_first)<-"MAP"
label(finaldata$vs_heart_rate_first)<-"Heart rate"
label(finaldata$vs_temp_first)<-"Temperature"
label(finaldata$vs_cvp_first)<-"CVP"
label(finaldata$lab_wbc_first)<-"WBC"
label(finaldata$lab_hemoglobin_first)<-"Hemoglobin"
label(finaldata$lab_platelet_first)<-"Platelet"
label(finaldata$lab_sodium_first)<-"Sodium"
label(finaldata$lab_potassium_first)<-"Potassium"
label(finaldata$lab_bicarbonate_first)<-"Bicarbonate"
label(finaldata$lab_chloride_first)<-"Chloride"
label(finaldata$lab_bun_first)<-"BUN"
label(finaldata$lab_lactate_first)<-"Lactate"
label(finaldata$lab_creatinine_first)<-"Creatinine"
label(finaldata$lab_ph_first)<-"PH"
label(finaldata$lab_po2_first)<-"PO2"
label(finaldata$lab_pco2_first)<-"PCO2"
label(finaldata$lab_bnp_flag)<-"BNP(tested)"
label(finaldata$lab_troponin_flag)<-"Troponin(tested)"
label(finaldata$lab_creatinine_kinase_flag)<-"Creatinine kinase(tested)"
label(finaldata$icu_adm_weekday)<-"Day of lCU admission"
#定义作图需要的变量
vars<-c("age","gender","weight","saps","sofa","elix_score","vent","vaso","sedative","icd_chf","icd_afib",
    "icd_renal","icd_liver","icd_copd","icd_cad","icd_stroke","icd_malignancy"
        ,"vs_map_first","vs_heart_rate_first","vs_temp_first","vs_cvp_first",
        "lab_wbc_first","lab_hemoglobin_first","lab_platelet_first","lab_sodium_first","lab_potassium_first",
    "lab_bicarbonate_first","lab_bun_first","lab_lactate_first","lab_creatinine_first","lab_ph_first","lab_po2_first",
        "lab_pco2_first","lab_bnp_flag","lab_troponin_flag","lab_creatinine_kinase_flag","icu_adm_weekday")、
#分类变量
catVar<-c("vent","vaso","sedative","icd_chf","icd_afib","icd_renal","icd_liver","icd_copd",
      "icd_cad","icd_stroke","icd_malignancy",
          "lab_bnp_flag","lab_troponin_flag","lab_creatinine_kinase_flag","icu_adm_weekday")
#连续变量
nonormalVar<-c('age','gender','weight','saps','sofa','elix_score','vs_map_first','vs_heart_rate_first',
        'vs_temp_first','vs_cvp_first','lab_wbc_first','lab_hemoglobin_first','lab_platelet_first',
        'lab_sodium_first','lab_potassium_first','lab_bicarbonate_first','lab_bun_first','lab_lactate_first',
        'lab_creatinine_first','lab_ph_first','lab_po2_first','lab_pco2_first')
#制作Table1
tab1<-CreateTableOne(vars=vars,strata = "echo",data=finaldata,factorVars = catVar)
print(tab1,smd = TRUE,varLabels = TRUE,showAllLevels = TRUE,test = FALSE)