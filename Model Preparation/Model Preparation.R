#################################################
##Amy McNamara
##CCSU Special Project
##MS Data SCience
##2020
################################################

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

df2_merge_key_2<-readRDS("2-Data/df2_merge_key_2.rds")
# ncol(df2_merge_key_2)
# #[1] 193 - as expected
# 
# nrow(df2_merge_key_2)
# #[1] 57862 - as expected

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
# [1] 46290   193

dim(df2.Test)
# [1] 11572   193

#####################
##isolate the predictors in a data frame as required for rfe
#####################
#remove target variable and observation key
df2.Train.pred<-select(df2.Train, -c("acc_aux_A_RU_nm","df2_key")) 
df2.Test.pred<-select(df2.Test, -c("acc_aux_A_RU_nm","df2_key")) 


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
sizes.1<- sizes<-c(2:14, 24, 48, 96, 191) #17 subsets

#For use with seeds.rerank.2
sizes.2<-c(2:15,20, 30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180, 191)  #32 subsets

#For use with seeds.rerank.3
sizes.3<-c(2:35,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180, 191) #50 subsets

#For graph to include all variables from SVM
sizes.4<-c(2:35,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180, 191,290,579, 1157) #53 subsets

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
  seeds.rerank.4[[i]] <- sample.int(n=1000, 53) ##last argument equal to number of subsets sizes
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
save.image("4-Workspaces/Modeling-Ready Workspace.RData")


