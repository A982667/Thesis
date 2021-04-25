#################################################
##Amy McNamara
##CCSU Special Project
##MS Data SCience
##2020
################################################

################################################
#Recursive Feature Elimination Using SVM
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


#############################
#set working directory
#############################

setwd("H:/CCSU/Thesis")

#############################
##load workspace from Model Preparation.R
#############################

load(file = "1a - Final Code/Fixed Code/Workspaces/Modeling-Ready Workspace.RData")
dim(df2.Train.pred)
# 46290   165



#############################
#define rfeControl 
#############################

svmFuncs <- caretFuncs

svmFuncs$summary <- fiveStats

ctrl <- rfeControl(functions = svmFuncs,
                   rerank=TRUE,
                   method = "boot",
                   saveDetails=TRUE,
                   number=100,
                   verbose = TRUE,
                   returnResamp="all",
                   index=resamples.3,
                   seeds=seeds.rerank.4,
                   allowParallel=TRUE)


#############################
##SVM requires one hot encoding of categorical variables
#############################
#Dumify training data set
dmy <- dummyVars(" ~ .", data = df2.Train.pred, fullRank = T,sep="_")
df2.Train.pred.dmy <- data.frame(predict(dmy, newdata = df2.Train.pred))
print(df2.Train.pred.dmy) 
dim(df2.Train.pred.dmy)
# [1] 46290   887

#Dumify test data set
dmy <- dummyVars(" ~ .", data = df2.Test.pred, fullRank = T,sep="_")
df2.Test.pred.dmy <- data.frame(predict(dmy, newdata = df2.Test.pred))
print(df2.Test.pred.dmy) 
dim(df2.Test.pred.dmy)
# [1] 11572   887


##For graph to include all variables from SVM
sizes.4<-c(2:30, 55, 110, 225, 450, 887) #34 subsets

##############################
##start clusters
##############################
cl <- makeCluster(4) 
registerDoParallel(cl)
# > cl
# socket cluster with 4 nodes on host 'localhost'

##############################
##Run SVM-RFE
##Capture time to run
##############################
set.seed(1000)
system.time(svmRFE <- rfe(x = df2.Train.pred.dmy,
              y = df2.Train.target,
              sizes = sizes.4,
              metric = "ROC",
              rfeControl = ctrl,
              saveDetails=TRUE,
              returnResamp=TRUE,
              ## Now options to train()
              method = "svmLinear",
              #tuneLength = 12,
              #preProc = c("center", "scale"),
              ## Below specifies the inner resampling process
              trControl = trainControl(method = "none",
                                       savePredictions = TRUE,
                                       classProbs = TRUE,
                                       selectionFunction="best",
                                       summaryFunction = fiveStats,
                                       allowParallel = FALSE)
                                           #verboseIter = FALSE,
                                           #)
            ))


# user  system elapsed 
# 893.05   47.00 6457.04 

################################################
##look at results of SVM-RFE
################################################

##############################
##save results as file
##############################
sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_summary.txt")
summary(svmRFE)
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_svmRFE.txt")
svmRFE
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_pred.txt")
svmRFE$pred
sink()


sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_variables.txt")
svmRFE$variables
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_results.txt")
svmRFE$results
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_bestsubset.txt")
svmRFE$bestSubset
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_fit.txt")
svmRFE$fit
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_optVariables.txt")
svmRFE$optVariables
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_optsize.txt")
svmRFE$optsize
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_call.txt")
svmRFE$call
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_control.txt")
svmRFE$control
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_resample.txt")
svmRFE$resample
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_metric.txt")
svmRFE$metric
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_maximize.txt")
svmRFE$maximize
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_perfNames.txt")
svmRFE$perfNames
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_times.txt")
svmRFE$times
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_resampledCM.txt")
svmRFE$resampledCM
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_obsLevels.txt")
svmRFE$obsLevels
sink()

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_dots.txt")
svmRFE$dots
sink()

###########################
##variable importance
###########################
svm_rfe.importance <- varImp(svmRFE, scale=FALSE, useModel=TRUE)
write.csv(svm_rfe.importance,"1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/importance.csv")

svmRFE$optVariables

# [1] "acc_COUNTY_bin_med_low_rural_fatal"                  
# [2] "acc_COUNTY_bin_high_rural_fatal"                     
# [3] "veh_VNUM_LAN_nm_2_Two_Lanes"                         
# [4] "acc_ROUTE_nm_Local_Street_Municipality"              
# [5] "veh_ROLLOVER_nm_1_Rollover_Tripped_by_Object.Vehicle"
# [6] "acc_LGT_COND_nm_Daylight"                            
# [7] "veh_SPEEDREL_nm_9_Unknown"                           
# [8] "acc_ROUTE_nm_County_Road"                            
# [9] "veh_VSPD_LIM_55"                                     
# [10] "acc_aux_A_ROLL_nm_Rollover_Involved_Crash"           
# [11] "veh_VTRAFWAY_nm_1_Two.Way_Not_Divided"               
# [12] "acc_COUNTY_bin_med_high_rural_fatal"                 
# [13] "acc_aux_A_RD_nm_Yes_._Roadway_Departure"             
# [14] "veh_MAK_MOD_bin_high_rural_fatal"

###########################
##plot metrics
###########################
#plot metrics against number of variables in subset
plot_metrics<-ggplot(svmRFE$results, aes(x=rep(c(1:34)))) + 
  geom_line(aes(y=Accuracy, color="Accuracy")) +
  geom_line(aes(y=ROC, color="AUC")) +
  geom_line(aes(y=Sens, color="Sensitivity")) +
  geom_line(aes(y=Spec, color="Specificity")) +
  geom_point(aes(y=Accuracy, color="Accuracy")) +
  geom_point(aes(y=ROC, color="AUC")) +
  geom_point(aes(y=Sens, color="Sensitivity")) +
  geom_point(aes(y=Spec, color="Specificity")) +
  scale_x_continuous(breaks=c(1:34),
                     labels=sizes.4) +
  xlab("Subset Sizes") +
  ylab("Mean OOB Performance") + 
  theme(legend.title=element_blank())+
  theme(legend.position="bottom") +
  theme(legend.text=element_text(size=10)) +
  theme(axis.text.y=element_text(size=12, vjust=0)) + #change from 12 to 14 and bold and verticle adjust to line up with line
  theme(axis.text.x=element_text(size=12,angle=90, hjust=1)) #added to specify font size, bold, angle the axis lable and horiztonal justify to center of line

ggsave(filename = file.path("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2","plot_metrics.png"))




##############################
##Strip Chart
##AUC vs # of Variables
##############################

x<-svmRFE$resample
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
whichTwoPct <- tolerance(svmRFE$results, metric = "ROC", 
                         tol = 2, maximize = TRUE) 
whichTwoPct
# [1] 8

## best model within 2 pct of best:
svmRFE$results[whichTwoPct,]
# Variables       ROC      Sens      Spec  Accuracy     Kappa      ROCSD     SensSD    SpecSD AccuracySD   KappaSD
# 8         9 0.7944135 0.8568092 0.5128952 0.6917499 0.3738404 0.04926307 0.04837918 0.1396726 0.05797706 0.1209935

write.csv(svmRFE$results[whichTwoPct,],"1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/bst_model_w_2pct_tol.csv")

##############################
##predict on test data set
##############################
svm_rfe.predict<-predict(svmRFE, df2.Test.pred.dmy)
svm_rfe_pred<-svm_rfe.predict$pred
confMtrx<-confusionMatrix(data = svm_rfe_pred, reference = df2.Test.target, positive="Rural")
table(df2.Test.target)
# Confusion Matrix and Statistics

# Reference
# Prediction Rural Urban
# Rural  4530   587
# Urban  1491  4964
# 
# Accuracy : 0.8204          
# 95% CI : (0.8133, 0.8274)
# No Information Rate : 0.5203          
# P-Value [Acc > NIR] : < 2.2e-16       
# 
# Kappa : 0.6425          
# 
# Mcnemar's Test P-Value : < 2.2e-16       
#                                           
#             Sensitivity : 0.7524          
#             Specificity : 0.8943          
#          Pos Pred Value : 0.8853          
#          Neg Pred Value : 0.7690          
#              Prevalence : 0.5203          
#          Detection Rate : 0.3915          
#    Detection Prevalence : 0.4422          
#       Balanced Accuracy : 0.8233          
#                                           
#        'Positive' Class : Rural

sink("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53_confMtrx.txt")
confMtrx
sink()




roc_svm_rfe <- roc(predictor = svm_rfe.predict$Rural, response = df2.Test.target,levels=c("Urban", "Rural"))
# Call:
#   roc.default(response = df2.Test.target, predictor = svm_rfe.predict$Rural,     levels = c("Urban", "Rural"))
# 
# Data: svm_rfe.predict$Rural in 5551 controls (df2.Test.target Urban) < 6021 cases (df2.Test.target Rural).
# Area under the curve: 0.9169


auc_plot<-plot(roc_svm_rfe, col="blue", lwd=3, main="ROC Curve SVM-RFE", legacy.axes=TRUE)

auc(roc_svm_rfe)
#Area under the curve: 0.9169


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
auc<-as.numeric(auc(roc_svm_rfe))

#populate data frame
metrics_test<-data.frame(pos_class, TN, TP, FN, FP, N, TAP, TAN, pct_P, accuracy, sensitivity,
                         specificity, auc)
# pos_class   TN   TP   FN  FP     N  TAP  TAN     pct_P  accuracy sensitivity specificity      auc
# 1     Rural 4964 4530 1491 587 11572 6021 5551 0.5203076 0.8204286   0.7523667   0.8942533 0.916902

##############################
##save SVM-RFE workspace
##############################
#save.image("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/svm_rfe_100_bootstrap_53.RData")


###workspace

#look at results
#see SVMRFE Results.xlsx
# svmRFE
# svmRFE$pred
# svmRFE$variables
# svmRFE$results
# svmRFE$bestSubset
# svmRFE$fit
# svmRFE$optVariables
# svmRFE$optsize
# svmRFE$call
# svmRFE$control
# svmRFE$resample
# svmRFE$metric
# svmRFE$maximize
# svmRFE$perfNames
# svmRFE$times
# svmRFE$resampledCM
# svmRFE$obsLevels
# svmRFE$dots

##############################
##turn off cluster
##############################
stopCluster(cl)

##############################
##look at results of SVM-RFE
##############################

# plot(svmRFE, type=c("g", "o"))
# densityplot(svmRFE, 
#             subset = Variables < 15, 
#             adjust = 1.25, 
#             as.table = TRUE, 
#             xlab = "RMSE CV Estimates", 
#             pch = "|")



##variable importance
svm_rfe.importance <- varImp(svmRFE, scale=FALSE)
print(svm_rfe.importance)


##############################
##predict on test data set
##############################
svmrfe.predict<-predict(svmRFE, df2.Test.pred.dmy)
svmrfe_pred<-svmrfe.predict$pred
confusionMatrix(data= svmrfe_pred, reference=df2.Test.target )

# Confusion Matrix and Statistics

# Reference
# Prediction Rural Urban
# Rural  4530   587
# Urban  1491  4964
# 
# Accuracy : 0.8204          
# 95% CI : (0.8133, 0.8274)
# No Information Rate : 0.5203          
# P-Value [Acc > NIR] : < 2.2e-16       
# 
# Kappa : 0.6425          
# 
# Mcnemar's Test P-Value : < 2.2e-16       
#                                           
#             Sensitivity : 0.7524          
#             Specificity : 0.8943          
#          Pos Pred Value : 0.8853          
#          Neg Pred Value : 0.7690          
#              Prevalence : 0.5203          
#          Detection Rate : 0.3915          
#    Detection Prevalence : 0.4422          
#       Balanced Accuracy : 0.8233          
#                                           
#        'Positive' Class : Rural


roc_svm_rfe <- roc(response = df2.Test.target, predictor = svmrfe.predict$Rural)
# Call:
#   roc.default(response = df2.Test.target, predictor = svmrfe.predict$Rural)
# 
# Data: svmrfe.predict$Rural in 6021 controls (df2.Test.target Rural) > 5551 cases (df2.Test.target Urban).
# Area under the curve: 0.9169

plot(roc_svm_rfe, col="red", lwd=3, main="ROC Curve SVM-RFE")
auc(roc_svm_rfe)
# Area under the curve: 0.9169


##############################
##save SVM-RFE workspace
##############################
save.image("1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM-RFE Workspace.RData")

#load(file="1a - Final Code/Fixed Code/Modeling/SVM-RFE/100 bootstrap 53 subsets no acc_CITY_bin_MAKE_or_MODEL_v2/SVM-RFE Workspace.RData")




