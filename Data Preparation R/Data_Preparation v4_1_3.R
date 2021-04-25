##############################################################################
##Amy McNamara
##CCSU Special Project
##MS Data SCience
##Spring 2020
##############################################################################

#update bin for veh_body_typ to reflect type of vehicle instead see page 515 of 2017 FARS Analytical User's Manual


##############################################################################
##Data Pre-Processing
##############################################################################

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
#Set directory to pull in data
#############################
setwd("H:/CCSU/Thesis")     

#setwd("C:/Users/amcnama/Documents/CCSU/Thesis")

#setwd("C:/Users/atata/Documents/CCSU/Thesis")

#############################
#Load data
#############################
df<-read.delim("2-Data/raw_final_desc.csv", sep=",", header=TRUE, stringsAsFactors=T)

##look at summaries - should be 58,337 records
summary(df)
##'data.frame':	58337 obs. of  248 variables:

############################
#Prelim look
############################
#ensure each record has unique key
uniqueN(df$ï..Key)
#[1] 58337

#check number of rows
nrow(df)
#[1] 58337

#check number of columns
ncol(df)
#247

names<-names(df)
#write.csv(names,"3-Data Exploration/names.csv")

#look at datatypes
str(df)

###########################
##Remove records where target variable is unknown
###########################
#first create copy of df in case need to go back
df2<-df

df2<-df2[!(df2$acc_aux_A_RU_nm=="Unknown"),]

nrow(df2)
#[1] 57862

#remove Unknown factor level
df2$acc_aux_A_RU_nm<-factor(df2$acc_aux_A_RU_nm)
levels(df2$acc_aux_A_RU_nm)

##create vector of key field to be pulled into other dataframes later
df2$key<-df2$ï..Key


##########################
##Evaluate % Rural/Urban
##########################
nrow(df2[(df2$acc_aux_A_RU_nm=="Rural"),])
#[1] 30107
30107/57862
#[1] 0.5203242

nrow(df2[(df2$acc_aux_A_RU_nm=="Urban"),])
#[1] 27755
27755/57862
#[1] 0.4796758

###########################
##Remove variables that are more granular than rural/urban target or ID's or time less than an hour or full timestamp
#remove old key
###########################


#list variable to remove
remove<-names(df2) %in% c("acc_MILEPT","acc_LATITUDE", "acc_LONGITUD", "acc_TWAY_ID", "acc_TWAY_ID2", "acc_RAIL",
                          "veh_TRLR1VIN","veh_TRLR2VIN", "veh_TRLR3VIN", "veh_HAZ_ID", "veh_DR_ZIP","per_DEATH_MN", "per_DEATH_TM",
                          "acc_MINUTE","acc_NOT_MIN","acc_ARR_MIN","acc_HOSP_MN","ï..Key")


#remove variables list above
df2<-df2[!remove]

##with starting point of 247, should be 230
ncol(df2)
#230


###########################
##Remove duplicative target variable
###########################

#check the values line up 
data.frame(table(df2$acc_aux_A_RU_nm,df2$acc_RUR_URB_nm))

remove<-names(df2) %in% c("acc_RUR_URB_nm")

#remove variables list above
df2<-df2[!remove]

##with starting point of 230, should be 229
ncol(df2)
#229

############################
#Identify categorical variables
###########################
#remove continuous variables- 22 of them
#retain continuous variables that will be converted to categorical
#, "veh_TRAV_SP","veh_DR_HGT","veh_DR_WGT", "veh_FIRST_YR","veh_LAST_YR",
#remove ID - 1 of them
#remove accident year as only 2 years included
df2.cat<-df2[, -which(names(df2) %in% c("acc_PEDS", "acc_PERNOTMVIT", "acc_VE_TOTAL",
                                     "acc_VE_FORMS", "acc_PVH_INVL", "acc_PERSONS", "acc_PERMVIT",  "acc_FATALS", "acc_DRUNK_DR",
                                     "veh_DEATHS", "veh_NUMOCCS",
                                      "veh_prev_sus", "per_LAG_HRS",  "per_LAG_MINS",
                                     "per_AGE", "oth_veh_PREV_OTH","oth_veh_prev_sus",
                                     "oth_veh_PREV_SPD","oth_veh_PREV_DWI","oth_veh_PREV_ACC", "veh_PREV_ACC",
                                      "veh_PREV_DWI", "veh_PREV_SPD","veh_PREV_OTH",##continuous
                                     "ï..Key" ##ID
                                     ,"acc_YEAR" # year

                                                                          ))]
#columns should be 229-26=203
ncol(df2.cat)
#[1] 204
nrow(df2.cat)
#[1] 57862

#find all that are not stored as factors
df2.cat %>% Filter(f = is.numeric) %>% names



#transform variables to factors
df2.cat$acc_COUNTY<-as.factor(df2.cat$acc_COUNTY)
df2.cat$acc_CITY<-as.factor(df2.cat$acc_CITY)
df2.cat$acc_DAY<-as.factor(df2.cat$acc_DAY)
df2.cat$acc_HOUR<-as.factor(df2.cat$acc_HOUR)
df2.cat$acc_NOT_HOUR<-as.factor(df2.cat$acc_NOT_HOUR)
df2.cat$acc_ARR_HOUR<-as.factor(df2.cat$acc_ARR_HOUR)
df2.cat$acc_HOSP_HR<-as.factor(df2.cat$acc_HOSP_HR)
df2.cat$veh_MODEL<-as.factor(df2.cat$veh_MODEL)
df2.cat$veh_MAK_MOD<-as.factor(df2.cat$veh_MAK_MOD)
df2.cat$veh_MOD_YEAR<-as.factor(df2.cat$veh_MOD_YEAR)
df2.cat$veh_VSPD_LIM<-as.factor(df2.cat$veh_VSPD_LIM)
df2.cat$per_ALC_RES<-as.factor(df2.cat$per_ALC_RES)
df2.cat$per_DEATH_DA<-as.factor(df2.cat$per_DEATH_DA)
df2.cat$per_DEATH_YR<-as.factor(df2.cat$per_DEATH_YR)
df2.cat$per_DEATH_HR<-as.factor(df2.cat$per_DEATH_HR)



#check again all are now factors and evaluate number of levels
# factorlevels<-sapply(df2.cat[,sapply(df2.cat, is.factor)],nlevels)
# write.csv(factorlevels,"3-Data Exploration/factorlevels.csv")

#following categorical variable have more than 32 levels
#random forest cannot handle more than 32 levels
# acc_aux_STATE_nm -- bin by quartile of % rural accidents
# acc_COUNTY -- bin by quartile of % rural accidents
# acc_CITY -- bin by quartile of % rural accidents
# acc_HARM_EV_nm --bin by discretion; no group in FARS DD, same as veh_M_HARM_nm
# veh_HARM_EV_nm --bin by discretion; no group in FARS DD, same as veh_M_HARM_nm
# veh_REG_STAT_nm -- bin by quartile of % rural accidents
# veh_MAKE_nm -- bin by quartile of % rural accidents
# veh_MODEL -- bin by quartile of % rural accidents
# veh_MAK_MOD -- bin by quartile of % rural accidents
# veh_BODY_TYP_nm -- bin by quartile of % rural accidents
# veh_MOD_YEAR --bined by quartile
# veh_M_HARM_nm --bin by discretion; no group in FARS DD
# veh_L_STATE_nm --bined by quartile
# veh_DR_SF1_nm --bin by FARS DD group
# veh_DR_SF2_nm --bin by FARS DD group
# veh_DR_SF3_nm --bin by FARS DD group
# veh_DR_SF4_nm --bin by FARS DD group
# veh_P_CRASH2_nm --bin by FARS DD group
# veh_ACC_TYP_nm --bin by FARS DD group
# per_ALC_RES -- binned by amount
# per_DEATH_DA -- bin by beg, mid, end of month

#######################
#bin acc_aux_STATE_nm by target
#######################

##Find number of accidents by state and rural vs urban
acc_aux_STATE_nm_all<-data.frame(table(df2.cat$acc_aux_STATE_nm,df2.cat$acc_aux_A_RU_nm))
state.fatal<-dcast(acc_aux_STATE_nm_all, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)

#Calc total fatalities by state
state.fatal$total<-state.fatal$Rural + state.fatal$Urban

#Calc percent rural
state.fatal$per_rur<-state.fatal$Rural/state.fatal$total

#create same column name
state.fatal$acc_aux_STATE_nm<-state.fatal$Var1

#merge dataframes to pull in per_rur
df2.cat<-merge(df2.cat, state.fatal, by ="acc_aux_STATE_nm" )

#find quartiles for % rural
summary(df2.cat$per_rur)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.02941 0.43089 0.57143 0.55729 0.70362 0.91810 

df2.cat$acc_aux_STATE_nm_bin<-cut(df2.cat$per_rur, breaks=c(0.02941,0.43089,0.57143,0.70362,0.91810),
                              labels=c("low_rural_fatal","med_low_rural_fatal","med_high_rural_fatal","high_rural_fatal"))

summary(df2.cat$acc_aux_STATE_nm_bin)
#      low_rural_fatal  med_low_rural_fatal med_high_rural_fatal     high_rural_fatal                 NA's 
#               18028                18587                14054                 6961                  232 

#replace NA's with category of "not known"
df2.cat$acc_aux_STATE_nm_bin<-df2.cat$acc_aux_STATE_nm_bin %>% fct_explicit_na(na_level = 'Not Known')
levels(df2.cat$acc_aux_STATE_nm_bin)

#Remove original variable and all other calc variables included in merged table
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("Rural","Urban", "Var1", "total", "per_rur"))] #"acc_aux_STATE_nm",

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 205

#####################
#bin acc_COUNTY
#####################
##Find number of accidents by state and county and rural vs urban
#load state codes
state<-read.csv("2-Data/State Codes.csv", stringsAsFactors = F)


#load GLC data from web
glc<-read.csv("2-Data/FRPP_GLC_-_United_StATESaPRIL62021.csv",stringsAsFactors=T)

#
#prep state
state$state_code<-stringr::str_pad(state$state_code, 2, pad="0")
state$state_code<-as.factor(state$state_code)
state$state<-as.factor(state$state)

#Prep GLC data
glc$Duty.Station.Code.2<-stringr::str_pad(glc$Duty.Station.Code.2, 9, pad="0")
glc$State_Code_3<-substr(glc$Duty.Station.Code.2,1,2)
glc$State_Code_3<-stringr::str_pad(glc$State_Code_3, 2, pad="0")
glc$City_Code_3<-substr(glc$Duty.Station.Code.2,3,6)
glc$County_Code_3<-substr(glc$Duty.Station.Code.2,7,9)
glc$State_County<-paste(glc$State_Code_3,glc$County_Code_3, sep="")
glc$State.Name<-tolower(glc$State.Name)
glc$County.Name<-tolower(glc$County.Name)

glc$State_Code_3<-as.factor(glc$State_Code_3)
glc$State.Name<-as.factor(glc$State.Name)
glc$State_County<-as.factor(glc$State_County)

#select unique combinations of state and county
glc_state_county<-glc %>% select (c("State_County", "County.Name")) %>%
  group_by(State_County, County.Name) %>%
  dplyr::summarise(n())
dim(glc_state_county)
# [1] 3151    3
length(unique(glc_state_county$State_County))
# 3148

glc_state_county<- glc_state_county %>%
  group_by(State_County) %>%
  slice(which.max(`n()`))
dim(glc_state_county)
# 3148    3

df2.cat$acc_aux_STATE_nm<-tolower(df2.cat$acc_aux_STATE_nm)
df2.cat$acc_aux_STATE_nm<-gsub("_", " ", df2.cat$acc_aux_STATE_nm, fixed=TRUE)
df2.cat$acc_aux_STATE_nm<-as.factor(df2.cat$acc_aux_STATE_nm)
df2.cat$acc_COUNTY<-stringr::str_pad(df2.cat$acc_COUNTY, 3, pad="0")
df2.cat$acc_COUNTY<-as.factor(df2.cat$acc_COUNTY)


#merge state withdf2.cat to get state code
df2.cat<-merge(df2.cat, state, by.x=(c("acc_aux_STATE_nm")), by.y=(c("state")), all.x=TRUE)
dim(df2.cat)
# 57862   206
# summary(df2.cat$state_code)

# concatenate state and county in df2.cat
df2.cat$State_County<-paste(df2.cat$state_code, df2.cat$acc_COUNTY, sep="")
df2.cat$State_County<-as.factor(df2.cat$State_County)


#merge df2.cat with glc to get county name
df2.cat<-merge(df2.cat, glc_state_county, by=c("State_County"), all.x=TRUE)
dim(df2.cat)
# 57862   209

#remove column not needed
df2.cat<-df2.cat %>%
  select(-c("n()"))
dim(df2.cat)
# 57862   208





acc_COUNTYall<-data.frame(table(df2.cat$State_County,df2.cat$acc_aux_A_RU_nm))
acc_COUNTY.fatal<-dcast(acc_COUNTYall, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)

#Calc total fatalities by state
acc_COUNTY.fatal$total<-acc_COUNTY.fatal$Rural + acc_COUNTY.fatal$Urban

#Calc percent rural
acc_COUNTY.fatal$per_rur<-acc_COUNTY.fatal$Rural/acc_COUNTY.fatal$total

#create same column name
acc_COUNTY.fatal$State_County<-acc_COUNTY.fatal$Var1

#merge dataframes to pull in per_rur
df2.cat<-merge(df2.cat, acc_COUNTY.fatal, by ="State_County" )

#find quartiles for % rural
summary(df2.cat$per_rur)
#    Min. 1st Qu. Median    Mean  3rd Qu.    Max. 
# 0.0000  0.1765  0.5167  0.5203  0.8529  1.0000 

df2.cat$acc_COUNTY_bin<-cut(df2.cat$per_rur, breaks=c(0.0000,0.1765,0.5167,0.8529,1.0000),
                                  labels=c("low_rural_fatal","med_low_rural_fatal","med_high_rural_fatal","high_rural_fatal"))

summary(df2.cat$acc_COUNTY_bin)
# # low_rural_fatal  med_low_rural_fatal med_high_rural_fatal     high_rural_fatal                 NA's 
#             13174                14416                14452                14476                 1344 

#replace NA's with category of "low_rural_fatal"
df2.cat$acc_COUNTY_bin<-df2.cat$acc_COUNTY_bin %>% fct_explicit_na(na_level = 'low_rural_fatal')
levels(df2.cat$acc_COUNTY_bin)

#Remove original variable and all other calc variables included in merged table
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("Rural","Urban", "Var1", "total", "per_rur"))] #"acc_COUNTY",

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 209

#####################
#bin acc_CITY
#####################
##Find number of accidents by city and rural vs urban
# acc_CITYall<-data.frame(table(df2.cat$acc_CITY,df2.cat$acc_aux_A_RU_nm))
# acc_CITY.fatal<-dcast(acc_CITYall, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)
# 
# #Calc total fatalities by city
# acc_CITY.fatal$total<-acc_CITY.fatal$Rural + acc_CITY.fatal$Urban
# 
# #Calc percent rural
# acc_CITY.fatal$per_rur<-acc_CITY.fatal$Rural/acc_CITY.fatal$total
# 
# #create same column name
# acc_CITY.fatal$acc_CITY<-acc_CITY.fatal$Var1
# 
# #merge dataframes to pull in per_rur
# df2.cat<-merge(df2.cat, acc_CITY.fatal, by ="acc_CITY" )
# 
# #find quartiles for % rural
# summary(df2.cat$per_rur)
# # Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# # 0.0000  0.1774  0.7494  0.5203  0.7494  1.0000
# 
# df2.cat$acc_CITY_bin<-cut(df2.cat$per_rur, breaks=c(0.0000,0.1774,0.5203,0.7494,1.0000),
#                             labels=c("low_rural_fatal","med_low_rural_fatal","med_high_rural_fatal","high_rural_fatal"))
# 
# summary(df2.cat$acc_CITY_bin)
# #     low_rural_fatal  med_low_rural_fatal med_high_rural_fatal     high_rural_fatal                 NA's 
# #               12039                 8182                 1744                33488                 2409 
# 
# #replace NA's with category of "not known"
# df2.cat$acc_CITY_bin<-df2.cat$acc_CITY_bin %>% fct_explicit_na(na_level = 'Not Known')
# levels(df2.cat$acc_CITY_bin)
# 
# #Remove original variable and all other calc variables included in merged table
# df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("acc_CITY","Rural","Urban", "Var1", "total", "per_rur"))]
# 
# #number should not change as swapping one variable for a derived variable
# ncol(df2.cat)
# # [1] 203

#####################
#veh_REG_STAT_nm
#####################
##Find number of accidents by veh_REG_STAT_nm and rural vs urban
veh_REG_STAT_nmall<-data.frame(table(df2.cat$veh_REG_STAT_nm,df2.cat$acc_aux_A_RU_nm))
veh_REG_STAT_nm.fatal<-dcast(veh_REG_STAT_nmall, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)

#Calc total fatalities by veh_REG_STAT_nm
veh_REG_STAT_nm.fatal$total<-veh_REG_STAT_nm.fatal$Rural + veh_REG_STAT_nm.fatal$Urban

#Calc percent rural
veh_REG_STAT_nm.fatal$per_rur<-veh_REG_STAT_nm.fatal$Rural/veh_REG_STAT_nm.fatal$total

#create same column name
veh_REG_STAT_nm.fatal$veh_REG_STAT_nm<-veh_REG_STAT_nm.fatal$Var1

#merge dataframes to pull in per_rur
df2.cat<-merge(df2.cat, veh_REG_STAT_nm.fatal, by ="veh_REG_STAT_nm" )

#find quartiles for % rural
summary(df2.cat$per_rur)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.08696 0.43292 0.50490 0.52032 0.63290 0.90946 

df2.cat$veh_REG_STAT_nm_bin<-cut(df2.cat$per_rur, breaks=c(0.08696,0.43292,0.50490,0.63290,0.90946),
                          labels=c("low_rural_fatal","med_low_rural_fatal","med_high_rural_fatal","high_rural_fatal"))

summary(df2.cat$veh_REG_STAT_nm_bin)
#         low_rural_fatal  med_low_rural_fatal med_high_rural_fatal     high_rural_fatal                 NA's 
#                   13630                19142                 9747                15077                  266

#replace NA's with category of "low_rural_fatal"
df2.cat$veh_REG_STAT_nm_bin<-df2.cat$veh_REG_STAT_nm_bin %>% fct_explicit_na(na_level = 'low_rural_fatal')
levels(df2.cat$veh_REG_STAT_nm_bin)

#Remove original variable and all other calc variables included in merged table
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("Rural","Urban", "Var1", "total", "per_rur"))] #"veh_REG_STAT_nm",

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 210

#####################
#veh_MAKE_nm
#####################
##Find number of accidents by veh_MAKE_nm and rural vs urban
veh_MAKE_nmall<-data.frame(table(df2.cat$veh_MAKE_nm,df2.cat$acc_aux_A_RU_nm))
veh_MAKE_nm.fatal<-dcast(veh_MAKE_nmall, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)

#Calc total fatalities by veh_REG_STAT_nm
veh_MAKE_nm.fatal$total<-veh_MAKE_nm.fatal$Rural + veh_MAKE_nm.fatal$Urban

#Calc percent rural
veh_MAKE_nm.fatal$per_rur<-veh_MAKE_nm.fatal$Rural/veh_MAKE_nm.fatal$total

#create same column name
veh_MAKE_nm.fatal$veh_MAKE_nm<-veh_MAKE_nm.fatal$Var1

#merge dataframes to pull in per_rur
df2.cat<-merge(df2.cat, veh_MAKE_nm.fatal, by ="veh_MAKE_nm" )

#find quartiles for % rural
summary(df2.cat$per_rur)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0000  0.4665  0.5191  0.5203  0.5942  0.8036 

df2.cat$veh_MAKE_nm_bin<-cut(df2.cat$per_rur, breaks=c(0.0000,0.4665,0.5191,0.5942,0.8036),
                                 labels=c("low_rural_fatal","med_low_rural_fatal","med_high_rural_fatal","high_rural_fatal"))

summary(df2.cat$veh_MAKE_nm_bin)
#     low_rural_fatal  med_low_rural_fatal med_high_rural_fatal     high_rural_fatal                 NA's 
#            14062                15042                14322                14430                    6 

#replace NA's with category of "low_rural_fatal"
df2.cat$veh_MAKE_nm_bin<-df2.cat$veh_MAKE_nm_bin %>% fct_explicit_na(na_level = 'low_rural_fatal')
levels(df2.cat$veh_MAKE_nm_bin)

#Remove original variable and all other calc variables included in merged table
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("Rural","Urban", "Var1", "total", "per_rur"))] #"veh_MAKE_nm",

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 211

####################
#veh_MODEL
####################

##Find number of accidents by veh_MODEL and rural vs urban
veh_MODELall<-data.frame(table(df2.cat$veh_MODEL,df2.cat$acc_aux_A_RU_nm))
veh_MODEL.fatal<-dcast(veh_MODELall, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)

#Calc total fatalities by veh_REG_STAT_nm
veh_MODEL.fatal$total<-veh_MODEL.fatal$Rural + veh_MODEL.fatal$Urban

#Calc percent rural
veh_MODEL.fatal$per_rur<-veh_MODEL.fatal$Rural/veh_MODEL.fatal$total

#create same column name
veh_MODEL.fatal$veh_MODEL<-veh_MODEL.fatal$Var1

#merge dataframes to pull in per_rur
df2.cat<-merge(df2.cat, veh_MODEL.fatal, by ="veh_MODEL" )

#find quartiles for % rural
summary(df2.cat$per_rur)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0000  0.4407  0.5134  0.5203  0.5860  1.0000 

df2.cat$veh_MODEL_bin<-cut(df2.cat$per_rur, breaks=c(0.0000,0.4407,0.5134,0.5860,1.0000),
                             labels=c("low_rural_fatal","med_low_rural_fatal","med_high_rural_fatal","high_rural_fatal"))

summary(df2.cat$veh_MODEL_bin)
#         low_rural_fatal  med_low_rural_fatal med_high_rural_fatal     high_rural_fatal                 NA's 
#                16114                11058                16803                13878                    9 

#replace NA's with category of "low_rural_fatal"
df2.cat$veh_MODEL_bin<-df2.cat$veh_MODEL_bin %>% fct_explicit_na(na_level = 'low_rural_fatal')
levels(df2.cat$veh_MODEL_bin)

#Remove original variable and all other calc variables included in merged table
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("Rural","Urban", "Var1", "total", "per_rur"))] #"veh_MODEL",

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 212

#####################
#veh_MAK_MOD
#####################

##Find number of accidents by veh_MAK_MODL and rural vs urban
veh_MAK_MODall<-data.frame(table(df2.cat$veh_MAK_MOD,df2.cat$acc_aux_A_RU_nm))
veh_MAK_MOD.fatal<-dcast(veh_MAK_MODall, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)

#Calc total fatalities by veh_MAK_MOD
veh_MAK_MOD.fatal$total<-veh_MAK_MOD.fatal$Rural + veh_MAK_MOD.fatal$Urban

#Calc percent rural
veh_MAK_MOD.fatal$per_rur<-veh_MAK_MOD.fatal$Rural/veh_MAK_MOD.fatal$total

#create same column name
veh_MAK_MOD.fatal$veh_MAK_MOD<-veh_MAK_MOD.fatal$Var1

#merge dataframes to pull in per_rur
df2.cat<-merge(df2.cat, veh_MAK_MOD.fatal, by ="veh_MAK_MOD" )

#find quartiles for % rural
summary(df2.cat$per_rur)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#0.0000  0.4483  0.5165  0.5203  0.6042  1.000

df2.cat$veh_MAK_MOD_bin<-cut(df2.cat$per_rur, breaks=c(0.0000,0.4483,0.5165,0.6042,1.0000),
                           labels=c("low_rural_fatal","med_low_rural_fatal","med_high_rural_fatal","high_rural_fatal"))

summary(df2.cat$veh_MAK_MOD_bin)
#          low_rural_fatal  med_low_rural_fatal med_high_rural_fatal     high_rural_fatal                 NA's 
#                    14292                14265                14720                14406                  179 

#replace NA's with category of "low_rural_fatal"
df2.cat$veh_MAK_MOD_bin<-df2.cat$veh_MAK_MOD_bin %>% fct_explicit_na(na_level = 'low_rural_fatal')
levels(df2.cat$veh_MAK_MOD_bin)

#Remove original variable and all other calc variables included in merged table
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("Rural","Urban", "Var1", "total", "per_rur"))] #"veh_MAK_MOD",

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 213

#####################
#veh_BODY_TYP_nm - UPDATED
#####################

##Find number of accidents by veh_BODY_TYP_nm and rural vs urban
# veh_BODY_TYP_nmall<-data.frame(table(df2.cat$veh_BODY_TYP_nm,df2.cat$acc_aux_A_RU_nm))
# veh_BODY_TYP_nm.fatal<-dcast(veh_BODY_TYP_nmall, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)
# 
# #Calc total fatalities by veh_BODY_TYP_nm
# veh_BODY_TYP_nm.fatal$total<-veh_BODY_TYP_nm.fatal$Rural + veh_BODY_TYP_nm.fatal$Urban
# 
# #Calc percent rural
# veh_BODY_TYP_nm.fatal$per_rur<-veh_BODY_TYP_nm.fatal$Rural/veh_BODY_TYP_nm.fatal$total
# 
# #create same column name
# veh_BODY_TYP_nm.fatal$veh_BODY_TYP_nm<-veh_BODY_TYP_nm.fatal$Var1
# 
# #merge dataframes to pull in per_rur
# df2.cat<-merge(df2.cat, veh_BODY_TYP_nm.fatal, by ="veh_BODY_TYP_nm" )
# 
# #find quartiles for % rural
# summary(df2.cat$per_rur)
# #      Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# #    0.0000  0.4813  0.4813  0.5203  0.5703  1.0000
# 
# df2.cat$veh_BODY_TYP_nm_bin<-cut(df2.cat$per_rur, breaks=c(0.0000,0.4813,0.5703,1.0000),
#                              labels=c("low_rural_fatal","med_rural_fatal","high_rural_fatal"))
# 
# summary(df2.cat$veh_BODY_TYP_nm_bin)
# # low_rural_fatal  med_rural_fatal high_rural_fatal             NA's 
# #         13546            23068            21238               10                
# 
# #replace NA's with category of "low_rural_fatal"
# df2.cat$veh_BODY_TYP_nm_bin<-df2.cat$veh_BODY_TYP_nm_bin %>% fct_explicit_na(na_level = 'low_rural_fatal')
# levels(df2.cat$veh_BODY_TYP_nm_bin)
# 
# #Remove original variable and all other calc variables included in merged table
# df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("Rural","Urban", "Var1", "total", "per_rur"))] #"veh_BODY_TYP_nm",
# 
# #number should not change as swapping one variable for a derived variable
# ncol(df2.cat)
# # [1] 214

#bin based on FARS Analytical Manual 2017 pg 515
summary(df2.cat$veh_BODY_TYP_nm)
str(df2.cat$veh_BODY_TYP_nm)

df2.cat$veh_BODY_TYP_nm_bin2<-df2.cat$veh_BODY_TYP_nm

#add levels
levels(df2.cat$veh_BODY_TYP_nm_bin2) <- c(levels(df2.cat$veh_BODY_TYP_nm_bin2), "Passenger Car")
levels(df2.cat$veh_BODY_TYP_nm_bin2) <- c(levels(df2.cat$veh_BODY_TYP_nm_bin2), "Light Trucks & Vans")
levels(df2.cat$veh_BODY_TYP_nm_bin2) <- c(levels(df2.cat$veh_BODY_TYP_nm_bin2), "Large Trucks")
levels(df2.cat$veh_BODY_TYP_nm_bin2) <- c(levels(df2.cat$veh_BODY_TYP_nm_bin2), "Motorcycles")
levels(df2.cat$veh_BODY_TYP_nm_bin2) <- c(levels(df2.cat$veh_BODY_TYP_nm_bin2), "Buses")
levels(df2.cat$veh_BODY_TYP_nm_bin2) <- c(levels(df2.cat$veh_BODY_TYP_nm_bin2), "Other/Unknown Vehicles")



df2.cat$veh_BODY_TYP_nm_bin2<-ifelse(df2.cat$veh_BODY_TYP_nm_bin2=="1_Convertible_(Excludes_Sunroof_T-Bar)"  | 
                                       df2.cat$veh_BODY_TYP_nm_bin2=="2-Door_Sedan/Hardtop/Coupe"  |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="3-Door/2-Door_Hatchback"   |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="4-Door_Sedan/Hardtop"    |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="5-Door/4-Door_Hatchback"        |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="6_Station_Wagon_(Excluding_Van_and_Truck-Based)"    |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="8_Sedan/Hardtop_Number_of_Doors_Unknown_(Since_1994)"   |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="9_Other_or_Unknown_Automobile_Type_(Since_1994)"   |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="10_Auto-Based_Pickup"   |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="11_Auto-Based_Panel_(Cargo_Station_Wagon_Auto-Based_Ambulance_or_Hearse)" |
                                       df2.cat$veh_BODY_TYP_nm_bin2=="17_3-Door_Coupe"   
                                       , "Passenger Car",
                                     ifelse(df2.cat$veh_BODY_TYP_nm_bin2=="14_Compact_Utility_(ANSI_D-16_Utility_Vehicle_Categories_Small_and_Midsize)"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="15_Large_Utility_(ANSI_D-16_Utility_Vehicle_Categories_Full_Size_and_Large)"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="16_Utility_Station_Wagon"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="19_Utility_Unknown_Body" |
                                              df2.cat$veh_BODY_TYP_nm_bin2=="20_Minivan"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="21_Large_Van_Includes_Van-Based_Buses"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="22_Step_Van_or_Walk-In_Van"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="28_Other_Van_Type_(Hi-Cube_Van)" |
                                              df2.cat$veh_BODY_TYP_nm_bin2=="29_Unknown_Van_Type" |
                                              df2.cat$veh_BODY_TYP_nm_bin2=="32_Pickup_with_Slide-In_Camper"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="34_Light_Pickup"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="39_Unknown_(Pickup_Style)_Light_Conventional_Truck_Type"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="40_Cab_Chassis-Based_(Includes_Light_Stake_Light_Dump_Light_Tow_Rescue_Vehicles)" |
                                              df2.cat$veh_BODY_TYP_nm_bin2=="45_Other_Light_Conventional_Truck_Type_(Includes_Stretched_Suburban_Limousine)"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="48_Unknown_Light_Truck_Type_(Since_2013)"|
                                              df2.cat$veh_BODY_TYP_nm_bin2=="49_Unknown_Light-Vehicle_Type_(Automobile_Utility_Vehicle_Van_or_Light_Truck)"
                                            , "Light Trucks & Vans",
                                            ifelse(df2.cat$veh_BODY_TYP_nm_bin2=="60_Step_Van_61_61_--_Single-Unit_Straight_Truck_(10000_lbs_<_GVWR_<=_19500_lbs)_(1991-2010)" |
                                                     df2.cat$veh_BODY_TYP_nm_bin2=="61_Single-Unit_Straight_Truck_or_Cab-Chassis_(10000_lbs_<_GVWR_<=_19500_lbs)_(Since_2011)"   |
                                                     df2.cat$veh_BODY_TYP_nm_bin2=="62_Single-Unit_Straight_Truck_or_Cab-Chassis_(19500_lbs_<_GVWR_<=_26000_lbs)_(Since_2011)"  |
                                                     df2.cat$veh_BODY_TYP_nm_bin2=="63_Single-Unit_Straight_Truck_or_Cab-Chassis_(GVWR_>_26000_lbs)_(Since_2011)"  |
                                                     df2.cat$veh_BODY_TYP_nm_bin2=="64_Single_Unit_Straight_Truck_or_Cab-Chassis_(GVWR_Unknown)_(Since_2011)"    |
                                                     df2.cat$veh_BODY_TYP_nm_bin2=="66_Truck/Tractor_(Cab_Only_or_with_Any_Number_of_Trailing_Units:_Any_Weight)"  |
                                                     df2.cat$veh_BODY_TYP_nm_bin2=="67_Medium/Heavy_Pickup_(GVWR_>_10000_lbs)_(Since_2001)" |
                                                     df2.cat$veh_BODY_TYP_nm_bin2=="71_Unknown_if_Single-Unit_or_Combination-Unit_Medium_Truck_(10000_lbs_<=_GVWR_<_26000_lbs)"  |
                                                     df2.cat$veh_BODY_TYP_nm_bin2=="72_Unknown_if_Single-Unit_or_Combination-Unit_Heavy_Truck_(GVWR_>_26000_lbs.)"  |
                                                     df2.cat$veh_BODY_TYP_nm_bin2== "78_Unknown_Medium/Heavy_Truck_Type"
                                                   ,"Large Trucks",
                                                   ifelse(df2.cat$veh_BODY_TYP_nm_bin2=="80_Two_Wheel_Motorcycle_(excluding_motor_scooters)"    |
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="81_Moped_or_Motorized_Bicycle" |
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="82_Three-Wheel_Motorcycle_(2_Rear_Wheels)" |
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="83_Off-Road_Motorcycle"|
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="84_Motor_Scooter" |
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="85_Unenclosed_3-Wheel_Motorcycle_/_Unenclosed_Autocycle_(1_Rear_Wheel)"  |
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="86_Enclosed_3-Wheel_Motorcycle_/_Enclosed_Autocycle_(1_Rear_Wheel)" |
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="87_Unknown_Three_Wheel_Motorcycle_Type"   |
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="88_Other_Motored_Cycle_Type_(Mini-Bikes_Pocket_Motorcycles_Pocket_Bikes)" |
                                                            df2.cat$veh_BODY_TYP_nm_bin2=="89_Unknown_Motored_Cycle_Type" 
                                                          ,"Motorcycles",
                                                          df2.cat$veh_BODY_TYP_nm_bin2
                                                          ))))
df2.cat$veh_BODY_TYP_nm_bin2<-as.factor(df2.cat$veh_BODY_TYP_nm_bin2)
levels(df2.cat$veh_BODY_TYP_nm_bin2)

#Remove original variable and all other calc variables included in merged table
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_BODY_TYP_nm"))] 

dim(df2.cat)
# 57862   213

#####################
#veh_L_STATE_nm
#####################

##Find number of accidents by veh_L_STATE_nm and rural vs urban
veh_L_STATE_nmall<-data.frame(table(df2.cat$veh_L_STATE_nm,df2.cat$acc_aux_A_RU_nm))
veh_L_STATE_nm.fatal<-dcast(veh_L_STATE_nmall, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)

#Calc total fatalities by veh_L_STATE_nm
veh_L_STATE_nm.fatal$total<-veh_L_STATE_nm.fatal$Rural + veh_L_STATE_nm.fatal$Urban

#Calc percent rural
veh_L_STATE_nm.fatal$per_rur<-veh_L_STATE_nm.fatal$Rural/veh_L_STATE_nm.fatal$total

#create same column name
veh_L_STATE_nm.fatal$veh_L_STATE_nm<-veh_L_STATE_nm.fatal$Var1

#merge dataframes to pull in per_rur
df2.cat<-merge(df2.cat, veh_L_STATE_nm.fatal, by ="veh_L_STATE_nm" )

#find quartiles for % rural
summary(df2.cat$per_rur)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  0.0000  0.4248  0.5005  0.5203  0.6344  0.9004 

df2.cat$veh_L_STATE_nm_bin<-cut(df2.cat$per_rur, breaks=c(0.0000,0.4248,0.5005,0.6344, 0.9004),
                                 labels=c("low_rural_fatal","med_low_rural_fatal","med_high_rural_fatal","high_rural_fatal"))

summary(df2.cat$veh_L_STATE_nm_bin)
# low_rural_fatal  med_low_rural_fatal med_high_rural_fatal     high_rural_fatal                 NA's 
#          14159                13143                13957                16361                  242                

#replace NA's with category of "low_rural_fatal"
df2.cat$veh_L_STATE_nm_bin<-df2.cat$veh_L_STATE_nm_bin %>% fct_explicit_na(na_level = 'low_rural_fatal')
levels(df2.cat$veh_L_STATE_nm_bin)

#Remove original variable and all other calc variables included in merged table
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("Rural","Urban", "Var1", "total", "per_rur"))] #"veh_L_STATE_nm",

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 214


#####################
#bin acc_HARM_EV_nm
#####################

summary(df2.cat$acc_HARM_EV_nm)

levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="1_Rollover/Overturn"] <- "Rollover/Overturn"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="12_Motor_Vehicle_in_Transport"] <- "Motor Vehicle in Transport"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="10_Railway_Vehicle"] <- "Railway"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="11_Live_Animal"] <- "Live Animal"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="14_Parked_Motor_Vehicle_(Not_In_Transport)"] <- "Parked MV"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="16_Thrown_or_Falling_Object"] <- "Falling Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="17_Boulder"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="18_Other_Object_(Not_Fixed)"] <- "Other Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="19_Building"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="2_Fire/Explosion"] <- "Fire/Explosion"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="20_Impact_Attenuator/Crash_Cushion"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="21_Bridge_Pier_or_Support"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="23_Bridge_Rail_(Includes_Parapet)"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="24_Guardrail_Face"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="25_Concrete_Traffic_Barrier"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="26_Other_Traffic_Barrier"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="3_Immersion_(or_Partial_Immersion__Since_2012)"] <- "Immersion"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="30_Utility_Pole/Light_Support"] <- "Utility Pole, Post"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="31_Post__Pole__or_Other_Supports"] <- "Utility Pole, Post"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="32_Culvert"] <- "Roadway Surface"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="33_Curb"] <- "Roadway Surface"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="34_Ditch"] <- "Roadway Surface"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="35_Embankment"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="38_Fence"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="39_Wall"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="40_Fire_Hydrant"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="41_Shrubbery"] <- "Tree/Shrub"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="42_Tree_(Standing_Only)"] <- "Tree/Shrub"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="43_Other_Fixed_Object"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="44_Pavement_Surface_Irregularity_(Ruts__Potholes__Grates__etc.)"] <- "Roadway Surface"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="45_Working_Motor_Vehicle"] <- "Motor Vehicle in Transport"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="46_Traffic_Signal_Support"] <- "Utility Pole, Post"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="49_Ridden_Animal_or_Animal-Drawn_Conveyance_(Since_1998)"] <- "Live Animal"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="5_Fell/Jumped_from_Vehicle"] <- "Fell/Jumped_from_Vehicle"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="50_Bridge_Overhead_Structure"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="51_Jackknife_(Harmful_to_This_Vehicle)"] <- "Motor Vehicle in Transport"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="52_Guardrail_End"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="53_Mail_Box"] <- "Utility Pole, Post"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="54_Motor_Vehicle_In-Transport_Strikes_or_is_Struck_by_Cargo__Persons_or_Objects_Set-in-Motion_from/by_Another_Motor_Vehicle_In-Transport"] <- "Motor Vehicle in Transport"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="55_Motor_Vehicle_in_Motion_Outside_the_Trafficway_(Since_2008)"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="57_Cable_Barrier_(Since_2008)"] <- "Roadway Barrier/Construct"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="58_Ground"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="59_Traffic_Sign_Support"] <- "Utility Pole, Post"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="6_Injured_in_Vehicle_(Non-Collision)"] <- "Non-collision"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="7_Other_Non-Collision"] <- "Non-collision"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="72_Cargo/Equipment_Loss_or_Shift_(Harmful_to_This_Vehicle)"] <- "Falling Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="8_Pedestrian"] <- "Pedestrian/Bicyclist"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="9_Pedalcyclist"] <- "Pedestrian/Bicyclist"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="91_Unknown_Object_Not_Fixed"] <- "Other Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="99_Unknown"] <- "Unknown"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="73_Object_That_Had_Fallen_From_Motor_Vehicle_In-Transport"] <- "Falling Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="74_Road_Vehicle_on_Rails"] <- "Railway"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="48_Snow_Bank"] <- "Off Roadway Fixed Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="93_Unknown_Fixed_Object"] <- "Other Object"
levels(df2.cat$acc_HARM_EV_nm)[levels(df2.cat$acc_HARM_EV_nm)=="15_Non-Motorist_on_Personal_Conveyance"] <- "Pedestrian/Bicyclist"


#####################
#veh_HARM_EV_nm
#####################
summary(df2.cat$veh_HARM_EV_nm)

levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="1_Rollover/Overturn"] <- "Rollover/Overturn"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="12_Motor_Vehicle_in_Transport"] <- "Motor Vehicle in Transport"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="10_Railway_Vehicle"] <- "Railway"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="11_Live_Animal"] <- "Live Animal"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="14_Parked_Motor_Vehicle_(Not_In_Transport)"] <- "Parked MV"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="16_Thrown_or_Falling_Object"] <- "Falling Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="17_Boulder"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="18_Other_Object_(Not_Fixed)"] <- "Other Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="19_Building"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="2_Fire/Explosion"] <- "Fire/Explosion"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="20_Impact_Attenuator/Crash_Cushion"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="21_Bridge_Pier_or_Support"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="23_Bridge_Rail_(Includes_Parapet)"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="24_Guardrail_Face"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="25_Concrete_Traffic_Barrier"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="26_Other_Traffic_Barrier"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="3_Immersion_(or_Partial_Immersion_Since_2012)"] <- "Immersion"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="30_Utility_Pole/Light_Support"] <- "Utility Pole, Post"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="31_Post_Pole_or_Other_Supports"] <- "Utility Pole, Post"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="32_Culvert"] <- "Roadway Surface"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="33_Curb"] <- "Roadway Surface"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="34_Ditch"] <- "Roadway Surface"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="35_Embankment"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="38_Fence"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="39_Wall"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="40_Fire_Hydrant"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="41_Shrubbery"] <- "Tree/Shrub"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="42_Tree_(Standing_Only)"] <- "Tree/Shrub"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="43_Other_Fixed_Object"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="44_Pavement_Surface_Irregularity_(Ruts_Potholes_Grates_etc.)"] <- "Roadway Surface"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="45_Working_Motor_Vehicle"] <- "Motor Vehicle in Transport"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="46_Traffic_Signal_Support"] <- "Utility Pole, Post"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="49_Ridden_Animal_or_Animal-Drawn_Conveyance_(Since_1998)"] <- "Live Animal"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="5_Fell/Jumped_from_Vehicle"] <- "Fell/Jumped_from_Vehicle"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="50_Bridge_Overhead_Structure"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="51_Jackknife_(Harmful_to_This_Vehicle)"] <- "Motor Vehicle in Transport"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="52_Guardrail_End"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="53_Mail_Box"] <- "Utility Pole, Post"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="54_Motor_Vehicle_In-Transport_Strikes_or_is_Struck_by_Cargo_Persons_or_Objects_Set-in-Motion_from/by_Another_Motor_Vehicle_In-Transport"] <- "Motor Vehicle in Transport"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="55_Motor_Vehicle_in_Motion_Outside_the_Trafficway_(Since_2008)"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="57_Cable_Barrier_(Since_2008)"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="58_Ground"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="59_Traffic_Sign_Support"] <- "Utility Pole, Post"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="6_Injured_in_Vehicle_(Non-Collision)"] <- "Non-collision"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="7_Other_Non-Collision"] <- "Non-collision"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="72_Cargo/Equipment_Loss_or_Shift_(Harmful_to_This_Vehicle)"] <- "Falling Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="8_Pedestrian"] <- "Pedestrian/Bicyclist"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="9_Pedalcyclist"] <- "Pedestrian/Bicyclist"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="91_Unknown_Object_Not_Fixed"] <- "Other Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="99_Unknown"] <- "Unknown"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="73_Object_That_Had_Fallen_From_Motor_Vehicle_In-Transport"] <- "Falling Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="74_Road_Vehicle_on_Rails"] <- "Railway"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="48_Snow_Bank"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="93_Unknown_Fixed_Object"] <- "Other Object"
levels(df2.cat$veh_HARM_EV_nm)[levels(df2.cat$veh_HARM_EV_nm)=="15_Non-Motorist_on_Personal_Conveyance"] <- "Pedestrian/Bicyclist"

#####################
#bin veh_MOD_YEAR based on age
#####################
#convert to number to allow to evaluate quartiles
veh_mod_year_n<-as.numeric(as.character(df2.cat$veh_MOD_YEAR))
summary(veh_mod_year_n)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1923    2001    2006    2038    2012    9999

#Number of records where the value is not reported, not given, results unknown, no value, unknown
length(which(veh_mod_year_n>=9998))
# [1] 231

#find quartiles without these
veh_mod_year_n_n<-veh_mod_year_n[-which(veh_mod_year_n>=9998)]
summary(veh_mod_year_n_n)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1923    2001    2006    2006    2011    2019

df2.cat$veh_mod_year_bin<-cut(veh_mod_year_n, breaks=c(1923,2001,2006,2011,2019),
                                              labels=c("1923-2000","2001-2005","2006-2010","2011-2019"))

summary(df2.cat$veh_mod_year_bin)
# 1923-2000 2001-2005 2006-2010 2011-2019      NA's 
#     14821     17022     11506     14281       232

#replace NA's with category of "not known"
df2.cat$veh_mod_year_bin<-df2.cat$veh_mod_year_bin %>% fct_explicit_na(na_level = 'Not Known')
levels(df2.cat$veh_mod_year_bin)

#Remove original variable
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_MOD_YEAR"))]

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 214

#####################
#veh_M_HARM_nm
#####################
summary(df2.cat$veh_M_HARM_nm)

levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="1_Rollover/Overturn"] <- "Rollover/Overturn"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="12_Motor_Vehicle_in_Transport"] <- "Motor Vehicle in Transport"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="10_Railway_Vehicle"] <- "Railway"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="11_Live_Animal"] <- "Live Animal"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="14_Parked_Motor_Vehicle"] <- "Parked MV"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="16_Thrown_or_Falling_Object"] <- "Falling Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="17_Boulder"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="18_Other_Object_(Not_Fixed)"] <- "Other Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="19_Building"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="2_Fire/Explosion"] <- "Fire/Explosion"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="20_Impact_Attenuator/Crash_Cushion"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="21_Bridge_Pier_or_Support"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="23_Bridge_Rail_(Includes_Parapet)"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="24_Guardrail_Face"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="25_Concrete_Traffic_Barrier"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="26_Other_Traffic_Barrier"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="3_Immersion_(or_Partial_Immersion_Since_2012)"] <- "Immersion"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="30_Utility_Pole/Light_Support"] <- "Utility Pole, Post"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="31_Post_Pole_or_Other_Support"] <- "Utility Pole, Post"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="32_Culvert"] <- "Roadway Surface"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="33_Curb"] <- "Roadway Surface"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="34_Ditch"] <- "Roadway Surface"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="35_Embankment"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="38_Fence"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="39_Wall"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="40_Fire_Hydrant"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="41_Shrubbery"] <- "Tree/Shrub"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="42_Tree_(Standing_Only)"] <- "Tree/Shrub"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="43_Other_Fixed_Object"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="44_Pavement_Surface_Irregularity_(Ruts_Potholes_Grates_etc.)"] <- "Roadway Surface"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="45_Working_Motor_Vehicle"] <- "Motor Vehicle in Transport"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="46_Traffic_Signal_Support"] <- "Utility Pole, Post"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="49_Ridden_Animal_or_Animal-Drawn_Conveyance_(Since_1998)"] <- "Live Animal"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="5_Fell/Jumped_from_Vehicle"] <- "Fell/Jumped_from_Vehicle"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="50_Bridge_Overhead_Structure"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="51_Jackknife_(Harmful_to_This_Vehicle)"] <- "Motor Vehicle in Transport"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="52_Guardrail_End"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="53_Mail_Box"] <- "Utility Pole, Post"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="54_Motor_Vehicle_In-Transport_Strikes_or_is_Struck_by_Cargo_Persons_or_Objects_Set-in-Motion_from/by_Another_Motor_Vehicle_In-Transport"] <- "Motor Vehicle in Transport"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="55_Motor_Vehicle_in_Motion_Outside_the_Trafficway_(Since_2008)"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="57_Cable_Barrier_(Since_2008)"] <- "Roadway Barrier/Construct"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="58_Ground"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="59_Traffic_Sign_Support"] <- "Utility Pole, Post"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="6_Injured_in_Vehicle_(Non-Collision)"] <- "Non-collision"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="7_Other_Non-Collision"] <- "Non-collision"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="72_Cargo/Equipment_Loss_or_Shift_(Harmful_to_This_Vehicle)"] <- "Falling Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="8_Pedestrian"] <- "Pedestrian/Bicyclist"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="9_Pedalcyclist"] <- "Pedestrian/Bicyclist"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="91_Unknown_Object_Not_Fixed"] <- "Other Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="99_Unknown"] <- "Unknown"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="Object_That_Had_Fallen_From_Motor_Vehicle_In-Transport"] <- "Falling Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="Road_Vehicle_on_Rails"] <- "Railway"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="48_Snow_Bank"] <- "Off Roadway Fixed Object"
levels(df2.cat$veh_M_HARM_nm)[levels(df2.cat$veh_M_HARM_nm)=="93_Unknown_Fixed_Object"] <- "Other Object"

#####################
#bin per_ALC_RES
#####################
levels(df2.cat$per_ALC_RES)

#convert to number to allow to evaluate quartiles
per_ALC_RES_n<-as.numeric(as.character(df2.cat$per_ALC_RES))
summary(per_ALC_RES_n)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.0     0.0   160.0   413.5   996.0   999.0

#Number of records where the value is not reported, not given, results unknown, no value, unknown
length(which(per_ALC_RES_n>=995))
# [1] 22005

#find quartiles without these
per_ALC_RES_n_n<-per_ALC_RES_n[which(per_ALC_RES_n<995)]
summary(per_ALC_RES_n_n)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.00    0.00    0.00   60.72  123.00  940.00

df2.cat$per_ALC_RES_bin<-cut(per_ALC_RES_n, breaks=c(0,60.72,123.00,940,Inf),
                              labels=c("0-60.71","60.72-122.99","123.00-940","Not Known"))

#replace NA's with Not Known
df2.cat$per_ALC_RES_bin<-df2.cat$per_ALC_RES_bin %>% fct_explicit_na(na_level = 'Not Known')
levels(df2.cat$per_ALC_RES_bin)

summary(df2.cat$per_ALC_RES_bin)
# 0-60.71 60.72-122.99   123.00-940    Not Known 
# 1688         2212         9024        44938 

#Remove original variable
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("per_ALC_RES"))]

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 214

#####################
# bin veh_DR_SF1_nm
#####################
summary(df2.cat$veh_DR_SF1_nm)

levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="19_Legally_Driving_on_Suspended_or_Revoked_License"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="21_Overloading_or_Improper_Loading_of_Vehicle_with_Passenger_or_Cargo"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="22_Towing_or_Pushing_Vehicle_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="24_Operating_Without_Required_Equipment"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="26_Following_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="27_Improper_or_Erratic_Lane_Changing"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="28_Improper_Lane_Usage"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="29_Intentional_Illegal_Driving_on_Road_Shoulder_in_Ditch_or_Sidewalk_or_on_Median_(Since_2014)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="33_Passing_Where_Prohibited_by_Posted_Signs_Pavement_Markings_or_School_Bus_Displaying_Warning_Not_to_Pass"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="34_Passing_on_Right_Side"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="35_Passing_with_Insufficient_Distance_or_Inadequate_Visibility_or_Failing_to_Yield_to_Overtaking_Vehicle"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="36_Operating_the_Vehicle_in_an_Erratic_Reckless_Careless_or_Negligent_Manner"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="37_Police_Pursuing_this_Driver_or_Police_Officer_in_Pursuit_(Since_1994)_(See_Police_Pursuits_in_Appendix_C:_Additional_Data_Element_Information)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="38_Failure_to_Yield_Right_of_Way"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="39_Failure_to_Obey_Actual_Traffic_Signs_Traffic_Control_Devices_or_Traffic_Officers_Failure_to_Observe_Safety_Zone_Traffic_Laws"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="42_Failure_to_Signal_Intentions"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="47_Making_Right_Turn_from_Left-Turn_Lane_or_Making_Left_Turn_from_Right-Turn_Lane"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="48_Making_Improper_Turn"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="51_Driving_on_Wrong_Side_of_Two-way_Trafficway_(Intentionally_or_Unintentionally)(Since_2014)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="52_Operator_Inexperience"]<- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="53_Unfamiliar_With_Roadway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="58_Over_Correcting"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="58_Over_Correcting"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="6_Careless_Driving_(Since_2012)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="8_Road_Rage/Aggressive_Driving_(Since_2004)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="73_Driver_Has_Not_Complied_with_Learners_Permit_or_Intermediate_Driver_License_Restrictions_(GDL_Restrictions_Since_2004)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="74_Driver_Has_Not_Complied_With_Physical_or_Other_Imposed_Restrictions_(Since_2004)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="77_Severe_Crosswind"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="79_Slippery_or_Loose_Surface"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="80_Tire_Blow-Out_or_Flat"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="82_Ruts_Holes_Bumps_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="84_Vehicle_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="85_Phantom_Vehicle"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="86_Pedestrian_Pedalcyclist_or_Other_Non-Motorist_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="87_Ice_Water_Snow_Slush_Sand_Dirt_Oil_Wet_Leaves_on_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="88_Trailer_Fishtailing_or_Swaying_(Since_2001)"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="89_Driver_has_a_Driving_Record_or_Drivers_License_from_More_than_One_State"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="91_Non-Traffic_Violation_Charged_(Manslaughter_Homicide_or_Other_Assault_Offense_Committed_Without_Malice_Since_1986)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="99_Unknown"] <- "Unknown"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="Looked_But_Did_Not_See_"] <- "Unknown"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="0_None"] <- "None"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="12_Mother_of_Dead_Fetus/Mother_of_Infant_Born_Post_Crash"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="13_Mentally_Challenged_(Since_1995)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="15_Seat_Back_Not_in_Normal_Position_Seat_Back_Reclined_(Since_2002)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="16_Police_or_Law_Enforcement_Officer_(Since_2002)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="18_Traveling_on_Prohibited_Trafficways_(Since_1995)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="20_Leaving_Vehicle_Unattended_with_Engine_Running;_Leaving_Vehicle_Unattended_in_Roadway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="23_Failing_to_Dim_Lights_or_to_Have_Lights_on_When_Required"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="30_Making_Improper_Entry_to_or_Exit_from_Trafficway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="31_Starting_or_Backing_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="32_Opening_Vehicle_Closure_into_Moving_Traffic_or_Vehicle_is_in_Motion"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="4_Reaction_to_or_Failure_to_Take_Drugs/Medication"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="40_Passing_Through_or_Around_Barrier"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="41_Failure_to_Observe_Warnings_or_Instructions_on_Vehicle_Displaying_Them"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="45_Driving_Less_Than_Posted_Maximum"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="50_Driving_Wrong_Way_on_One-Way_Trafficway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="54_Stopping_in_Roadway_(Vehicle_Not_Abandoned)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="55_Improper_Management_of_Vehicle_Controls"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="56_Object_Interference_with_Vehicle_Controls"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="57_Driving_with_Tire-Related_Problems"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="60_Alcohol_and/or_Drug_Test_Refused"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="81_Debris_or_Objects_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="83_Live_Animals_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="83_Live_Animals_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="Looked_But_Did_Not_See"] <- "Unknown" ##not in data dictionary
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="Emergency_Services_Personnel"] <- "Unknown" ##not in data dictionary
levels(df2.cat$veh_DR_SF1_nm)[levels(df2.cat$veh_DR_SF1_nm)=="59_Getting_Off/Out_of_a_Vehicle"] <- "Misc Factors"

#####################
# bin veh_DR_SF2_nm
#####################
summary(df2.cat$veh_DR_SF2_nm)

levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="19_Legally_Driving_on_Suspended_or_Revoked_License"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="21_Overloading_or_Improper_Loading_of_Vehicle_with_Passenger_or_Cargo"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="22_Towing_or_Pushing_Vehicle_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="24_Operating_Without_Required_Equipment"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="26_Following_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="27_Improper_or_Erratic_Lane_Changing"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="28_Improper_Lane_Usage"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="29_Intentional_Illegal_Driving_on_Road_Shoulder_in_Ditch_or_Sidewalk_or_on_Median_(Since_2014)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="33_Passing_Where_Prohibited_by_Posted_Signs_Pavement_Markings_or_School_Bus_Displaying_Warning_Not_to_Pass"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="34_Passing_on_Right_Side"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="35_Passing_with_Insufficient_Distance_or_Inadequate_Visibility_or_Failing_to_Yield_to_Overtaking_Vehicle"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="36_Operating_the_Vehicle_in_an_Erratic_Reckless_Careless_or_Negligent_Manner"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="37_Police_Pursuing_this_Driver_or_Police_Officer_in_Pursuit_(Since_1994)_(See_Police_Pursuits_in_Appendix_C:_Additional_Data_Element_Information)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="38_Failure_to_Yield_Right_of_Way"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="39_Failure_to_Obey_Actual_Traffic_Signs_Traffic_Control_Devices_or_Traffic_Officers_Failure_to_Observe_Safety_Zone_Traffic_Laws"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="42_Failure_to_Signal_Intentions"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="47_Making_Right_Turn_from_Left-Turn_Lane_or_Making_Left_Turn_from_Right-Turn_Lane"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="48_Making_Improper_Turn"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="51_Driving_on_Wrong_Side_of_Two-way_Trafficway_(Intentionally_or_Unintentionally)(Since_2014)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="52_Operator_Inexperience"]<- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="53_Unfamiliar_With_Roadway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="58_Over_Correcting"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="58_Over_Correcting"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="6_Careless_Driving_(Since_2012)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="8_Road_Rage/Aggressive_Driving_(Since_2004)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="73_Driver_Has_Not_Complied_with_Learners_Permit_or_Intermediate_Driver_License_Restrictions_(GDL_Restrictions_Since_2004)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="74_Driver_Has_Not_Complied_With_Physical_or_Other_Imposed_Restrictions_(Since_2004)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="77_Severe_Crosswind"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="79_Slippery_or_Loose_Surface"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="80_Tire_Blow-Out_or_Flat"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="82_Ruts_Holes_Bumps_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="84_Vehicle_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="85_Phantom_Vehicle"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="86_Pedestrian_Pedalcyclist_or_Other_Non-Motorist_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="87_Ice_Water_Snow_Slush_Sand_Dirt_Oil_Wet_Leaves_on_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="88_Trailer_Fishtailing_or_Swaying_(Since_2001)"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="89_Driver_has_a_Driving_Record_or_Drivers_License_from_More_than_One_State"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="91_Non-Traffic_Violation_Charged_(Manslaughter_Homicide_or_Other_Assault_Offense_Committed_Without_Malice_Since_1986)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="99_Unknown"] <- "Unknown"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="Looked_But_Did_Not_See_"] <- "Unknown"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="0_None"] <- "None"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="12_Mother_of_Dead_Fetus/Mother_of_Infant_Born_Post_Crash"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="13_Mentally_Challenged_(Since_1995)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="15_Seat_Back_Not_in_Normal_Position_Seat_Back_Reclined_(Since_2002)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="16_Police_or_Law_Enforcement_Officer_(Since_2002)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="18_Traveling_on_Prohibited_Trafficways_(Since_1995)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="20_Leaving_Vehicle_Unattended_with_Engine_Running;_Leaving_Vehicle_Unattended_in_Roadway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="23_Failing_to_Dim_Lights_or_to_Have_Lights_on_When_Required"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="30_Making_Improper_Entry_to_or_Exit_from_Trafficway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="31_Starting_or_Backing_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="32_Opening_Vehicle_Closure_into_Moving_Traffic_or_Vehicle_is_in_Motion"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="4_Reaction_to_or_Failure_to_Take_Drugs/Medication"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="40_Passing_Through_or_Around_Barrier"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="41_Failure_to_Observe_Warnings_or_Instructions_on_Vehicle_Displaying_Them"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="45_Driving_Less_Than_Posted_Maximum"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="50_Driving_Wrong_Way_on_One-Way_Trafficway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="54_Stopping_in_Roadway_(Vehicle_Not_Abandoned)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="55_Improper_Management_of_Vehicle_Controls"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="56_Object_Interference_with_Vehicle_Controls"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="57_Driving_with_Tire-Related_Problems"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="60_Alcohol_and/or_Drug_Test_Refused"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="81_Debris_or_Objects_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="83_Live_Animals_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="83_Live_Animals_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="Looked_But_Did_Not_See"] <- "Unknown" ##not in data dictionary
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="Emergency_Services_Personnel"] <- "Unknown" ##not in data dictionary
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="59_Getting_Off/Out_of_a_Vehicle"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF2_nm)[levels(df2.cat$veh_DR_SF2_nm)=="78_Wind_from_Passing_Truck"] <- "Skid Swerve Slide"



#####################
# bin veh_DR_SF3_nm
#####################
summary(df2.cat$veh_DR_SF3_nm)

levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="19_Legally_Driving_on_Suspended_or_Revoked_License"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="21_Overloading_or_Improper_Loading_of_Vehicle_with_Passenger_or_Cargo"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="22_Towing_or_Pushing_Vehicle_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="24_Operating_Without_Required_Equipment"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="26_Following_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="27_Improper_or_Erratic_Lane_Changing"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="28_Improper_Lane_Usage"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="29_Intentional_Illegal_Driving_on_Road_Shoulder_in_Ditch_or_Sidewalk_or_on_Median_(Since_2014)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="33_Passing_Where_Prohibited_by_Posted_Signs_Pavement_Markings_or_School_Bus_Displaying_Warning_Not_to_Pass"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="34_Passing_on_Right_Side"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="35_Passing_with_Insufficient_Distance_or_Inadequate_Visibility_or_Failing_to_Yield_to_Overtaking_Vehicle"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="36_Operating_the_Vehicle_in_an_Erratic_Reckless_Careless_or_Negligent_Manner"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="37_Police_Pursuing_this_Driver_or_Police_Officer_in_Pursuit_(Since_1994)_(See_Police_Pursuits_in_Appendix_C:_Additional_Data_Element_Information)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="38_Failure_to_Yield_Right_of_Way"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="39_Failure_to_Obey_Actual_Traffic_Signs_Traffic_Control_Devices_or_Traffic_Officers_Failure_to_Observe_Safety_Zone_Traffic_Laws"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="42_Failure_to_Signal_Intentions"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="47_Making_Right_Turn_from_Left-Turn_Lane_or_Making_Left_Turn_from_Right-Turn_Lane"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="48_Making_Improper_Turn"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="51_Driving_on_Wrong_Side_of_Two-way_Trafficway_(Intentionally_or_Unintentionally)(Since_2014)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="52_Operator_Inexperience"]<- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="53_Unfamiliar_With_Roadway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="58_Over_Correcting"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="58_Over_Correcting"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="6_Careless_Driving_(Since_2012)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="8_Road_Rage/Aggressive_Driving_(Since_2004)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="73_Driver_Has_Not_Complied_with_Learners_Permit_or_Intermediate_Driver_License_Restrictions_(GDL_Restrictions_Since_2004)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="74_Driver_Has_Not_Complied_With_Physical_or_Other_Imposed_Restrictions_(Since_2004)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="77_Severe_Crosswind"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="79_Slippery_or_Loose_Surface"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="80_Tire_Blow-Out_or_Flat"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="82_Ruts_Holes_Bumps_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="84_Vehicle_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="85_Phantom_Vehicle"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="86_Pedestrian_Pedalcyclist_or_Other_Non-Motorist_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="87_Ice_Water_Snow_Slush_Sand_Dirt_Oil_Wet_Leaves_on_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="88_Trailer_Fishtailing_or_Swaying_(Since_2001)"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="89_Driver_has_a_Driving_Record_or_Drivers_License_from_More_than_One_State"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="91_Non-Traffic_Violation_Charged_(Manslaughter_Homicide_or_Other_Assault_Offense_Committed_Without_Malice_Since_1986)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="99_Unknown"] <- "Unknown"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="Looked_But_Did_Not_See_"] <- "Unknown"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="0_None"] <- "None"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="12_Mother_of_Dead_Fetus/Mother_of_Infant_Born_Post_Crash"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="13_Mentally_Challenged_(Since_1995)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="15_Seat_Back_Not_in_Normal_Position_Seat_Back_Reclined_(Since_2002)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="16_Police_or_Law_Enforcement_Officer_(Since_2002)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="18_Traveling_on_Prohibited_Trafficways_(Since_1995)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="20_Leaving_Vehicle_Unattended_with_Engine_Running;_Leaving_Vehicle_Unattended_in_Roadway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="23_Failing_to_Dim_Lights_or_to_Have_Lights_on_When_Required"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="30_Making_Improper_Entry_to_or_Exit_from_Trafficway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="31_Starting_or_Backing_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="32_Opening_Vehicle_Closure_into_Moving_Traffic_or_Vehicle_is_in_Motion"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="4_Reaction_to_or_Failure_to_Take_Drugs/Medication"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="40_Passing_Through_or_Around_Barrier"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="41_Failure_to_Observe_Warnings_or_Instructions_on_Vehicle_Displaying_Them"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="45_Driving_Less_Than_Posted_Maximum"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="50_Driving_Wrong_Way_on_One-Way_Trafficway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="54_Stopping_in_Roadway_(Vehicle_Not_Abandoned)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="55_Improper_Management_of_Vehicle_Controls"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="56_Object_Interference_with_Vehicle_Controls"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="57_Driving_with_Tire-Related_Problems"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="60_Alcohol_and/or_Drug_Test_Refused"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="81_Debris_or_Objects_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="83_Live_Animals_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="83_Live_Animals_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="Looked_But_Did_Not_See"] <- "Unknown" ##not in data dictionary
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="Emergency_Services_Personnel"] <- "Unknown" ##not in data dictionary
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="59_Getting_Off/Out_of_a_Vehicle"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF3_nm)[levels(df2.cat$veh_DR_SF3_nm)=="78_Wind_from_Passing_Truck"] <- "Skid Swerve Slide"




#####################
#bin veh_DR_SF4_nm
#####################
summary(df2.cat$veh_DR_SF4_nm)

levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="19_Legally_Driving_on_Suspended_or_Revoked_License"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="21_Overloading_or_Improper_Loading_of_Vehicle_with_Passenger_or_Cargo"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="22_Towing_or_Pushing_Vehicle_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="24_Operating_Without_Required_Equipment"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="26_Following_Improperly"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="27_Improper_or_Erratic_Lane_Changing"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="28_Improper_Lane_Usage"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="29_Intentional_Illegal_Driving_on_Road_Shoulder_in_Ditch_or_Sidewalk_or_on_Median_(Since_2014)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="33_Passing_Where_Prohibited_by_Posted_Signs_Pavement_Markings_or_School_Bus_Displaying_Warning_Not_to_Pass"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="34_Passing_on_Right_Side"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="35_Passing_with_Insufficient_Distance_or_Inadequate_Visibility_or_Failing_to_Yield_to_Overtaking_Vehicle"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="36_Operating_the_Vehicle_in_an_Erratic_Reckless_Careless_or_Negligent_Manner"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="37_Police_Pursuing_this_Driver_or_Police_Officer_in_Pursuit_(Since_1994)_(See_Police_Pursuits_in_Appendix_C:_Additional_Data_Element_Information)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="38_Failure_to_Yield_Right_of_Way"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="39_Failure_to_Obey_Actual_Traffic_Signs_Traffic_Control_Devices_or_Traffic_Officers_Failure_to_Observe_Safety_Zone_Traffic_Laws"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="42_Failure_to_Signal_Intentions"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="47_Making_Right_Turn_from_Left-Turn_Lane_or_Making_Left_Turn_from_Right-Turn_Lane"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="48_Making_Improper_Turn"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="51_Driving_on_Wrong_Side_of_Two-way_Trafficway_(Intentionally_or_Unintentionally)(Since_2014)"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="52_Operator_Inexperience"]<- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="53_Unfamiliar_With_Roadway"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="58_Over_Correcting"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="58_Over_Correcting"] <- "Misc Factors"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="6_Careless_Driving_(Since_2012)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="8_Road_Rage/Aggressive_Driving_(Since_2004)"] <- "Physical Mental Cond"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="73_Driver_Has_Not_Complied_with_Learners_Permit_or_Intermediate_Driver_License_Restrictions_(GDL_Restrictions_Since_2004)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="74_Driver_Has_Not_Complied_With_Physical_or_Other_Imposed_Restrictions_(Since_2004)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="77_Severe_Crosswind"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="79_Slippery_or_Loose_Surface"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="80_Tire_Blow-Out_or_Flat"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="82_Ruts_Holes_Bumps_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="84_Vehicle_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="85_Phantom_Vehicle"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="86_Pedestrian_Pedalcyclist_or_Other_Non-Motorist_in_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="87_Ice_Water_Snow_Slush_Sand_Dirt_Oil_Wet_Leaves_on_Road"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="88_Trailer_Fishtailing_or_Swaying_(Since_2001)"] <- "Skid Swerve Slide"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="89_Driver_has_a_Driving_Record_or_Drivers_License_from_More_than_One_State"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="91_Non-Traffic_Violation_Charged_(Manslaughter_Homicide_or_Other_Assault_Offense_Committed_Without_Malice_Since_1986)"] <- "Spec Circumstances"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="99_Unknown"] <- "Unknown"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="Looked_But_Did_Not_See_"] <- "Unknown"
levels(df2.cat$veh_DR_SF4_nm)[levels(df2.cat$veh_DR_SF4_nm)=="0_None"] <- "None"

ncol(df2.cat)
#[1] 215
  
#####################
#bin veh_P_CRASH2_nm
#####################
summary(df2.cat$veh_P_CRASH2_nm)

##FARS Data Dictionary groups these into
##This vehicle loss of control
##This vehicle Traveling
##Other MV in Lane
##Other MV Encroaching into Lane
###Pedestrian or Pedalcyclist or other non-motorist
###Object or Animal
###Other

levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="1_Blow_Out/Flat_Tire"] <- "This MV loss of control"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="2_Stalled_Engine"] <- "This MV loss of control"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="3_Disabling_Vehicle_Failure_(e.g._Wheel_Fell_Off)"] <- "This MV loss of control"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="4_Poor_Road_Conditions_(Puddle_Pothole_Ice_etc.)"] <- "This MV loss of control"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="6_Traveling_Too_Fast_For_Conditions"] <- "This MV loss of control"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="8_Other_Cause_of_Control_Loss"] <- "This MV loss of control"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="9_Unknown_Cause_of_Control_Loss"] <- "This MV loss of control"

levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="10_Over_the_Lane_Line_on_Left_Side_of_Travel_Lane"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="11_Over_the_Lane_Line_on_Right_Side_of_Travel_Lane"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="12_Off_the_Edge_of_the_Road_on_the_Left_Side"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="13_Off_the_Edge_of_the_Road_on_the_Right_Side"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="14_End_Departure"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="15_Turning_Left_at_Junction"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="16_Turning_Right_at_Junction"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="17_Crossing_Over_(Passing_Through)_Intersection"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="18_This_Vehicle_Decelerating"] <- "This MV traveling"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="19_Unknown_Travel_Direction"] <- "This MV traveling"

levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="50_Other_Vehicle_Stopped"] <- "Other MV in lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="51_Traveling_In_Same_Direction_with_Lower_Steady_Speed"] <- "Other MV in lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="52_Traveling_In_Same_Direction_while_Decelerating"] <- "Other MV in lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="53_Traveling_In_Same_Direction_with_Higher_Speed"] <- "Other MV in lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="54_Traveling_In_Opposite_Direction"] <- "Other MV in lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="55_In_Crossover"] <- "Other MV in lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="56_Backing"] <- "Other MV in lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="59_Unknown_Travel_Direction_of_the_Other_Motor_Vehicle_in_Lane"] <- "Other MV in lane"

levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="60_From_Adjacent_Lane_(Same_Direction)_Over_Left_Lane_Line"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="61_From_Adjacent_Lane_(Same_Direction)_Over_Right_Lane_Line"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="62_From_Opposite_Direction_Over_Left_Lane_Line"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="63_From_Opposite_Direction_Over_Right_Lane_Line"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="64_From_Parking_Lane/Shoulder_Median/Crossover_Roadside"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="65_From_Crossing_Street_Turning_Into_Same_Direction"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="66_From_Crossing_Street_Across_Path"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="67_From_Crossing_Street_Turning_Into_Opposite_Direction"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="68_From_Crossing_Street_Intended_Path_Unknown"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="70_From_Driveway_Turning_Into_Same_Direction"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="71_From_Driveway_Across_Path"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="72_From_Driveway_Turning_Into_Opposite_Direction"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="73_From_Driveway_Intended_Path_Unknown"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="74_From_Entrance_to_Limited_Access_Highway"] <- "Other MV encroaching lane"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="78_Encroachment_by_Other_Vehicle_Details_Unknown"] <- "Other MV encroaching lane"

levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="81_Pedestrian_Approaching_Road"] <- "Ped Pedcyc Other Non-MV"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="82_Pedestrian_Unknown_Location"] <- "Ped Pedcyc Other Non-MV"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="83_Pedalcyclist/Other_Non-Motorist_in_Road"] <- "Ped Pedcyc Other Non-MV"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="84_Pedalcyclist/Other_Non-Motorist_Approaching_Road"] <- "Ped Pedcyc Other Non-MV"


levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="87_Animal_in_Road"] <- "Obj or Animal"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="88_Animal_Approaching_Road"] <- "Obj or Animal"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="89_Animal_Unknown_Location"] <- "Obj or Animal"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="90_Object_in_Road"] <- "Obj or Animal"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="91_Object_Approaching_Road"] <- "Obj or Animal"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="92_Object_Unknown_Location"] <- "Obj or Animal"

levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="98_Other_Critical_Precrash_Event"] <- "Other"
levels(df2.cat$veh_P_CRASH2_nm)[levels(df2.cat$veh_P_CRASH2_nm)=="99_Unknown"] <- "Other"

#####################
#bin veh_ACC_TYP_nm
#####################
summary(df2.cat$veh_ACC_TYP_nm)

##FARS Data Dictionary groups these into 
###Config A: Single Driver - Right Roadside Departure
###Config B: Single Driver - Left Roadside Departure
###COnfig C: Single Driver - Forward Impact
###Config D: Same Trafficway,Same Direction - Rear End
###Config E: Same Trafficway,Same Direction - Foward Impact
###Config F: Same Trafficway,Same Direction - Sidewipe/Angle
###Config G: Same Trafficway, Opposite Direction - Head-On
###Config H: Same Trafficway, Opposite Direction - Forward Impact
###Config I: Same Trafficway, Opposite Direction - Sideswipe Angle
###Config J: Changing Trafficway, Vehicle Turning - Turn Across Path
###Config K: Changing Trafficway, Vehicle Turning - Turn into Path
###Config L: Intersecting Paths (vehicle Damage) - Straight Paths
###Config M: Misc. - Backing
###Config M: Misc - Other
###No_Impact

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="1_Drive_Off_Road"] <- "A:SD-Right Departure"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="2_Control/Traction_Loss"] <- "A:SD-Right Departure"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="3_Avoid_Collision_with_Vehicle_Pedestrian_Animal"] <- "A:SD-Right Departure"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="4_Specifics_Other"] <- "A:SD-Right Departure"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="5_Specifics_Unknown"] <- "A:SD-Right Departure"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="6_Drive_Off_Road"] <- "B:SD-Left Departure"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="7_Control/Traction_Loss"] <- "B:SD-Left Departure"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="8_Avoid_Collision_With_Vehicle_Pedestrian_Animal"] <- "B:SD-Left Departure"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="9_Specifics_Other"] <- "B:SD-Left Departure"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="10_Specifics_Unknown"] <- "B:SD-Left Departure"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="11_Parked_Vehicle"] <- "C:SD-Fwd Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="12_Stationary_Object"] <- "C:SD-Fwd Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="13_Pedestrian/Animal"] <- "C:SD-Fwd Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="14_End_Departure"] <- "C:SD-Fwd Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="15_Specifics_Other"] <- "C:SD-Fwd Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="16_Specifics_Unknown"] <- "C:SD-Fwd Impact"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="20_Stopped"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="21_Stopped_Straight"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="22_Stopped_Left"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="23_Stopped_Right"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="24_Slower"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="25_Slower_Going_Straight"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="26_Slower_Going_Left"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="27_Slower_Going_Right"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="28_Decelerating_(Slowing)"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="29_Decelerating_(Slowing)_Going_Straight"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="30_Decelerating_(Slowing)_Going_Left"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="31_Decelerating_(Slowing)_Going_Right"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="32_Specifics_Other"] <- "D:STSD-Rear Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="33_Specifics_Unknown"] <- "D:STSD-Rear Impact"


levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="38_This_Vehicles_Frontal_Area_Impacts_Another_Vehicle."] <- "E:STSD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="39_This_Vehicle_Is_Impacted_by_Frontal_Area_of_Another_Vehicle"] <- "E:STSD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="41_This_Vehicle_Is_Impacted_by_Frontal_Area_of_Another_Vehicle"] <- "E:STSD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="42_Specifics_Other"] <- "E:STSD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="43_Specifics_Unknown"] <- "E:STSD-Forward Impact"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="44_Straight_Ahead_on_Left"] <- "F:STSD-Sideswipe Angle"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="45_Straight_Ahead_on_Left/Right"] <- "F:STSD-Sideswipe Angle"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="46_Changing_Lanes_to_the_Right"] <- "F:STSD-Sideswipe Angle"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="47_Changing_Lanes_to_the_Left"] <- "F:STSD-Sideswipe Angle"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="48_Specifics_Other"] <- "F:STSD-Sideswipe Angle"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="49_Specifics_Unknown"] <- "F:STSD-Sideswipe Angle"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="50_Lateral_Move_(Left/Right)"] <- "G:STOD-Head On"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="52_Specifics_Other"] <- "G:STOD-Head On"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="51_Lateral_Move_(Going_Straight)"] <- "G:STOD-Head On"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="53_Specifics_Unknown"] <- "G:STOD-Head On"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="54_This_Vehicles_Frontal_Area_Impacts_Another_Vehicle"] <- "H:STOD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="58_This_Vehicles_Frontal_Area_Impacts_Another_Vehicle"] <- "H:STOD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="59_This_Vehicle_Is_Impacted_by_Frontal_Area_of_Another_Vehicle"] <- "H:STOD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="61_This_Vehicle_Is_Impacted_by_Frontal_Area_of_Another_Vehicle"] <- "H:STOD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="62_Specifics_Other"] <- "H:STOD-Forward Impact"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="63_Specifics_Unknown"] <- "H:STOD-Forward Impact"


levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="64_Lateral_Move_(Left/Right)"] <- "I:STOD-Sideswipe Angle"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="65_Lateral_Move_(Going_Straight)"] <- "I:STOD-Sideswipe Angle"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="66_Specifics_Other"] <- "I:STOD-Sideswipe Angle"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="67_Specifics_Unknown"] <- "I:STOD-Sideswipe Angle"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="68_Initial_Opposite_Directions_(Left/Right)"] <- "J:CTVT-Turn Across Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="69_Initial_Opposite_Directions_(Going_Straight)"] <- "J:CTVT-Turn Across Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="70_Initial_Same_Directions_(Turning_Right)"] <- "J:CTVT-Turn Across Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="71_Initial_Same_Directions_(Going_Straight)"] <- "J:CTVT-Turn Across Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="72_Initial_Same_Directions_(Turning_Left)"] <- "J:CTVT-Turn Across Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="73_Initial_Same_Directions_(Going_Straight)"] <- "J:CTVT-Turn Across Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="74_Specifics_Other"] <- "J:CTVT-Turn Across Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="75_Specifics_Unknown"] <- "J:CTVT-Turn Across Path"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="76_Turn_Into_Same_Direction_(Turning_Left)"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="77_Turn_Into_Same_Direction_(Going_Straight)"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="78_Turn_Into_Same_Direction_(Turning_Right)"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="79_Turn_Into_Same_Direction_(Going_Straight)"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="80_Turn_Into_Opposite_Directions_(Turning_Right)"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="81_Turn_Into_Opposite_Directions_(Going_Straight)"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="82_Turn_Into_Opposite_Directions_(Turning_Left)"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="83_Turn_Into_Opposite_Directions_(Going_Straight)"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="84_Specifics_Other"] <- "K:CTVT-Turn Into Path"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="85_Specifics_Unknown"] <- "K:CTVT-Turn Into Path"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="86_Striking_from_the_Right"] <- "L:IPVD-Straight Paths"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="87_Struck_on_the_Right"] <- "L:IPVD-Straight Paths"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="88_Striking_from_the_Left"] <- "L:IPVD-Straight Paths"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="89_Struck_on_the_Left"] <- "L:IPVD-Straight Paths"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="90_Specifics_Other"] <- "L:IPVD-Straight Paths"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="91_Specifics_Unknown"] <- "L:IPVD-Straight Paths"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="92_Backing_Vehicle"] <- "M:Misc Backing"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="93_Other_Vehicle_(2013-Later)"] <- "M:Misc Other"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="98_Other_Crash_Type"] <- "M:Misc Other"
levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="99_Unknown_Crash_Type"] <- "M:Misc Other"

levels(df2.cat$veh_ACC_TYP_nm)[levels(df2.cat$veh_ACC_TYP_nm)=="No_Impact"] <- "No Impact"



############################
#per_DEATH_DA
############################
summary(df2.cat$per_DEATH_DA)
per_DEATH_DA_n<-as.numeric(as.character((df2.cat$per_DEATH_DA)))


df2.cat$per_DEATH_DA_bin<-cut(per_DEATH_DA_n, breaks=c(1,11,20,31),
                              labels=c("Month Beg","Month Mid","Month End"))


#replace NA's with category of "not known"
df2.cat$per_DEATH_DA_bin<-df2.cat$per_DEATH_DA_bin %>% fct_explicit_na(na_level = 'Not Known')
levels(df2.cat$per_DEATH_DA_bin)

#Remove original variable
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("per_DEATH_DA"))]

#number should not change as swapping one variable for a derived variable
ncol(df2.cat)
# [1] 215

###########
#veh_TRAV_SP
###########
#ddply(df2.cat,~ veh_TRAV_SP,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#majority are unknown, not reported and cannot impute
#turn into categorical variables by binning by quarters and assigning all unknown/unreported to another
#too many were not reported/unknown to be imputed and data is hi
df2.cat$veh_TRAV_SP[0<=df2.cat$veh_TRAV_SP & df2.cat$veh_TRAV_SP<=39] <- 1
df2.cat$veh_TRAV_SP[40<=df2.cat$veh_TRAV_SP & df2.cat$veh_TRAV_SP<=54]<-2
df2.cat$veh_TRAV_SP[55<=df2.cat$veh_TRAV_SP & df2.cat$veh_TRAV_SP<=65]<-3
df2.cat$veh_TRAV_SP[66<=df2.cat$veh_TRAV_SP & df2.cat$veh_TRAV_SP<=997]<-4 #997 is greater than 151
df2.cat$veh_TRAV_SP[df2.cat$veh_TRAV_SP>=998]<-0
df2.cat$veh_TRAV_SP_bin<-as.factor(df2.cat$veh_TRAV_SP)
levels(df2.cat$veh_TRAV_SP_bin) <- c(levels(df2.cat$veh_TRAV_SP_bin), c("Unknown, Not Reported", "0-39 mph", "40-54 mph","55-65 mph","66-151+ mph"))    # add new levels
levels(df2.cat$veh_TRAV_SP_bin)[levels(df2.cat$veh_TRAV_SP_bin)=="0"] <- "Unknown, Not Reported"
levels(df2.cat$veh_TRAV_SP_bin)[levels(df2.cat$veh_TRAV_SP_bin)=="1"] <- "0-39 mph"
levels(df2.cat$veh_TRAV_SP_bin)[levels(df2.cat$veh_TRAV_SP_bin)=="2"] <- "40-54 mph"
levels(df2.cat$veh_TRAV_SP_bin)[levels(df2.cat$veh_TRAV_SP_bin)=="3"] <- "55-65 mph"
levels(df2.cat$veh_TRAV_SP_bin)[levels(df2.cat$veh_TRAV_SP_bin)=="4"] <- "66-151+ mph"
#reset levels
df2.cat$veh_TRAV_SP_bin<-as.factor(df2.cat$veh_TRAV_SP_bin)
levels(df2.cat$veh_TRAV_SP_bin)
# [1] "Unknown, Not Reported" "0-39 mph"              "40-54 mph"             "55-65 mph"            
# [5] "66-151+ mph"

#remove original variable from dataframe
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_TRAV_SP"))]

ncol(df2.cat)
#215

###############
##veh_DR_HGT
###############
#ddply(df2.cat,~ veh_DR_HGT,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#over 7000 unknown or not reported
#bin by quartiles and assign all unreported/unknown to a category
df2.cat$veh_DR_HGT[36<=df2.cat$veh_DR_HGT & df2.cat$veh_DR_HGT<=65] <- 1
df2.cat$veh_DR_HGT[66<=df2.cat$veh_DR_HGT & df2.cat$veh_DR_HGT<=68]<-2
df2.cat$veh_DR_HGT[69<=df2.cat$veh_DR_HGT & df2.cat$veh_DR_HGT<=71]<-3
df2.cat$veh_DR_HGT[72<=df2.cat$veh_DR_HGT & df2.cat$veh_DR_HGT<=87]<-4 
df2.cat$veh_DR_HGT[df2.cat$veh_DR_HGT>=998]<-0
df2.cat$veh_DR_HGT_bin<-as.factor(df2.cat$veh_DR_HGT)
levels(df2.cat$veh_DR_HGT_bin) <- c(levels(df2.cat$veh_DR_HGT_bin), c("Unknown, Not Reported", "36-65 inches", "66-68 inches","69-71 inches","72-87 inches"))    # add new levels
levels(df2.cat$veh_DR_HGT_bin)[levels(df2.cat$veh_DR_HGT_bin)=="0"] <- "Unknown, Not Reported"
levels(df2.cat$veh_DR_HGT_bin)[levels(df2.cat$veh_DR_HGT_bin)=="1"] <- "36-65 inches"
levels(df2.cat$veh_DR_HGT_bin)[levels(df2.cat$veh_DR_HGT_bin)=="2"] <- "66-68 inches"
levels(df2.cat$veh_DR_HGT_bin)[levels(df2.cat$veh_DR_HGT_bin)=="3"] <- "69-71 inches"
levels(df2.cat$veh_DR_HGT_bin)[levels(df2.cat$veh_DR_HGT_bin)=="4"] <- "72-87 inches"
#reset levels
df2.cat$veh_DR_HGT_bin<-as.factor(df2.cat$veh_DR_HGT_bin)
levels(df2.cat$veh_DR_HGT_bin)
# [1] "Unknown, Not Reported" "36-65 inches"          "66-68 inches"          "69-71 inches"         
# [5] "72-87 inches"

#remove original variable from dataframe
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_DR_HGT"))]

ncol(df2.cat)
#215

###############
##veh_DR_WGT
###############
#ddply(df2.cat,~ veh_DR_WGT,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#over 18000 unknown or not reported and many rounded
#bin by quartiles and assign all unreported/unknown to a category
df2.cat$veh_DR_WGT[50<=df2.cat$veh_DR_WGT & df2.cat$veh_DR_WGT<=151] <- 1
df2.cat$veh_DR_WGT[152<=df2.cat$veh_DR_WGT & df2.cat$veh_DR_WGT<=180]<-2
df2.cat$veh_DR_WGT[181<=df2.cat$veh_DR_WGT & df2.cat$veh_DR_WGT<=216]<-3
df2.cat$veh_DR_WGT[217<=df2.cat$veh_DR_WGT & df2.cat$veh_DR_WGT<=571]<-4 
df2.cat$veh_DR_WGT[df2.cat$veh_DR_WGT>=997]<-0
df2.cat$veh_DR_WGT_bin<-as.factor(df2.cat$veh_DR_WGT)
levels(df2.cat$veh_DR_WGT_bin) <- c(levels(df2.cat$veh_DR_WGT_bin), c("Unknown, Not Reported", "50-151 pounds", "152-180 pounds","181-216 pounds","217-571 pounds"))    # add new levels
levels(df2.cat$veh_DR_WGT_bin)[levels(df2.cat$veh_DR_WGT_bin)=="0"] <- "Unknown, Not Reported"
levels(df2.cat$veh_DR_WGT_bin)[levels(df2.cat$veh_DR_WGT_bin)=="1"] <- "50-151 pounds"
levels(df2.cat$veh_DR_WGT_bin)[levels(df2.cat$veh_DR_WGT_bin)=="2"] <- "152-180 pounds"
levels(df2.cat$veh_DR_WGT_bin)[levels(df2.cat$veh_DR_WGT_bin)=="3"] <- "181-216 pounds"
levels(df2.cat$veh_DR_WGT_bin)[levels(df2.cat$veh_DR_WGT_bin)=="4"] <- "217-571 pounds"
#reset levels
df2.cat$veh_DR_WGT_bin<-as.factor(df2.cat$veh_DR_WGT_bin)
levels(df2.cat$veh_DR_WGT_bin)
# [1] "Unknown, Not Reported" "36-65 inches"          "66-68 inches"          "69-71 inches"         
# [5] "72-87 inches"
#remove original variable from dataframe
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_DR_WGT"))]

ncol(df2.cat)
#215

###############
##veh_FIRST_YR
###############
#ddply(df2,~ veh_FIRST_YR,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#over 30000 no record
#assign these to one category
#create an unknown category
#change remainder years to factors
str(df2.cat$veh_FIRST_YR)
df2.cat$veh_FIRST_YR_bin<-as.factor(df2.cat$veh_FIRST_YR)
levels(df2.cat$veh_FIRST_YR_bin) <- c(levels(df2.cat$veh_FIRST_YR_bin), c("Unknown", "No Record"))    # add new levels

levels(df2.cat$veh_FIRST_YR_bin)[levels(df2.cat$veh_FIRST_YR_bin)=="9999"] <- "Unknown"
levels(df2.cat$veh_FIRST_YR_bin)[levels(df2.cat$veh_FIRST_YR_bin)=="9998"] <- "Unknown"
levels(df2.cat$veh_FIRST_YR_bin)[levels(df2.cat$veh_FIRST_YR_bin)=="0"] <- "No Record"


#remove original variable
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_FIRST_YR"))]
ncol(df2.cat)
#[1] 203

###############
##veh_LAST_YR
###############
#ddply(df2,~ veh_LAST_YR,summarise,number_of_distinct_orders=length(unique(ï..Key)))

#over 30000 no record
#assign these to one category
#create an unknown category
#change remainder years to factors
#str(df2.cat$veh_LAST_YR)
df2.cat$veh_LAST_YR_bin<-as.factor(df2.cat$veh_LAST_YR)
levels(df2.cat$veh_LAST_YR_bin) <- c(levels(df2.cat$veh_LAST_YR_bin), c("Unknown", "No Record"))    # add new levels

levels(df2.cat$veh_LAST_YR_bin)[levels(df2.cat$veh_LAST_YR_bin)=="9999"] <- "Unknown"
levels(df2.cat$veh_LAST_YR_bin)[levels(df2.cat$veh_LAST_YR_bin)=="9998"] <- "Unknown"
levels(df2.cat$veh_LAST_YR_bin)[levels(df2.cat$veh_LAST_YR_bin)=="0"] <- "No Record"


#remove original variable
df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_LAST_YR"))]
ncol(df2.cat)
#[1] 215



###################################
#remove unused factor level
###################################
df2.cat$acc_RD_OWNER_nm<-factor(df2.cat$acc_RD_OWNER_nm)
levels(df2.cat$acc_RD_OWNER_nm)

df2.cat$acc_FUNC_SYS_nm<-factor(df2.cat$acc_FUNC_SYS_nm)
levels(df2.cat$acc_FUNC_SYS_nm)

levels(df2.cat$acc_FUNC_SYS_nm)[levels(df2.cat$acc_FUNC_SYS_nm)=="NULL"] <- "Not Reported 99 Unknown"
levels(df2.cat$acc_FUNC_SYS_nm)[levels(df2.cat$acc_FUNC_SYS_nm)=="Principal Arterial ï¿½ Other "] <- "Principal Arterial Other"
levels(df2.cat$acc_FUNC_SYS_nm)[levels(df2.cat$acc_FUNC_SYS_nm)=="Principal Arterial ï¿½ Other Freeways and Expressways"] <- "Principal Arterial Other Freeways and Expressways"
levels(df2.cat$acc_FUNC_SYS_nm)[levels(df2.cat$acc_FUNC_SYS_nm)=="40_Other_Public_Instrumentality_(i.e.__Airport)"] <- "40_Other_Public_Instrumentality"
levels(df2.cat$acc_FUNC_SYS_nm)

ncol(df2.cat)
#[1] 214

###################################
#save df2.cat as RDS file
###################################


saveRDS(df2.cat, "1a - Final Code/Fixed Code/Data/df2_cat.rds")
dim(df2.cat)
# 57862   214

###########################################################################
##Evaluate Continuous Variables
###########################################################################

############################
#Identify continuous variables
############################
df.cont<-df2[,c( "key","acc_PEDS", "acc_PERNOTMVIT", "acc_VE_TOTAL",
                                      "acc_VE_FORMS", "acc_PVH_INVL", "acc_PERSONS", "acc_PERMVIT",
                                       "acc_FATALS", "acc_DRUNK_DR","veh_NUMOCCS",
                                      "veh_DEATHS", "per_LAG_HRS",  "per_LAG_MINS",
                                      "per_AGE", "oth_veh_PREV_OTH",
                                      "oth_veh_PREV_SPD","oth_veh_PREV_DWI","oth_veh_PREV_ACC","veh_PREV_ACC","veh_PREV_DWI", 
                                      "veh_PREV_SPD","veh_PREV_OTH", "veh_prev_sus", "oth_veh_prev_sus")]

#originally considered as continuous, but binned instead due to number of unreported/unknown
#or sparse information
#veh_TRAV_SP","veh_DR_HGT","veh_DR_WGT", 

#removed for now as need to address sql
#"veh_prev_sus", "oth_veh_prev_sus"
ncol(df.cont)
#[1] 25


##########################
##make continuous variables numeric
##########################
df.cont$acc_DRUNK_DR<-as.numeric(df.cont$acc_DRUNK_DR)
df.cont$acc_FATALS<-as.numeric(df.cont$acc_FATALS)
df.cont$acc_PEDS<-as.numeric(df.cont$acc_PEDS)
df.cont$acc_PERMVIT<-as.numeric(df.cont$acc_PERMVIT)
df.cont$acc_PERNOTMVIT<-as.numeric(df.cont$acc_PERNOTMVIT)
df.cont$acc_PERSONS<-as.numeric(df.cont$acc_PERSONS)
df.cont$acc_PVH_INVL<-as.numeric(df.cont$acc_PVH_INVL)
df.cont$acc_VE_FORMS<-as.numeric(df.cont$acc_VE_FORMS)
df.cont$acc_VE_TOTAL<-as.numeric(df.cont$acc_VE_TOTAL)
df.cont$oth_veh_PREV_ACC<-as.numeric(df.cont$oth_veh_PREV_ACC)
df.cont$oth_veh_PREV_DWI<-as.numeric(df.cont$oth_veh_PREV_DWI)
df.cont$oth_veh_PREV_OTH<-as.numeric(df.cont$oth_veh_PREV_OTH)
df.cont$oth_veh_PREV_SPD<-as.numeric(df.cont$oth_veh_PREV_SPD)
df.cont$veh_DEATHS<-as.numeric(df.cont$veh_DEATHS)
df.cont$per_LAG_MINS<-as.numeric(df.cont$per_LAG_MINS)
df.cont$per_LAG_HRS<-as.numeric(df.cont$per_LAG_HRS)

###########################
##Prep continuous variables
###########################

############
#veh_NUMOCCS
############
##look at unique values and counts per value
ddply(df,~veh_NUMOCCS,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#values range 1-18 heavily weighted towards 1, 91 records are unknown (99)
##impute 91 unknown records as 1 as most frequently occurring
df.cont$veh_NUMOCCS[df.cont$veh_NUMOCCS==99] <- 1

summary(df.cont$veh_NUMOCCS)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.000   1.000   1.000   1.624   2.000  18.000

###############
##per_AGE
###############
ddply(df,~ per_AGE,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#over 67 unknown
#impute with mean
#keep as continuous
df.cont$per_AGE<-df.cont$per_AGE
df.cont$per_AGE[df.cont$per_AGE>=998]<-50
summary(df.cont$per_AGE)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.00   26.00   41.00   43.63   59.00  105.00 

###############
##"per_LAG_HRS",  "per_LAG_MINS"
###############
#ddply(df2,~ per_LAG_HRS,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#summary(df2.cont$per_LAG_HRS)
#summary(df2.cont$per_LAG_MINS)

#convert mins to decimal of hour
df.cont$per_LAG_MINS_as_HR<-df.cont$per_LAG_MINS/60
#if above is greater than 1, meaning the value was 99 Unknown, change value to 0
df.cont$per_LAG_MINS_as_HR[df.cont$per_LAG_MINS_as_HR>=1]<-0
summary(df.cont$per_LAG_MINS_as_HR)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.0000  0.0000  0.1500  0.2620  0.4667  0.9833
#combine with lag_hrs
df.cont$per_LAG_HRS_dv<-df.cont$per_LAG_HRS+df.cont$per_LAG_MINS_as_HR
#if above is >= 719, the max defined per data dictionary
#create temp var that removes these to then find quartiles
df.contdv<-df.cont$per_LAG_HRS_dv[df.cont$per_LAG_HRS_dv<=719]
summary(df.contdv)
#    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# 0.0000   0.0000   0.3167  24.6078   1.6833 718.7167

#find out how many are unknown
count_if(999, df.cont$per_LAG_HRS)
#[1] 3697
3697/57862
#0.0638934
#Impute with median as mean looks skewed
df.cont$per_LAG_HRS_dv[df.cont$per_LAG_HRS_dv==999]<-0.3167
summary(df.cont$per_LAG_HRS_dv)
# Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
# 0.0000   0.0000   0.3167  23.0678   1.4333 719.0833

#remove original lag hour variable, lag mins variable and temp variables
df.cont<-df.cont[, -which(names(df.cont) %in% c("per_LAG_HRS","per_LAG_MINS","per_LAG_MINS_as_HR"))]
ncol(df.cont)
#[1] 24

summary(df.cont$oth_veh_PREV_ACC)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.0000  0.0000  0.0000  0.6303  0.0000 18.0000 

###############
##veh_PREV_ACC
###############
#ddply(df,~ veh_PREV_ACC,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#over 6000 unknown or not reported

#Impute with most frequently occuring value of 0
df.cont$veh_PREV_ACC[df.cont$veh_PREV_ACC==98]<-0
df.cont$veh_PREV_ACC[df.cont$veh_PREV_ACC==99]<-0
df.cont$veh_PREV_ACC[df.cont$veh_PREV_ACC==998]<-0

#bin by quartiles and assign all unreported/unknown to a category
# df2.cat$veh_PREV_ACC[2<=df2.cat$veh_PREV_ACC & df2.cat$veh_PREV_ACC<=12] <- 2
# df2.cat$veh_PREV_ACC[df2.cat$veh_PREV_ACC>=98]<-3
# df2.cat$veh_PREV_ACC_bin<-as.factor(df2.cat$veh_PREV_ACC)
# levels(df2.cat$veh_PREV_ACC_bin) <- c(levels(df2.cat$veh_PREV_ACC_bin), c("Unknown, Not Reported", "0", "1","2+"))    # add new levels
# levels(df2.cat$veh_PREV_ACC_bin)[levels(df2.cat$veh_PREV_ACC_bin)=="3"] <- "Unknown, Not Reported"
# levels(df2.cat$veh_PREV_ACC_bin)[levels(df2.cat$veh_PREV_ACC_bin)=="0"] <- "0"
# levels(df2.cat$veh_PREV_ACC_bin)[levels(df2.cat$veh_PREV_ACC_bin)=="1"] <- "1"
# levels(df2.cat$veh_PREV_ACC_bin)[levels(df2.cat$veh_PREV_ACC_bin)=="2"] <- "2+"
# #reset levels
# df2.cat$veh_PREV_ACC_bin<-as.factor(df2.cat$veh_PREV_ACC_bin)
# levels(df2.cat$veh_PREV_ACC_bin)
# #[1] "0"                     "1"                     "2+"                    "Unknown, Not Reported"
# #remove original variable from dataframe
# df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_PREV_ACC"))]

###############
##veh_PREV_DWI
###############
#ddply(df,~ veh_PREV_DWI,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#over 1100 unknown or not reported


df.cont$veh_PREV_DWI[df.cont$veh_PREV_DWI==99]<-0
df.cont$veh_PREV_DWI[df.cont$veh_PREV_DWI==998]<-0

#bin by quartiles and assign all unreported/unknown to a category
# df2.cat$veh_PREV_DWI[1<=df2.cat$veh_PREV_DWI & df2.cat$veh_PREV_DWI<=7] <- 2
# df2.cat$veh_PREV_DWI[df2.cat$veh_PREV_DWI>=99]<-3
# df2.cat$veh_PREV_DWI_bin<-as.factor(df2.cat$veh_PREV_DWI)
# levels(df2.cat$veh_PREV_DWI_bin) <- c(levels(df2.cat$veh_PREV_DWI_bin), c("Unknown, Not Reported", "0", "1+"))    # add new levels
# levels(df2.cat$veh_PREV_DWI_bin)[levels(df2.cat$veh_PREV_DWI_bin)=="3"] <- "Unknown, Not Reported"
# levels(df2.cat$veh_PREV_DWI_bin)[levels(df2.cat$veh_PREV_DWI_bin)=="0"] <- "0"
# levels(df2.cat$veh_PREV_DWI_bin)[levels(df2.cat$veh_PREV_DWI_bin)=="2"] <- "1+"
# #reset levels
# df2.cat$veh_PREV_DWI_bin<-as.factor(df2.cat$veh_PREV_DWI_bin)
# levels(df2.cat$veh_PREV_DWI_bin)
# #[1] "0"                     "1+"                    "Unknown, Not Reported"
# 
# 
# #remove original variable from dataframe
# df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_PREV_DWI"))]


###############
##veh_PREV_SPD
###############
#ddply(df2,~ veh_PREV_SPD,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#over 1102 unknown or not reported and many rounded


df.cont$veh_PREV_SPD[df.cont$veh_PREV_SPD==99]<-0
df.cont$veh_PREV_SPD[df.cont$veh_PREV_SPD==998]<-0

#bin by quartiles and assign all unreported/unknown to a category
# df2.cat$veh_PREV_SPD[1<=df2.cat$veh_PREV_SPD & df2.cat$veh_PREV_SPD<=2] <- 1
# df2.cat$veh_PREV_SPD[3<=df2.cat$veh_PREV_SPD & df2.cat$veh_PREV_SPD<=10]<-2
# df2.cat$veh_PREV_SPD[df2.cat$veh_PREV_SPD>=99]<-0
# df2.cat$veh_PREV_SPD_bin<-as.factor(df2.cat$veh_PREV_SPD)
# levels(df2.cat$veh_PREV_SPD_bin) <- c(levels(df2.cat$veh_PREV_SPD_bin), c("Unknown, Not Reported", "1-2", "3-10"))    # add new levels
# levels(df2.cat$veh_PREV_SPD_bin)[levels(df2.cat$veh_PREV_SPD_bin)=="0"] <- "Unknown, Not Reported"
# levels(df2.cat$veh_PREV_SPD_bin)[levels(df2.cat$veh_PREV_SPD_bin)=="1"] <- "1-2"
# levels(df2.cat$veh_PREV_SPD_bin)[levels(df2.cat$veh_PREV_SPD_bin)=="2"] <- "3-10"
# #reset levels
# df2.cat$veh_PREV_SPD_bin<-as.factor(df2.cat$veh_PREV_SPD_bin)
# levels(df2.cat$veh_PREV_SPD_bin)
# #[1] "Unknown, Not Reported" "1-2"                   "3-10"       
# #remove original variable
# df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_PREV_SPD"))]

###############
##veh_PREV_OTH
###############
#ddply(df2,~ veh_PREV_OTH,summarise,number_of_distinct_orders=length(unique(ï..Key)))
#over 1000 unknown or not reported and many rounded

df.cont$veh_PREV_OTH[df.cont$veh_PREV_OTH==99]<-0
df.cont$veh_PREV_OTH[df.cont$veh_PREV_OTH==998]<-0


#bin by quartiles and assign all unreported/unknown to a category
# df2.cat$veh_PREV_OTH[1<=df2.cat$veh_PREV_OTH & df2.cat$veh_PREV_OTH<=2] <- 1
# df2.cat$veh_PREV_OTH[3<=df2.cat$veh_PREV_OTH & df2.cat$veh_PREV_OTH<=23]<-2
# df2.cat$veh_PREV_OTH[df2.cat$veh_PREV_OTH>=99]<-0
# df2.cat$veh_PREV_OTH_bin<-as.factor(df2.cat$veh_PREV_OTH)
# levels(df2.cat$veh_PREV_OTH_bin) <- c(levels(df2.cat$veh_PREV_OTH_bin), c("Unknown, Not Reported", "1-2", "3-23"))    # add new levels
# levels(df2.cat$veh_PREV_OTH_bin)[levels(df2.cat$veh_PREV_OTH_bin)=="0"] <- "Unknown, Not Reported"
# levels(df2.cat$veh_PREV_OTH_bin)[levels(df2.cat$veh_PREV_OTH_bin)=="1"] <- "1-2"
# levels(df2.cat$veh_PREV_OTH_bin)[levels(df2.cat$veh_PREV_OTH_bin)=="2"] <- "3-23"
# #reset levels
# df2.cat$veh_PREV_OTH_bin<-as.factor(df2.cat$veh_PREV_OTH_bin)
# levels(df2.cat$veh_PREV_OTH_bin)
# #[1] "Unknown, Not Reported" "1-2"                   "3-23"      
# #remove original variable
# df2.cat<-df2.cat[, -which(names(df2.cat) %in% c("veh_PREV_OTH"))]



############################
#veh_prev_sus
############################
summary(df$veh_prev_sus)
##negative numbers indicate unknown
ddply(df2,~ veh_prev_sus,summarise,number_of_distinct_orders=length(unique(key)))
#1088 unknown.  Assign to most frequent value 0.
df.cont$veh_prev_sus[df.cont$veh_prev_sus==-1]<-0


############################
#oth_veh_prev_sus
############################
summary(df$oth_veh_prev_sus)
##negative numbers indicate unknown
ddply(df2,~ oth_veh_prev_sus,summarise,number_of_distinct_orders=length(unique(key)))
#1088 unknown.  Assign to most frequent value 0.
df.cont$oth_veh_prev_sus[df.cont$veh_prev_sus<=-1]<-0

#############################
##create rds file for df.cont
#############################


saveRDS(df.cont,"1a - Final Code/Fixed Code/Data/df_cont_key.rds")

#############################
#Build Table that holds categorical and continuous variables
#############################
#merge the categorical and continuous data frames
df2.merge<-merge(df2.cat, df.cont, by=c("key"))
dim(df2.merge)
# 57862   237


#write file of names to compare to data dictionary and reconcile counts
write.csv(names(df2.merge),"1a - Final Code/Fixed Code/Data Exploration/names_df2_merge.csv")

saveRDS(df2.merge,"1a - Final Code/Fixed Code/Data/df2_merge_key.rds")

##############################
##create data summary
##############################

#produces html file
print(dfSummary(df2.merge),method = "browser" , file = "dfsummary.html")

############################
#Run correlation
#Use Pearson's correlation coefficient for 2 continuous variables
#Use Cramer's V for 2 categorical variables
#use multiple correlation coefficient for a continous and ctegorical variable
############################

corr<-assoc(df2.merge)

#write values to file
write.csv(corr$value, "1a - Final Code/Fixed Code/Data Exploration/corr_value.csv")

#write p-value to file
write.csv(corr$p.value, "1a - Final Code/Fixed Code/Data Exploration/corr_p_value.csv")

#write type (method) to file
write.csv(corr$type, "1a - Final Code/Fixed Code/Data Exploration/corr_type.csv")


#############################
##Create final data set
##removing duplicative data
##where correlation is 1
#############################

##although perfect correlation found, the values present for each variable are different
##since random forest / decision trees are not impacted by multicollinearity, they are retained

#look at distrubtion of veh_BODY_TYP_nm_bin_med_rural_fatal

veh_body_type<- df2.merge %>%
  select(c("veh_BODY_TYP_nm_bin", "veh_BODY_TYP_nm", "acc_aux_A_RU_nm"))%>%
  group_by(veh_BODY_TYP_nm_bin, veh_BODY_TYP_nm, acc_aux_A_RU_nm)%>%
  dplyr::summarise(n())

write.csv(veh_body_type, "1a - Final Code/Fixed Code/Data Exploration/veh_body_type.csv")


bivariate<-df2.merge %>%
  select(c("acc_aux_A_RU_nm", "acc_DAY_WEEK_nm", "veh_VTRAFWAY_nm", "acc_aux_A_RD_nm", "veh_MAK_MOD_bin"))
write.csv(bivariate, "1a - Final Code/Fixed Code/Data Exploration/bivariate2.csv")
    
df2.merge$acc_DAY_WEEK_nm

