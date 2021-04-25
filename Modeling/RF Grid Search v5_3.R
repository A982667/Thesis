#################################################
##Amy McNamara
##CCSU Special Project
##MS Data SCience
##2020
################################################

################################################
#After RF-RFE with
##100 bootstrap samples with 50 subset sizes
##Grid Search for hyperparameter optimization
################################################

#############################
#Load Libraries
#############################
library(data.table)
library(e1071)
library(caret)
library(randomForest)
library(foreach)
library(doParallel)
library(pROC)
library(dplyr)

#############################
#set working directory
#############################

setwd("H:/CCSU/Thesis")

#############################
##load workspace from Model Preparation.R
#############################

load(file = "1a - Final Code/Fixed Code/Workspaces/Modeling-Ready Workspace.RData")

load(file="1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_v2.RData")


#take df2.Train and remove unneeded key variable and only retain top 8 variables from RF-RFE optVariables
df2.Train.grid<-select(df2.Train,c("acc_COUNTY_bin","acc_HOUR",
                                   "veh_VSPD_LIM","acc_ROUTE_nm",
                                   "veh_VNUM_LAN_nm","acc_MONTH_nm",
                                   "acc_LGT_COND_nm","veh_ACC_TYP_nm",
                                   "veh_IMPACT1_nm" ,   "acc_DAY_WEEK_nm"))

#colnames(df2.Train.grid)

df2.Train.grid.pred<-select(df2.Train,c("acc_COUNTY_bin","acc_HOUR",
                                        "veh_VSPD_LIM","acc_ROUTE_nm",
                                        "veh_VNUM_LAN_nm","acc_MONTH_nm",
                                        "acc_LGT_COND_nm","veh_ACC_TYP_nm",
                                        "veh_IMPACT1_nm",    "acc_DAY_WEEK_nm"))

df2.Train.grid.target<-select(df2.Train,c("acc_aux_A_RU_nm"))
nrow(df2.Train.grid.target)
# [1] 46290

df2.Test.grid.pred<-select(df2.Test,c("acc_COUNTY_bin","acc_HOUR",
                                      "veh_VSPD_LIM","acc_ROUTE_nm",
                                      "veh_VNUM_LAN_nm","acc_MONTH_nm",
                                      "acc_LGT_COND_nm","veh_ACC_TYP_nm",
                                      "veh_IMPACT1_nm" ,   "acc_DAY_WEEK_nm"))

df2.Test.grid.target<-select(df2.Test,c("acc_aux_A_RU_nm"))

df2.Test.grid.target<-as.vector(df2.Test.grid.target)
nrow(df2.Test.grid.target)
# 11572
ncol(df2.Test.grid.pred)
#10

##############################
##start clusters
##############################
cl <- makeCluster(4) 
registerDoParallel(cl)


control <- trainControl(method="boot", number=100, search="grid", classProbs = TRUE,summaryFunction=fiveStats)
set.seed(100)
system.time(rf_random <- train(x=df2.Train.grid.pred,
                   y=df2.Train.grid.target$acc_aux_A_RU_nm,
                   method="rf", 
                   metric="ROC", 
                   tuneGrid=expand.grid(mtry=c(2, 4, 6, 8)), 
                   trControl=control,
                   ntree=1000))

# user   system  elapsed 
# 164.36     2.19 23962.82 

print(rf_random)

# Random Forest 
# 
# 46290 samples
# 10 predictor
# 2 classes: 'Rural', 'Urban' 
# 
# No pre-processing
# Resampling: Bootstrapped (100 reps) 
# Summary of sample sizes: 46290, 46290, 46290, 46290, 46290, 46290, ... 
# Resampling results across tuning parameters:
#   
#   mtry  ROC        Sens       Spec       Accuracy   Kappa    
# 2     0.9313418  0.8260966  0.8798769  0.8518737  0.7040469
# 4     0.9304746  0.8077501  0.8891984  0.8467943  0.6942497
# 6     0.9287349  0.8092877  0.8855519  0.8458484  0.6922963
# 8     0.9273677  0.8107596  0.8828496  0.8453188  0.6911869
# 
# ROC was used to select the optimal model using the largest value.
# The final value used for the model was mtry = 2.
# 
plot(rf_random, ylab="Mean OOB AUC", cex.axis=2, font=2)


##############################
##turn off cluster
##############################
stopCluster(cl)

##############################
##save result files
##############################

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_summary_v5.txt")
summary(rf_random)
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_method_v5.txt")
rf_random$method
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_modelInfo_v5.txt")
rf_random$modelInfo
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_modelType_v5.txt")
rf_random$modelType
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_results_v5.txt")
rf_random$results
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_pred_v5.txt")
rf_random$pred
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_bestTune_v5.txt")
rf_random$bestTune
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_call_v5.txt")
rf_random$call
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_dots_v5.txt")
rf_random$dots
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_metric_v5.txt")
rf_random$metric
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_control_v5.txt")
rf_random$control
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_finalModel_v5.txt")
rf_random$finalModel
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_preProcess_v5.txt")
rf_random$preProcess
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_resample_v5.txt")
rf_random$resample
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_resampledCM_v5.txt")
rf_random$resampledCM
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_perfNames_v5.txt")
rf_random$perfNames
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_maximize_v5.txt")
rf_random$maximize
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_yLimits_v5.txt")
rf_random$yLimits
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_times_v5.txt")
rf_random$times
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_Grid_levels_v5.txt")
rf_random$levels
sink()

##############
#Plot results
##############
plot(rf_random)


###############
#Var Imp
###############

#final model
sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_final_model_varImp_v5.txt")
varImp(rf_random$finalModel)
sink()



#############################
#Predict on test
#############################
pred.RF <- predict(rf_random$finalModel, 
                  newdata=df2.Test.grid.pred)#, probability = TRUE)

pred.RF_pred<-pred.RF
act.RF<-df2.Test.grid.target$acc_aux_A_RU_nm
# pred.RF_pred<-ordered(pred.RF_pred, levels = c("Rural", "Urban"))
# levels(pred.RF_pred)

#Confusion Matrix
sink("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_final_model_cont_mtrx_v5.txt")
confusionMatrix(pred.RF, 
                act.RF)
sink()

# Confusion Matrix and Statistics
# 
# Reference
# Prediction Rural Urban
# Rural  5063   643
# Urban   958  4908
# 
# Accuracy : 0.8616          
# 95% CI : (0.8552, 0.8679)
# No Information Rate : 0.5203          
# P-Value [Acc > NIR] : < 2.2e-16       
# 
# Kappa : 0.7235          
# Mcnemar's Test P-Value : 4.242e-15       
# 
# Sensitivity : 0.8409          
# Specificity : 0.8842          
# Pos Pred Value : 0.8873          
# Neg Pred Value : 0.8367          
# Prevalence : 0.5203          
# Detection Rate : 0.4375          
# Detection Prevalence : 0.4931          
# Balanced Accuracy : 0.8625          
# 
# 'Positive' Class : Rural 

######
##get AUC and plot
#######
pred.RF.auc <- predict(rf_random$finalModel, 
                   newdata=df2.Test.grid.pred, type="prob")

pred.RF.auc[,1]
rf.roc<-roc(act.RF,pred.RF.auc[,1])
# Call:
#   roc.default(response = act.RF, predictor = pred.RF.auc[, 1])
# 
# Data: pred.RF.auc[, 1] in 6021 controls (act.RF Rural) > 5551 cases (act.RF Urban).
# Area under the curve: 0.936

auc_plot<-plot(rf.roc, col="blue", lwd=3, main="ROC Curve", legacy.axes=TRUE)

#variable importance plot
varImpPlot(rf_random$finalModel, sort=TRUE, type=2, main="Variable Importance Plot")


##############################
##save workspace
##############################
save.image("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_grid_search_v5.RData")

#load("1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_grid_search_v5.RData")

#############################
##save rf file
#############################
saveRDS(rf_random, file="1a - Final Code/Fixed Code/Modeling/RF Grid Search/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_grid_search_v5_v2.rds")