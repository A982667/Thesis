#################################################
##Amy McNamara
##CCSU Special Project
##MS Data SCience
##2020
################################################

################################################
#After SVM-RFE with
##100 bootstrap samples with 53 subset sizes
##Grid Search for hyperparameter optimization
################################################

#############################
#Load Libraries
#############################
library(data.table)
library(e1071)
library(caret)
library(doParallel) 
library(kernlab)
library(pROC)
library(ggplot2)
library(dplyr)
library(rminer)

#############################
#set working directory
#############################
#setwd("C:/Users/atata/Documents/CCSU/Thesis")

setwd("H:/CCSU/Thesis")

#############################
##load workspace from Model Preparation.R
#############################

load(file = "1a - Final Code/Fixed Code/Workspaces/Modeling-Ready Workspace.RData")

load(file="1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM-RFE Workspace.RData")


#take df2.Train and remove unneeded key variable and only retain top 14 variables from SVM-RFE
df2.Train.grid<-select(df2.Train.pred.dmy,c("acc_COUNTY_bin_med_low_rural_fatal"                   
                                            ,"acc_COUNTY_bin_high_rural_fatal"                     
                                            ,"veh_VNUM_LAN_nm_2_Two_Lanes"                          
                                            ,"acc_ROUTE_nm_Local_Street_Municipality"              
                                            ,"veh_ROLLOVER_nm_1_Rollover_Tripped_by_Object.Vehicle" 
                                            ,"acc_LGT_COND_nm_Daylight"                            
                                            ,"veh_SPEEDREL_nm_9_Unknown"                            
                                            ,"acc_ROUTE_nm_County_Road"                            
                                            ,"veh_VSPD_LIM_55"                                      
                                            ,"acc_aux_A_ROLL_nm_Rollover_Involved_Crash"           
                                            ,"veh_VTRAFWAY_nm_1_Two.Way_Not_Divided"                
                                            ,"acc_COUNTY_bin_med_high_rural_fatal"                 
                                            ,"acc_aux_A_RD_nm_Yes_._Roadway_Departure"              
                                            ,"veh_MAK_MOD_bin_high_rural_fatal" 
))




#colnames(df2.Train.grid)

df2.Train.grid.pred<-select(df2.Train.pred.dmy,c("acc_COUNTY_bin_med_low_rural_fatal"                   
                                                 ,"acc_COUNTY_bin_high_rural_fatal"                     
                                                 ,"veh_VNUM_LAN_nm_2_Two_Lanes"                          
                                                 ,"acc_ROUTE_nm_Local_Street_Municipality"              
                                                 ,"veh_ROLLOVER_nm_1_Rollover_Tripped_by_Object.Vehicle" 
                                                 ,"acc_LGT_COND_nm_Daylight"                            
                                                 ,"veh_SPEEDREL_nm_9_Unknown"                            
                                                 ,"acc_ROUTE_nm_County_Road"                            
                                                 ,"veh_VSPD_LIM_55"                                      
                                                 ,"acc_aux_A_ROLL_nm_Rollover_Involved_Crash"           
                                                 ,"veh_VTRAFWAY_nm_1_Two.Way_Not_Divided"                
                                                 ,"acc_COUNTY_bin_med_high_rural_fatal"                 
                                                 ,"acc_aux_A_RD_nm_Yes_._Roadway_Departure"              
                                                 ,"veh_MAK_MOD_bin_high_rural_fatal"
                                                 
))

df2.Train.grid.target<-select(df2.Train,c("acc_aux_A_RU_nm"))


df2.Test.grid.pred<-select(df2.Test.pred.dmy,c("acc_COUNTY_bin_med_low_rural_fatal"                   
                                               ,"acc_COUNTY_bin_high_rural_fatal"                     
                                               ,"veh_VNUM_LAN_nm_2_Two_Lanes"                          
                                               ,"acc_ROUTE_nm_Local_Street_Municipality"              
                                               ,"veh_ROLLOVER_nm_1_Rollover_Tripped_by_Object.Vehicle" 
                                               ,"acc_LGT_COND_nm_Daylight"                            
                                               ,"veh_SPEEDREL_nm_9_Unknown"                            
                                               ,"acc_ROUTE_nm_County_Road"                            
                                               ,"veh_VSPD_LIM_55"                                      
                                               ,"acc_aux_A_ROLL_nm_Rollover_Involved_Crash"           
                                               ,"veh_VTRAFWAY_nm_1_Two.Way_Not_Divided"                
                                               ,"acc_COUNTY_bin_med_high_rural_fatal"                 
                                               ,"acc_aux_A_RD_nm_Yes_._Roadway_Departure"              
                                               ,"veh_MAK_MOD_bin_high_rural_fatal"))

df2.Test.grid.target<-select(df2.Test,c("acc_aux_A_RU_nm"))

df2.Test.grid.target<-as.vector(df2.Test.grid.target)



##############################
##start clusters
##############################
# cl <- makeCluster(4) 
# registerDoParallel(cl)


set.seed(100)
system.time(svm_Grid <- train(x=df2.Train.grid.pred,
                                y=df2.Train.grid.target$acc_aux_A_RU_nm,
                                method = "svmLinear", 
                                metric="ROC", 
                                #tuneLength=7, 
                                tuneGrid = expand.grid(C = c(0.25, 0.5, 1.0, 2.0)),
                                trControl = trainControl(method = "boot",
                                                         number=100,
                                                         savePredictions = TRUE,
                                                         classProbs = TRUE,
                                                         selectionFunction="best",
                                                         summaryFunction = fiveStats,
                                                         allowParallel = FALSE,
                                                         search="grid"
                                )))

# user   system  elapsed 
# 57788.24    66.94 57872.72 
# There were 50 or more warnings (use warnings() to see the first 50)


print(svm_Grid)
# Support Vector Machines with Linear Kernel 
# 
# 46290 samples
# 14 predictor
# 2 classes: 'Rural', 'Urban' 
# 
# No pre-processing
# Resampling: Bootstrapped (100 reps) 
# Summary of sample sizes: 46290, 46290, 46290, 46290, 46290, 46290, ... 
# Resampling results across tuning parameters:
#   
#   C     ROC        Sens       Spec       Accuracy   Kappa    
# 0.25  0.9144118  0.7806523  0.8620819  0.8196982  0.6402171
# 0.50  0.9145048  0.7840708  0.8579241  0.8194755  0.6396633
# 1.00  0.9145202  0.7806532  0.8624276  0.8198538  0.6405485
# 2.00  0.9143388  0.7813176  0.8607837  0.8194496  0.6396686
# 
# ROC was used to select the optimal model using the largest value.
# The final value used for the model was C = 1.

plot(svm_Grid, ylab="Mean OOB AUC")


##############################
##turn off cluster
##############################
# stopCluster(cl)

##############################
##save result files
##############################

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_summary.txt")
summary(svm_Grid)
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_method.txt")
svm_Grid$method
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_modelInfo.txt")
svm_Grid$modelInfo
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_modelType.txt")
svm_Grid$modelType
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_results.txt")
svm_Grid$results
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_pred.txt")
svm_Grid$pred
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_bestTune.txt")
svm_Grid$bestTune
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_call.txt")
svm_Grid$call
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_dots.txt")
svm_Grid$dots
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_metric.txt")
svm_Grid$metric
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_control.txt")
svm_Grid$control
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_finalModel.txt")
svm_Grid$finalModel
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_preProcess.txt")
svm_Grid$preProcess
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_resample.txt")
svm_Grid$resample
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_resampledCM.txt")
svm_Grid$resampledCM
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_perfNames.txt")
svm_Grid$perfNames
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_maximize.txt")
svm_Grid$maximize
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_yLimits.txt")
svm_Grid$yLimits
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_times.txt")
svm_Grid$times
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_Grid_levels.txt")
svm_Grid$levels
sink()

##############
#Plot results
##############
plot(svm_Grid)


###############
#Var Imp
###############

#final model
sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_final_model_varImp.txt")
varImp(svm_Grid, scale=FALSE)
sink()

#############################
##Obtain 95% Confidence Interval for each performance metric 
#Based on trained model and OOB samples
#############################

#save resamples as csv
write.csv(svm_Grid$resample, "1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_final_model_resample.csv")

#AUC
SD.AUC<-sd(svm_Grid$resample$ROC)
# 0.009974828
Mean.AUC<-mean(svm_Grid$resample$ROC)
# 0.7459827
LB.AUC<-Mean.AUC - 1.96*(SD.AUC/sqrt(100))
# 0.7440276
UB.AUC<-Mean.AUC + 1.96*(SD.AUC/sqrt(100))
# 0.7479378

#Sensitivity
SD.Sens<-sd(svm_Grid$resample$Sens)
# 0.00242469
Mean.Sens<-mean(svm_Grid$resample$Sens)
# 0.8867421
LB.Sens<-Mean.Sens - 1.96*(SD.Sens/sqrt(100))
# 0.8862669
UB.Sens<-Mean.Sens + 1.96*(SD.Sens/sqrt(100))
# 0.8872173

#Specificity
SD.Spec<-sd(svm_Grid$resample$Spec)
# 0.003850918
Mean.Spec<-mean(svm_Grid$resample$Spec)
# 0.4826388
LB.Spec<-Mean.Spec - 1.96*(SD.Spec/sqrt(100))
# 0.481884
UB.Spec<-Mean.Spec + 1.96*(SD.Spec/sqrt(100))
# 0.4833936

#Accuracy
SD.Acc<-sd(svm_Grid$resample$Accuracy)
# 0.002933131
Mean.Acc<-mean(svm_Grid$resample$Accuracy)
# 0.6928433
LB.Acc<-Mean.Acc - 1.96*(SD.Acc/sqrt(100))
# 0.6922684
UB.Acc<-Mean.Acc + 1.96*(SD.Acc/sqrt(100))
# 0.6934182

intervals.svm<-data.frame(SD.AUC, Mean.AUC, LB.AUC, UB.AUC,
           SD.Sens, Mean.Sens, LB.Sens, UB.Sens,
           SD.Spec, Mean.Spec, LB.Spec, UB.Spec,
           SD.Acc, Mean.Acc, LB.Acc, UB.Acc)

# SD.AUC  Mean.AUC    LB.AUC    UB.AUC    SD.Sens Mean.Sens   LB.Sens   UB.Sens     SD.Spec Mean.Spec  LB.Spec   UB.Spec      SD.Acc  Mean.Acc
# 1 0.009974828 0.7459827 0.7440276 0.7479378 0.00242469 0.8867421 0.8862669 0.8872173 0.003850918 0.4826388 0.481884 0.4833936 0.002933131 0.6928433
# LB.Acc    UB.Acc
# 1 0.6922684 0.6934182

write.csv(intervals.svm,"1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_final_model_95_CI.txt")

#############################
#Predict on test
#############################
pred.SVM <- predict(svm_Grid$finalModel, 
                    newdata=df2.Test.grid.pred)
#pred.SVM_pred<-SVM_rfe.predict
act.SVM<-df2.Test.grid.target$acc_aux_A_RU_nm
# pred.SVM_pred<-ordered(pred.SVM_pred, levels = c("Rural", "Urban"))
# levels(pred.SVM_pred)



#Confusion Matrix
sink("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_final_model_cont_mtrx.txt")
confusionMatrix(pred.SVM, 
                act.SVM)
sink()

# Confusion Matrix and Statistics

# Reference
# Prediction Rural Urban
# Rural  4979   861
# Urban  1042  4690
# 
# Accuracy : 0.836               
# 95% CI : (0.829, 0.842)      
# No Information Rate : 0.52                
# P-Value [Acc > NIR] : < 0.0000000000000002
# 
# Kappa : 0.671               
# 
# Mcnemar's Test P-Value : 0.0000369           
#                                               
#             Sensitivity : 0.827               
#             Specificity : 0.845               
#          Pos Pred Value : 0.853               
#          Neg Pred Value : 0.818               
#              Prevalence : 0.520               
#          Detection Rate : 0.430               
#    Detection Prevalence : 0.505               
#       Balanced Accuracy : 0.836               
#                                               
#        'Positive' Class : Rural

######
##get AUC and plot
#######
pred.SVM.auc <- predict(svm_Grid$finalModel, 
                        newdata=df2.Test.grid.pred, type="prob")

pred.SVM.auc[,1]
svm.roc<-roc(act.SVM, pred.SVM.auc[,1])
# Call:
#   roc.default(response = act.SVM, predictor = pred.SVM.auc[, 1])
# 
# Data: pred.SVM.auc[, 1] in 6021 controls (act.SVM Rural) > 5551 cases (act.SVM Urban).
# Area under the curve: 0.917

options("scipen"=100, "digits"=4)
auc_plot<-plot(svm.roc, col="blue", lwd=3, main="ROC Curve", legacy.axes=TRUE)

#variable importance plot
# varImpPlot(svm_Grid$finalModel, sort=TRUE, n.var=4, type=2, main="Variable Importance Plot")
#does not work with SVM only RF
# svm_Grid.importance
# plot(svm_Grid.importance)



##############################
##save workspace
##############################
save.image("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_tune.RData")

#load("1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM_tune.RData")



bivariate<-select(df2.Train.pred.dmy,c("acc_COUNTY_bin_med_low_rural_fatal",                   
                                    "acc_COUNTY_bin_high_rural_fatal"                     
                                    ,"veh_VNUM_LAN_nm_2_Two_Lanes"                          
                                    ,"acc_ROUTE_nm_Local_Street_Municipality"              
                                    ,"veh_ROLLOVER_nm_1_Rollover_Tripped_by_Object.Vehicle" 
                                    ,"acc_LGT_COND_nm_Daylight"                            
                                    ,"veh_SPEEDREL_nm_9_Unknown"                            
                                    ,"acc_ROUTE_nm_County_Road"                            
                                    ,"veh_VSPD_LIM_55"                                      
                                    ,"acc_aux_A_ROLL_nm_Rollover_Involved_Crash"           
                                    ,"veh_VTRAFWAY_nm_1_Two.Way_Not_Divided"                
                                    ,"acc_COUNTY_bin_med_high_rural_fatal"                 
                                    ,"acc_aux_A_RD_nm_Yes_._Roadway_Departure"              
                                    ,"veh_MAK_MOD_bin_high_rural_fatal"
))

bivariate<-cbind(bivariate, df2.Train.grid.target$acc_aux_A_RU_nm)

write.csv(bivariate,"1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/bivariate.csv")

other<-select(df2_merge_key_2,c("acc_aux_A_RU_nm","veh_P_CRASH1_nm","acc_RELJCT2_nm"
))

write.csv(other,"1a - Final Code/Fixed Code/Modeling/SVM Grid Search/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/other.csv")

library(greybox)
assoc(bivariate)

# df2.Train.grid.target$acc_aux_A_RU_nm
# acc_COUNTY_bin_med_low_rural_fatal                                                  0.1912
# acc_COUNTY_bin_high_rural_fatal                                                     0.5114
# veh_VNUM_LAN_nm_2_Two_Lanes                                                         0.4030
# acc_ROUTE_nm_Local_Street_Municipality                                              0.3264
# veh_ROLLOVER_nm_1_Rollover_Tripped_by_Object.Vehicle                                0.1157
# acc_LGT_COND_nm_Daylight                                                            0.0807
# veh_SPEEDREL_nm_9_Unknown                                                           0.0147
# acc_ROUTE_nm_County_Road                                                            0.1222
# veh_VSPD_LIM_55                                                                     0.3131
# acc_aux_A_ROLL_nm_Rollover_Involved_Crash                                           0.1659
# veh_VTRAFWAY_nm_1_Two.Way_Not_Divided                                               0.3184
# acc_COUNTY_bin_med_high_rural_fatal                                                 0.1933
# acc_aux_A_RD_nm_Yes_._Roadway_Departure                                             0.1971
# veh_MAK_MOD_bin_high_rural_fatal                                                    0.1817
# df2.Train.grid.target$acc_aux_A_RU_nm                                               1.0000