#################################################
##Amy McNamara
##CCSU Special Project
##MS Data SCience
##Spring 2020
################################################

################################################
#Data Exploration
################################################

#############################
#Load Libraries
#############################
library(data.table)
library(dplyr)
library(corrplot)
library(plot.matrix)
library(stringr)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(readr)
library(ggforce)
library(grDevices)
library(plyr)
library(greybox)
library(expss)
library(summarytools)

#############################
##set working directory
#############################

setwd("C:/Users/atata/Documents/CCSU/Thesis")

#############################
##read rds files as result of Data_Preparation v4.R
#############################
#df2.merge.key<-readRDS("df2_merge_key.rds")

df2.cat.key<-read_rds("df2_cat_key.rds")

df.cont.key<-read_rds("df_cont_key.rds")

ncol(df2.cat.key)
#204
ncol(df.cont.key)
#24


###############################################
##Develop Bar Charts and Normalized Bar Charts
##For categorical variables
##With overlay of urban/rural
###############################################

###Prep Data

#create new dataframe that creates a row for each column 
##but retains the Urban/Rural column to use as overlay
df.cat.bar2 <- melt(df2.cat.key, id = c("df2_key", "acc_aux_A_RU_nm"))

#sum number or records by variable, value and urban/rural
df.cat.bar3<-df.cat.bar2 %>%
  group_by(variable,value, acc_aux_A_RU_nm) %>%
  dplyr::summarise(n = n()) 


df.cat.bar3$value_short_nm<-substr(df.cat.bar3$value,1,30)

#find number of pages
npages<-n_pages(ggplot(data=df.cat.bar3,aes(x=value_short_nm, y=n,fill=acc_aux_A_RU_nm)) +
          geom_bar(position="stack",stat="identity") +
          theme(axis.text.x=element_text(size=8, angle=90)) +
          facet_wrap_paginate(~variable, ncol = 2, nrow = 2, scales="free_x", page=1))
#51 pages 


#Create bar charts

pdf("3-Data Exploration/Bar Chart.pdf")
for (i in 1:51)
  {
  print(ggplot(data=df.cat.bar3,aes(x=value_short_nm, y=n, fill=acc_aux_A_RU_nm)) +
  geom_bar(position="stack",stat="identity") +
  theme(axis.text.x=element_text(size=5, angle=90)) +
    theme(legend.position="bottom") +
    theme(axis.text.x=element_text(lineheight = 0.9)) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
  facet_wrap_paginate(~variable, ncol = 2, nrow = 2, scales="free_x", page=i))}

dev.off()

  
#create datframe to normalize bar charts by finding total count for each value by variable
df.cat.bar4<-df.cat.bar2 %>%
  group_by(variable,value) %>%
  dplyr::summarise(n = n())


#join df.cat.bar3 with df.cat.bar4
df.cat.bar5<-merge(df.cat.bar3, df.cat.bar4,by=c("variable", "value"))

df.cat.bar5$per<-df.cat.bar5$n.x/df.cat.bar5$n.y

df.cat.bar5$value_short_nm<-substr(df.cat.bar3$value,1,30)


head(df.cat.bar5)
                     
#Create normalized bar charts
pdf("3-Data Exploration/Normalized Bar Chart.pdf")
for (i in 1:51)
{
  print(ggplot(data=df.cat.bar5, aes(x=value_short_nm, y=per, fill = acc_aux_A_RU_nm))+
          geom_bar(position="stack", stat="identity")+
          theme(axis.text.x=element_text(size=6, angle=90))+
          theme(legend.position="bottom")+
          scale_x_discrete(labels=function(x) str_wrap(x, width=10))+
          facet_wrap_paginate(~variable, ncol=2, nrow=2, scales="free_x", page=i))
}
dev.off()

head(df.cat.bar5)

####################################
##Histograms and Normalized Histograms
##For continuous variables with overlay of target - Urban/rural
####################################

#Add the target to the dataframe in order to provide overlay histograms
df.cont$acc_aux_A_RU_nm<-df2.cat.key$acc_aux_A_RU_nm
summary(df.cont)
nrow(df.cont)


#create new dataframe that creates a row for each column 
##but retains the Urban/Rural column to use as overlay
df.cont.hist <- df.cont %>% gather(key=key, value=measurement, -acc_aux_A_RU_nm)
tail(df.cont.hist)

#check new dataframe
str(df.cont.hist)
summary(df.cont.hist)

#######################
#Histogram with overlay of urban/rural
#For continuous variables
######################

pdf("3-Data Exploration/Histogram.pdf")
for (i in 1:6)
{print(ggplot(df.cont.hist,aes(x = measurement, fill=acc_aux_A_RU_nm)) + 
  geom_histogram(position="stack") +
    theme(axis.text.x=element_text(size=6)) +
    theme(legend.position="bottom")+
  facet_wrap_paginate(~key, ncol = 2, nrow = 2, scales="free_x", page=i))}
dev.off()


#######################
#Normalized Histogram with overlay of urban/rural
#continuous variables
######################

#Create dataframe with count by variable, measurement and rural/urban
df.cont.hist2<-df.cont.hist %>%
  group_by(key, measurement, acc_aux_A_RU_nm) %>%
  dplyr::summarise(n = n())
  
#Create field in dataframe that sums records by key and measurement
df.cont.hist3<-df.cont.hist %>%
  group_by(key, measurement) %>%
  dplyr::summarise(n=n())

#merge the above two dataframes
df.cont.hist4<-merge(df.cont.hist2, df.cont.hist3, by = c('key','measurement'))
summary(df.cont.hist4)

#calc percentage by key, measurement and acc_aux_a_ru_nm
df.cont.hist4$per<-df.cont.hist4$n.x/df.cont.hist4$n.y 

#create final dataframe for histogram
df.cont.hist5<-df.cont.hist4[,c("key","measurement","acc_aux_A_RU_nm","per")]

summary(df.cont.hist5)

##turn measurement into factor as geom_col needs factor for x variable
str(df.cont.hist5$measurement)
df.cont.hist5$measurement_ft<-as.factor(df.cont.hist5$measurement)

###Create normalized histograms
pdf("3-Data Exploration/Normalized Histogram.pdf")
for (i in 1:6)
{print(ggplot() + geom_col(data = df.cont.hist5, aes(x = measurement_ft, y = per, fill=acc_aux_A_RU_nm))+
         theme(axis.text.x=element_text(size=6)) +
         theme(legend.position="bottom")+
  facet_wrap_paginate(~key, ncol = 2, nrow = 2, scales="free_x", page=i))}
dev.off()


#write data to file
write.csv(df.cont.hist4,"3-Data Exploration/Histogram Data 2.csv")

#######################
##after reviewing all data in graphs and correlation matrix, 
##perfectly correlated variables - one was removed - retained one with more detail
##retained the most detailed age categorical variable
#######################

##34 variables removed

df2_merge_key<-read_rds("df2_merge_key.rds")


remove<-names(df2_merge_key) %in% c("per_PER_TYPE_nm","acc_aux_A_INTER_nm","acc_aux_A_ROADFC_nm",
                            "acc_aux_A_RELRD_nm","acc_aux_A_INTSEC_nm",'acc_aux_A_JUNC_nm', "acc_aux_A_MANCOL_nm"
                            ,"acc_aux_A_TOD_nm","acc_aux_SPJ_INDIAN_nm","veh_HARM_EV_nm","veh_aux_A_IMP1_nm",
                            "veh_aux_A_VROLL_nm","veh_ROLINLOC_nm","veh_aux_A_LIC_C_nm","veh_aux_A_CDL_S_nm",
                            "veh_aux_A_SPVEH_nm","veh_aux_A_SBUS_nm","veh_HAZ_INV_nm","veh_HAZ_PLAC_nm",
                            "veh_HAZ_REL_nm","per_aux_A_AGE1_nm",
                            "per_aux_A_AGE2_nm","per_aux_A_AGE4_nm","per_aux_A_AGE5_nm","per_aux_A_AGE6_nm",
                            "per_aux_A_AGE7_nm","per_aux_A_AGE8_nm","per_aux_A_AGE9_nm","per_aux_A_RESTUSE_nm",
                            "per_aux_A_HISP_nm","per_aux_A_RCAT_nm", "per_aux_A_EJECT_nm","per_P_SF2_nm",
                            "per_P_SF3_nm")

df2_merge_key_2<-df2_merge_key[!remove]

ncol(df2_merge_key_2)

###save file
saveRDS(df2_merge_key_2,"df2_merge_key_2.rds")

#195