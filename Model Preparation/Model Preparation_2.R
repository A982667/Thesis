#################################################
##Amy McNamara
##CCSU Special Project
##MS Data SCience
##2020
################################################

#remove additional fields as duplicative

################################################
##MODEL PREPARATION
################################################

#############################
#Load libraries
#############################
library(data.table)
library(e1071)
library(caret)
library(randomForest)
library(foreach)
library(dplyr)


#############################
#Set Working Directory
#############################
#setwd("C:/Users/atata/Documents/CCSU/Thesis")

setwd("H:/CCSU/Thesis")

#############################
#load final data set
#############################

df2_merge_key_2<-readRDS("1a - Final Code/Fixed Code/Data/df2_merge_key.rds")
dim(df2_merge_key_2)
# 57862   237


#check levels of target
levels(df2_merge_key_2$acc_aux_A_RU_nm)
# [1] "Rural" "Urban"

#############################
##split data into training and test data sets
#############################

set.seed(123)
trainIndex <- createDataPartition(df2_merge_key_2$acc_aux_A_RU_nm, p = .8, 
                                  list = FALSE, 
                                  times = 1)
head(trainIndex)

df2.Train <- df2_merge_key_2[ trainIndex,]
df2.Test  <- df2_merge_key_2[-trainIndex,]

dim(df2.Train)
# [1] 46290   237

dim(df2.Test)
# [1] 11572   237

#####################
##isolate the predictors in a data frame as required for rfe
#####################
#remove target variable and observation key
df2.Train.pred<-select(df2.Train, -c("acc_aux_A_RU_nm","key")) 
df2.Test.pred<-select(df2.Test, -c("acc_aux_A_RU_nm","key")) 

#####################
#remove fields not needed
df2.Train.pred<-select(df2.Train.pred, -c("veh_L_STATE_nm"
                                     #,"veh_BODY_TYP_nm" # removed after binning but instead using veh_aux_BODY_TYP which is already binned
                                     ,"veh_MAK_MOD"
                                     ,"veh_MODEL"
                                     ,"veh_MAKE_nm"
                                     ,"veh_REG_STAT_nm"
                                     ,"State_County"
                                     ,"acc_aux_STATE_nm"
                                     ,"acc_aux_A_INTER_nm"
                                     ,"acc_aux_A_RELRD_nm"
                                     ,"acc_aux_A_INTSEC_nm"
                                     ,"acc_aux_A_ROADFC_nm"
                                     ,"acc_aux_A_JUNC_nm"
                                     ,"acc_aux_A_MANCOL_nm"
                                     ,"acc_aux_A_TOD_nm"
                                     ,"acc_aux_SPJ_INDIAN_nm"
                                     ,"acc_COUNTY"
                                     ,"acc_CITY"
                                     ,"veh_aux_A_IMP1_nm"
                                     ,"veh_aux_A_VROLL_nm"
                                     ,"veh_aux_A_LIC_C_nm"
                                     ,"veh_aux_A_CDL_S_nm"
                                     ,"veh_aux_A_SPVEH_nm"
                                     ,"veh_aux_A_SBUS_nm"
                                     ,"veh_HARM_EV_nm"
                                     ,"veh_HAZ_INV_nm"
                                     ,"veh_HAZ_PLAC_nm"
                                     ,"veh_HAZ_REL_nm"
                                     ,"veh_ROLINLOC_nm"
                                     ,"per_aux_A_AGE1_nm"
                                     ,"per_aux_A_AGE2_nm"
                                     ,"per_aux_A_AGE4_nm"
                                     ,"per_aux_A_AGE5_nm"
                                     ,"per_aux_A_AGE6_nm"
                                     ,"per_aux_A_AGE7_nm"
                                     ,"per_aux_A_AGE8_nm"
                                     ,"per_aux_A_AGE9_nm"
                                     ,"per_aux_A_RESTUSE_nm"
                                     ,"per_aux_A_HISP_nm"
                                     ,"per_aux_A_RCAT_nm"
                                     ,"per_aux_A_EJECT_nm"
                                     ,"per_PER_TYPE_nm"
                                     ,"per_P_SF2_nm"
                                     ,"per_P_SF3_nm"
                                     ,"state_code"
                                     ,"County.Name"
                                     ,"acc_aux_A_POSBAC_nm"
                                     ,"acc_DAY"
                                     ,"acc_RD_OWNER_nm"
                                     ,"acc_NOT_HOUR"
                                     ,"acc_ARR_HOUR"
                                     ,"acc_HOSP_HR"
                                     ,"veh_FIRST_MO_nm"
                                     ,"veh_LAST_MO_nm"
                                     ,"veh_P_CRASH3_nm"
                                     ,"per_ALC_DET_nm"
                                     ,"per_DEATH_MO_nm"
                                     ,"per_DEATH_YR"
                                     ,"per_DEATH_HR"
                                     ,"veh_TRAV_SP_bin"
                                     ,"veh_DR_HGT_bin"
                                     ,"veh_DR_WGT_bin"
                                     ,"veh_FIRST_YR_bin"
                                     ,"veh_LAST_YR_bin"
                                     ,"acc_aux_A_REGION_nm" #added here down
                                     #,"acc_COUNTY_bin" #left in v3
                                     ,"acc_aux_A_D15_19_nm"
                                     ,"acc_aux_A_D16_19_nm"
                                     ,"acc_aux_A_D16_20_nm"
                                     ,"acc_aux_A_D16_24_nm"
                                     , "per_AGE"
                                     ,"veh_BODY_TYP_nm_bin2"
))

dim(df2.Train.pred)                                   
# 46290   165

df2.Test.pred<-select(df2.Test.pred, -c("veh_L_STATE_nm"
                                     #,"veh_BODY_TYP_nm"
                                     ,"veh_MAK_MOD"
                                     ,"veh_MODEL"
                                     ,"veh_MAKE_nm"
                                     ,"veh_REG_STAT_nm"
                                     ,"State_County"
                                     ,"acc_aux_STATE_nm"
                                     ,"acc_aux_A_INTER_nm"
                                     ,"acc_aux_A_RELRD_nm"
                                     ,"acc_aux_A_INTSEC_nm"
                                     ,"acc_aux_A_ROADFC_nm"
                                     ,"acc_aux_A_JUNC_nm"
                                     ,"acc_aux_A_MANCOL_nm"
                                     ,"acc_aux_A_TOD_nm"
                                     ,"acc_aux_SPJ_INDIAN_nm"
                                     ,"acc_COUNTY"
                                     ,"acc_CITY"
                                     ,"veh_aux_A_IMP1_nm"
                                     ,"veh_aux_A_VROLL_nm"
                                     ,"veh_aux_A_LIC_C_nm"
                                     ,"veh_aux_A_CDL_S_nm"
                                     ,"veh_aux_A_SPVEH_nm"
                                     ,"veh_aux_A_SBUS_nm"
                                     ,"veh_HARM_EV_nm"
                                     ,"veh_HAZ_INV_nm"
                                     ,"veh_HAZ_PLAC_nm"
                                     ,"veh_HAZ_REL_nm"
                                     ,"veh_ROLINLOC_nm"
                                     ,"per_aux_A_AGE1_nm"
                                     ,"per_aux_A_AGE2_nm"
                                     ,"per_aux_A_AGE4_nm"
                                     ,"per_aux_A_AGE5_nm"
                                     ,"per_aux_A_AGE6_nm"
                                     ,"per_aux_A_AGE7_nm"
                                     ,"per_aux_A_AGE8_nm"
                                     ,"per_aux_A_AGE9_nm"
                                     ,"per_aux_A_RESTUSE_nm"
                                     ,"per_aux_A_HISP_nm"
                                     ,"per_aux_A_RCAT_nm"
                                     ,"per_aux_A_EJECT_nm"
                                     ,"per_PER_TYPE_nm"
                                     ,"per_P_SF2_nm"
                                     ,"per_P_SF3_nm"
                                     ,"state_code"
                                     ,"County.Name"
                                     ,"acc_aux_A_POSBAC_nm"
                                     ,"acc_DAY"
                                     ,"acc_RD_OWNER_nm"
                                     ,"acc_NOT_HOUR"
                                     ,"acc_ARR_HOUR"
                                     ,"acc_HOSP_HR"
                                     ,"veh_FIRST_MO_nm"
                                     ,"veh_LAST_MO_nm"
                                     ,"veh_P_CRASH3_nm"
                                     ,"per_ALC_DET_nm"
                                     ,"per_DEATH_MO_nm"
                                     ,"per_DEATH_YR"
                                     ,"per_DEATH_HR"
                                     ,"veh_TRAV_SP_bin"
                                     ,"veh_DR_HGT_bin"
                                     ,"veh_DR_WGT_bin"
                                     ,"veh_FIRST_YR_bin"
                                     ,"veh_LAST_YR_bin","acc_aux_A_REGION_nm" #added here down
                                     #,"acc_COUNTY_bin" #left in v3
                                     ,"acc_aux_A_D15_19_nm"
                                     ,"acc_aux_A_D16_19_nm"
                                     ,"acc_aux_A_D16_20_nm"
                                     ,"acc_aux_A_D16_24_nm"
                                     , "per_AGE"
                                     ,"veh_BODY_TYP_nm_bin2"
))

dim(df2.Test.pred)
# 46290   165

str(df2.Train.pred)
#####################
##isolate target variable as required for rfe
#####################
df2.Train.target<-df2.Train$acc_aux_A_RU_nm
df2.Test.target<-df2.Test$acc_aux_A_RU_nm


#########################
##create bootstrap samples of training data set for use in rfe
#########################

#for testing code, set to 10, change to below later
set.seed(100)
resamples.1 <- createResample(y = df2.Train.pred,
                            times = 10)  #needs to be same as rfeControl() number

#for 100 bootstrap
set.seed(100)
resamples.2<-createResample(y = df2.Train.pred,
                              times = 100)  #needs to be same as rfeControl() number

#for 100 bootstrap
set.seed(100)
resamples.3<-createResample(y = df2.Train.pred,
                            times = 100)  #needs to be same as rfeControl() number

#########################
##set feature subset sizes for rfe
#########################

#include all subset sizes from 2 through square root of number of predictors (191)
#Then try subset sizes of all, and take half repeated until square root reached
#For use with seeds.rerank
sizes.1<- sizes<-c(2:14, 24, 48, 96, 165) #17 subsets

#For use with seeds.rerank.2
sizes.2<-c(2:15,20, 30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180, 165)  #32 subsets

#For use with seeds.rerank.3
sizes.3<-c(2:35,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180, 165) #50 subsets

#For graph to include all variables from SVM
sizes.4<-c(2:35,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180, 191,290,579, 1157) #53 subsets

#For RF-RFE no acc_CITY v2
sizes.5<-c(2:30,40,60,100, 165) #33 subsets

#########################
##create seeds to enable reproduction of training models
##when using parallel processing
#########################

#set to 10/11 for testing code - 10 bootstrap with 17 subset sizes
seeds.rerank.1 <- vector(mode = "list", 
                       length = 11)
for(i in 1:10){
  seeds.rerank.1[[i]] <- sample.int(n=1000, 17) ##last argument equal to number of subsets sizes
}


#101 -> 100 bootstrap with 32 subset sizes
seeds.rerank.2<-vector(mode="list",
                       length=101)
for(i in 1:100){
  seeds.rerank.2[[i]] <- sample.int(n=1000, 32) ##last argument equal to number of subsets sizes
}

#101 -> 100 bootstrap with 50 subset sizes
seeds.rerank.3<-vector(mode="list",
                       length=101)
for(i in 1:100){
  seeds.rerank.3[[i]] <- sample.int(n=1000, 50) ##last argument equal to number of subsets sizes
}

#51 -> 100 bootstrap with 53 subset sizes
seeds.rerank.4<-vector(mode="list",
                       length=101)
for(i in 1:100){
  seeds.rerank.4[[i]] <- sample.int(n=1000, 34) ##last argument equal to number of subsets sizes
}


#101 -> 100 bootstrap with 50 subset sizes
seeds.rerank.5<-vector(mode="list",
                       length=101)
for(i in 1:100){
  seeds.rerank.5[[i]] <- sample.int(n=1000, 33) ##last argument equal to number of subsets sizes
}

#########################
##set performance metrics
#########################
#Create function that contains twoClassSummary() - calcs ROC (really AUC), Sensitivity, Specifity and associated std dev.
#and also contains defaultSummary() - calcs Accuracy and Kappa along with standard deviations
fiveStats <- function(...) c(twoClassSummary(...),
                             + defaultSummary(...))  


#########################
##save to workspace
#########################
save.image("1a - Final Code/Fixed Code/Workspaces/Modeling-Ready Workspace.RData")


