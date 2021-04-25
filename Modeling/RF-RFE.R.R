#################################################
##Amy McNamara
##CCSU Special Project
##MS Data SCience
##2020
################################################

################################################
#Recursive Feature Elimination Using Random Forest
##100 bootstrap samples with 50 subset sizes
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
#setwd("C:/Users/atata/Documents/CCSU/Thesis")

setwd("H:/CCSU/Thesis")

#############################
##load workspace from Model Preparation.R
#############################

load(file = "1a - Final Code/Fixed Code/Workspaces/Modeling-Ready Workspace.RData")
dim(df2.Train.pred)
# 46290   165


#############################
#create object that references the caret package rfFuncs
##this sets the default helper functions for Random Forests including
#fit, pred, summary, rank selectSize and selectVar.
#############################
newRF <- rfFuncs

#############################
##customize the summary helper function
#############################
newRF$summary <- fiveStats

#############################
##define the RFE controls
#############################
ctrl <- rfeControl(functions = newRF,
                   rerank=TRUE,
                   method = "boot",
                   saveDetails=TRUE,
                   number=100,
                   verbose=TRUE, 
                   returnResamp="all",
                   index=resamples.3, 
                   seeds=seeds.rerank.5, 
                   allowParallel=TRUE)

##############################
##start clusters
##############################
cl <- makeCluster(4) 
registerDoParallel(cl)
# > cl
# socket cluster with 4 nodes on host 'localhost'

##############################
##Run RF-RFE
##Capture time to run
##############################


set.seed(100)
system.time(rfRFE_savedetails<-rfe(x=df2.Train.pred
                                   , y=df2.Train.target
                                   , sizes=sizes.5 #33 subsets
                                   , metric="ROC"
                                   , rfeControl = ctrl
                                   , ntree=1000 
))

# user   system  elapsed 
# 1965.61    58.78 10952.38 


##############################
##turn off cluster
##############################
stopCluster(cl)

################################################
##look at results of RF-RFE
################################################

##############################
##save results as file
##############################
sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_summary.txt")
summary(rfRFE_savedetails)
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_details.txt")
rfRFE_savedetails
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_pred.txt")
rfRFE_savedetails$pred
sink()


sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_variables.txt")
rfRFE_savedetails$variables
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_results.txt")
rfRFE_savedetails$results
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_bestsubset.txt")
rfRFE_savedetails$bestSubset
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_fit.txt")
rfRFE_savedetails$fit
sink()


sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_optVariables.txt")
rfRFE_savedetails$optVariables
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_optsize.txt")
rfRFE_savedetails$optsize
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_call.txt")
rfRFE_savedetails$call
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_control.txt")
rfRFE_savedetails$control
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_resample.txt")
rfRFE_savedetails$resample
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_metric.txt")
rfRFE_savedetails$metric
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_maximize.txt")
rfRFE_savedetails$maximize
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_perfNames.txt")
rfRFE_savedetails$perfNames
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_times.txt")
rfRFE_savedetails$times
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_resampledCM.txt")
rfRFE_savedetails$resampledCM
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_obsLevels.txt")
rfRFE_savedetails$obsLevels
sink()

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_dots.txt")
rfRFE_savedetails$dots
sink()

###########################
##variable importance
###########################
rf_rfe.importance <- varImp(rfRFE_savedetails, scale=FALSE)
write.csv(rf_rfe.importance,"1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/importance.csv")


###########################
##plot metrics
###########################
#plot metrics against number of variables in subset
plot_metrics<-ggplot(rfRFE_savedetails$results, aes(x=rep(c(1:33)))) + 
  geom_line(aes(y=Accuracy, color="Accuracy")) +
  geom_line(aes(y=ROC, color="AUC")) +
  geom_line(aes(y=Sens, color="Sensitivity")) +
  geom_line(aes(y=Spec, color="Specificity")) +
  geom_point(aes(y=Accuracy, color="Accuracy")) +
  geom_point(aes(y=ROC, color="AUC")) +
  geom_point(aes(y=Sens, color="Sensitivity")) +
  geom_point(aes(y=Spec, color="Specificity")) +
  scale_x_continuous(breaks=c(1:33),
                     labels=sizes.5) +
  xlab("Subset Sizes") +
  ylab("Mean OOB Performance") +
  theme(legend.title=element_blank())+
  theme(legend.position="bottom") +
  theme(legend.text=element_text(size=10)) +
  theme(axis.text.y=element_text(size=12, vjust=0)) + #change from 12 to 14 and bold and verticle adjust to line up with line
  theme(axis.text.x=element_text(size=12,angle=90, hjust=1)) #added to specify font size, bold, angle the axis lable and horiztonal justify to center of line

ggsave(filename = file.path("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2","plot_metrics_v2.png")) #save as 2nd version



##############################
##Strip Chart
##AUC vs # of Variables
##############################

x<-rfRFE_savedetails$resample
x$Variables<-as.factor(x$Variables)
x$ROC

strip_plot<-stripplot(x$Variables~x$ROC,
                      main="Strip Plot of AUC by Subset Size",
                      xlab="AUC",
                      ylab="Variable Subset Size",
                      col="blue",
                      grid = "h",
                      pch=20)

pdf("strip_plot.pdf")
plot(strip_plot)
dev.off()



############################
#top variables based on tolerance of 2%
############################
whichTwoPct <- tolerance(rfRFE_savedetails$results, metric = "ROC", 
                         tol = 2, maximize = TRUE) 

#[1] 9

## best model within 2 pct of best:
rfRFE_savedetails$results[whichTwoPct,]
#   Variables       ROC      Sens      Spec  Accuracy     Kappa      ROCSD    SensSD     SpecSD
# 9        10 0.8072119 0.6028394 0.8436294 0.7184019 0.4419411 0.02299432 0.0686132 0.03603039
# AccuracySD    KappaSD
# 9 0.02742769 0.05282038

write.csv(rfRFE_savedetails$results[whichTwoPct,],"1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/bst_model_w_2pct_tol.csv")

# ############################
# #if use 21 variables as starting point
# #top variables based on tolerance of 3%
# ############################
# 
# results_21<-subset(rfRFE_savedetails$results, Variables<=21)
# 
# whichThreePct <- tolerance(results_21, metric = "ROC", 
#                            tol = 3, maximize = TRUE) 
# #[1] 12
# 
# ## best model within 3 pct of best:
# results_21[whichThreePct,]
# #    Variables       ROC      Sens      Spec  Accuracy     Kappa      ROCSD     SensSD     SpecSD AccuracySD    KappaSD
# # 12        13 0.7531809 0.5367924 0.8042145 0.6651525 0.3371892 0.02641702 0.07246944 0.04050909 0.02570912 0.04880606
# 
# write.csv(results_30[whichThreePct,],"1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/results_21_bst_model_w_3pct_tol.csv")
# 
# ############################
# #if use 21 variables as starting point
# #top variables based on oneSE
# ############################
# whichOneSE <- oneSE(results_21, metric = "ROC", num=100, maximize = TRUE) 
# # [1] 20
# 
# #############################
# #use top 30 varaibles as starting point
# #and apply 2 % tolerance rule
# #############################
# results_30<-subset(rfRFE_savedetails$results, Variables<=30)
# 
# whichTwoPct_top30 <- tolerance(results_30, metric = "ROC", 
#                          tol = 2, maximize = TRUE) 
# whichTwoPct_top30
# [1] 17

#############################
#use top 30 varaibles as starting point
#and apply 3 % tolerance rule
#############################
# whichThreePct_top30 <- tolerance(results_30, metric = "ROC", 
#                                tol = 3, maximize = TRUE) 
# whichThreePct_top30
# [1] 14

############################
#if use top 30 variables as starting point
#top variables based on oneSE
############################
# whichOneSE_30 <- oneSE(results_30, metric = "ROC", num=100, maximize = TRUE) 
# whichOneSE_30
# [[1] 27

##############################
##predict on test data set
##############################
rf_rfe.predict<-predict(rfRFE_savedetails, df2.Test.pred)
rf_rfe_pred<-rf_rfe.predict$pred
confMtrx<-confusionMatrix(data = rf_rfe_pred, reference = df2.Test.target, positive="Rural")
# 
# Confusion Matrix and Statistics

# Reference
# Prediction Rural Urban
# Rural  5067   558
# Urban   954  4993
# 
# Accuracy : 0.8693          
# 95% CI : (0.8631, 0.8754)
# No Information Rate : 0.5203          
# P-Value [Acc > NIR] : < 2.2e-16       
# 
# Kappa : 0.739           
# Mcnemar's Test P-Value : < 2.2e-16       
# 
# Sensitivity : 0.8416          
# Specificity : 0.8995          
# Pos Pred Value : 0.9008          
# Neg Pred Value : 0.8396          
# Prevalence : 0.5203          
# Detection Rate : 0.4379          
# Detection Prevalence : 0.4861          
# Balanced Accuracy : 0.8705          
# 
# 'Positive' Class : Rural

sink("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_confMtrx.txt")
confMtrx
sink()




roc_rf_rfe <- roc(predictor = rf_rfe.predict$Rural, response = df2.Test.target,levels=c("Urban", "Rural"))
# Call:
#   roc.default(response = df2.Test.target, predictor = rf_rfe.predict$Rural,     levels = c("Urban", "Rural"))
# 
# Data: rf_rfe.predict$Rural in 5551 controls (df2.Test.target Urban) < 6021 cases (df2.Test.target Rural).
# Area under the curve: 0.9436


auc_plot<-plot(roc_rf_rfe, col="blue", lwd=3, main="ROC Curve RF-RFE",legacy.axes=TRUE)

auc(roc_rf_rfe)
# Area under the curve: 0.9436


pdf("roc_curve.pdf")
plot(auc_plot)
dev.off()

##############################
##capture test metrics in data frame
##############################

#populate shell data frame
pos_class<-(confMtrx$positive)
TP<-confMtrx$table[1,1]
TN<-confMtrx$table[2,2]
FP<-confMtrx$table[1,2]
FN<-confMtrx$table[2,1]
N<-TP + TN + FP + FN
TAP<-TP + FN
TAN<-TN + FP
pct_P<-TAP/N
accuracy<-confMtrx$overall[['Accuracy']]
sensitivity<-confMtrx$byClass[['Sensitivity']]
specificity<-confMtrx$byClass[['Specificity']]
auc<-as.numeric(auc(roc_rf_rfe))

#populate data frame
metrics_test<-data.frame(pos_class, TN, TP, FN, FP, N, TAP, TAN, pct_P, accuracy, sensitivity,
                   specificity, auc)
# # pos_class   TN   TP  FN  FP     N  TAP  TAN     pct_P  accuracy sensitivity specificity       auc
# 1     Rural 4993 5067 954 558 11572 6021 5551 0.5203076 0.8693398   0.8415546   0.8994776 0.9436066

##############################
##save RF-RFE workspace
##############################
save.image("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin_v2/rf_rfe_100_bootstrap_50_1000_v2.RData")

#load("1a - Final Code/Fixed Code/Modeling/RF-RFE/100 bootstrap 50 subsets 1000 ntree no acc_CITY_bin/rf_rfe_100_bootstrap_50_1000_v2.RData")
