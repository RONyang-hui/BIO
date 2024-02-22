

#载入包
library(Matching)
library(twang)
#匹配变量选择
fml<-'echo_int ~ first_careunit + age + gender + weight + saps + sofa + elix_score + vent + vaso + icu_adm_weekday + icu_adm_hour + icd_chf + icd_afib + icd_renal + icd_liver + icd_copd + icd_cad + icd_stroke + icd_malignancy + vs_temp_first + vs_map_first + vs_heart_rate_first + lab_chloride_first + lab_creatinine_first + lab_platelet_first + lab_potassium_first + lab_po2_first + lab_lactate_first + lab_hemoglobin_first + lab_sodium_first + lab_ph_first + lab_bicarbonate_first + lab_wbc_first + lab_bun_first + lab_pco2_first + sedative + vs_cvp_flag + lab_troponin_flag + lab_creatinine_kinase_flag + lab_bnp_flag'
#计算权重，采用gbm方法
echo_ps_ate<-ps(as.formula(fml),
                data = finaldata,
                interaction.depth = 2,
                shrinkage = 0.01,
                perm.test.iters = 0,
                estimand = "ATE",
                verbose = FALSE,
                stop.method = c("es.mean", "es.max", "ks.mean", "ks.max"),
                n.trees = 10000,
                train.fraction = 0.8,
                cv.folds = 3,
                n.cores = 8,version="legacy")
pred <- echo_ps_ate$ps$es.mean.ATE
finaldata <- finaldata %>% mutate(ps = pred)
finaldata <- finaldata %>% mutate(ps_weight = get.weights(echo_ps_ate, stop.method = "es.mean"))
#匹配子集
set.seed(4958)
ps_matches <- Match(Y = finaldata$mort_28_day, Tr = finaldata$echo_int,
                    X = finaldata$ps, M = 1, estimand = "ATT", caliper = 0.01,
                    exact = FALSE, replace = FALSE, ties = FALSE)