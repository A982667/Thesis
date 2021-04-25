#prep###############

library(ggplot2)
library(ggrepel)
library(dplyr)
library("rnaturalearth")
library("rnaturalearthdata")
library("maps")
library(scales)
library(sf)
library(data.table)
library(choroplethrMaps)
library(RColorBrewer)


#Set working directory
setwd("H:/CCSU/Thesis")

#take final file prior to splitting for to test and train for model prepration
df2_merge_key_2<-readRDS("1a - Final Code/Fixed Code/Data/df2_merge_key.rds")
dim(df2_merge_key_2)
# 57862   237


#################################Map Percent Rural Fatal MVA's by State #########################################

map_1 <- df2_merge_key_2 

map_2<-data.frame(table(map_1$acc_aux_STATE_nm,map_1$acc_aux_A_RU_nm))
state.fatal<-dcast(map_2, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)

#Calc total fatalities by state
state.fatal$total<-state.fatal$Rural + state.fatal$Urban

#Calc percent rural
state.fatal$per_rur<-state.fatal$Rural/state.fatal$total

#create same column name
state.fatal$acc_aux_STATE_nm<-state.fatal$Var1
dim(state.fatal)
# 51  6


MainStates <- map_data("state")
dim(MainStates)
length(unique(MainStates$region))
# 49

# Use the dplyr package to merge the MainStates and state.fatal files
MergedStates <- merge(MainStates, state.fatal, by.x=c("region") , by.y=c("acc_aux_STATE_nm"), all.x=TRUE)
dim(MergedStates)
# 15537    11

#plot map

#create label dataframes
MergedStates_label<- MergedStates %>%
  select("region","per_rur", "long","lat")  %>%
  group_by(region, per_rur, "long","lat") %>%
  summarise(n())
dim(MergedStates_label)
# 49  5

#add lat long
lat_long<-read.csv("1a - Final Code/Heatmap/State Lat Long.csv")

MergedStates_label<-merge(MergedStates_label, lat_long, by=c("region"), all.x=TRUE)

##create separate dataframe for small States 
MergedStates_label_small<-MergedStates_label[MergedStates_label$region=="massachusetts" | MergedStates_label$region=="rhode island" | MergedStates_label$region=="connecticut" | 
                                               MergedStates_label$region=="new jersey" | MergedStates_label$region=="delaware" | MergedStates_label$region=="maryland" | MergedStates_label$region=="district of columbia" ,]

##create separate dataframe for other states - to seperate how labels are handled
MergedStates_label_large<-MergedStates_label[(MergedStates_label$region!="massachusetts" & MergedStates_label$region!="rhode island" & MergedStates_label$region!="connecticut" & 
                                                MergedStates_label$region!="new jersey" & MergedStates_label$region!="delaware" & MergedStates_label$region!="maryland" & MergedStates_label$region!="district of columbia") &
                                               MergedStates_label$region!="vermont" & MergedStates_label$region!="maine"
                                             & MergedStates_label$region!="montana" & MergedStates_label$region!="north dakota"
                                             & MergedStates_label$region!="south dakota",]

##create separate dataframe for states where dark color hides label - to seperate how labels are handled
MergedStates_label_special_2<-MergedStates_label[(MergedStates_label$region=="montana" | MergedStates_label$region=="north dakota" | MergedStates_label$region=="south dakota" |
                                                    MergedStates_label$region=="maine" |MergedStates_label$region=="vermont") ,]



p <- ggplot()
p <- p + geom_polygon( data=MergedStates, 
                       aes(x=long, y=lat, group=group, fill = per_rur), 
                       color="white", size = 0.2) +
  labs(title="Percent Rural Fatal MVA's by State") +
  scale_fill_continuous(name="Percent", 
                        low = "lightblue", high = "darkblue",limits = c(0,1), 
                        breaks=c(0.0 , .25, .5, .75, 1.00), na.value = "grey50", labels=scales::percent_format()) +
  theme(legend.position="bottom", legend.title = element_text(size=8)) +
  #labels for small states
  geom_text_repel(data=MergedStates_label_small,  nudge_y=-1, nudge_x=2,#point.padding = NA,
                  aes(x=Longitude, y=Latitude, label = paste(scales::percent_format(accuracy=2)(per_rur)), fontface = "bold"),
                  size = 3.3) + theme(legend.position="bottom", legend.title = element_text(size=14)) +
  #labels for large states
  geom_text(data=MergedStates_label_large,
            aes(x=Longitude, y=Latitude, label = paste(scales::percent_format(accuracy=2)(per_rur)), fontface = "bold"),
            size = 3.3) + theme(legend.position="bottom", legend.title = element_text(size=14)) +
  #labels for other states
  geom_text(data=MergedStates_label_special_2,
            aes(x=Longitude, y=Latitude, label = paste(scales::percent_format(accuracy=2)(per_rur)), fontface = "bold"),
            size = 3.3, color="white") + theme(legend.position="bottom", legend.title = element_text(size=14))
p


############################ Region only - no representation of rural ##################
map_4<- map_1 %>% select (c("acc_aux_STATE_nm", "acc_aux_A_REGION_nm")) %>%
  group_by(acc_aux_STATE_nm, acc_aux_A_REGION_nm)  %>%
  summarise(n())


MainStates <- map_data("state")

# Use the dplyr package to merge the MainStates and StatePopulation files
MergedRegion <- merge(MainStates, map_4, by.x=c("region") , by.y=c("acc_aux_STATE_nm"))
# str(MergedStates)

#plot map
p4 <- ggplot()
p4<- p4 + geom_polygon( data=MergedRegion, 
                       aes(x=long, y=lat, group=group, fill = acc_aux_A_REGION_nm), 
                       color="white", size = 0.2) +
  labs(title="NHTSA Regions") +
  # scale_fill_continuous(name="Percent", 
  #                       low = "lightblue", high = "darkblue", na.value = "grey50", labels = percent) +
  theme(legend.position="right", legend.title = element_text(size=8))
p4



################## Region data with % Rural Fatal Accidents #################################
#Not working
# map_5<-data.frame(table(map_1$acc_aux_A_REGION_nm,map_1$acc_aux_A_RU_nm))
# region.fatal<-dcast(map_5, Var1~Var2,value.var="Freq", fill =0,fun.aggregate = sum)
# 
# #Calc total fatalities by region
# region.fatal$total<-region.fatal$Rural + region.fatal$Urban
# 
# #Calc percent rural
# region.fatal$per_rur<-region.fatal$Rural/region.fatal$total
# 
# #create same column name
# region.fatal$acc_aux_A_REGION_nm<-region.fatal$Var1
# dim(region.fatal)
# # 10  6
# 
# #add back State
# state_reg<-map_1 %>%
#   select("acc_aux_A_REGION_nm", "acc_aux_STATE_nm" ) %>%
#   group_by(acc_aux_A_REGION_nm, acc_aux_STATE_nm) %>%
#   summarise(n())
# 
# region.fatal<-merge(region.fatal, state_reg, by.x=c("Var1"),by.y=c("acc_aux_A_REGION_nm") )
# 
# region.fatal$fill<-ifelse(region.fatal$acc_aux_A_REGION_nm=="AK_ID_MT_OR_WA",'grey42',
#                           ifelse(region.fatal$acc_aux_A_REGION_nm=="AL_FL_GA_SC_TN", 'grey72',
#                                  ifelse(region.fatal$acc_aux_A_REGION_nm=="AR_IA_KS_NE_MO",'grey47',
#                                         ifelse(region.fatal$acc_aux_A_REGION_nm=="AR_IA_KS_NE_MO",'grey62',
#                                                ifelse(region.fatal$acc_aux_A_REGION_nm=="AZ_CA_HI",'grey92',
#                                                       ifelse(region.fatal$acc_aux_A_REGION_nm=="CO_NV_ND_SD_WY_UT", "grey57",
#                                                              ifelse(region.fatal$acc_aux_A_REGION_nm=="CT_ME_MA_NH_RI_VT", "grey82",
#                                                                     ifelse(region.fatal$acc_aux_A_REGION_nm=="DE_DC_KY_MD_NC_VA_WV","grey52",
#                                                                            ifelse(region.fatal$acc_aux_A_REGION_nm=="IL_IN_MI_MN_OH_WI","grey62",
#                                                                                   ifelse(region.fatal$acc_aux_A_REGION_nm=="LA_MS_NM_OK_TX","grey67",
#                                                                                          ifelse(region.fatal$acc_aux_A_REGION_nm=="NJ_NY_PA_PR","grey77", "mediumaquamarine")))))))))))
# 
# MainStates <- map_data("state")
# dim(MainStates)
# # 15537     6
# length(unique(MainStates$region))
# # 49
# 
# # Use the dplyr package to merge the MainStates and state.fatal files
# MergedStates <- merge(MainStates, region.fatal, by.x=c("region") , by.y=c("acc_aux_STATE_nm"), all.x=TRUE)
# dim(MergedStates)
# # 15537    14
# 
# #plot map
# 
# 
# 
# p5 <- ggplot()
# p5 <- p5 + geom_polygon(data=MergedStates, 
#                        aes(x=long, y=lat, group=group, fill = per_rur), 
#                        color=MergedStates$border, size = 0.2) +
#   labs(title="Percent Rural Fatal MVA's by NHTSA Region") +
#   scale_fill_continuous(name="Percent", 
#                         low = "lightblue", high = "darkblue",limits = c(0,1), 
#                         breaks=c(0.0 , .25, .5, .75, 1.00), na.value = "grey50", labels=scales::percent_format()) +
#   theme(legend.position="bottom", legend.title = element_text(size=8)) +
#   scale_color_discrete(name = "acc_aux_A_REGION_nm") 
# p5





################# Actual Location of Urban/Rural ###################################################
df_orig<-read.csv("2-Data/raw_final_desc.csv")


combine_df_orig<-merge(df2_merge_key_2, df_orig, by.x=c("key"), by.y=c("ï..Key"), all.x=TRUE)
dim(combine_df_orig)
# 57862   483

#separate df for rural vs urban
rural<-combine_df_orig %>% 
  filter(acc_aux_A_RU_nm.x=="Rural")
dim(rural)
# 30107   483

rural <- subset(rural, acc_LONGITUD!=999.99990 &  acc_LONGITUD!=888.88880 & acc_LONGITUD!=777.77770)
dim(rural)
# 29930   483
rural<-rural %>%
  filter(acc_aux_STATE_nm.x!="alaska" & acc_aux_STATE_nm.x!="hawaii")
dim(rural)
# 29826   483

urban<-combine_df_orig %>%
  filter(acc_aux_A_RU_nm.x=="Urban")
urban <- subset(urban, acc_LONGITUD!=999.99990 &  acc_LONGITUD!=888.88880 & acc_LONGITUD!=777.77770)
urban<-subset(urban, acc_aux_STATE_nm.x!="alaska" & acc_aux_STATE_nm.x!="hawaii")
dim(urban)
# 27490   483

state_map <- map_data("state")

map<-ggplot() + 
  #Add county borders:
  #geom_polygon(data=county_map_data, aes(x=long,y=lat,group=group), colour = alpha("grey", 1/4), size = 0.2, fill = NA) +
  #Add state borders:
  geom_polygon(data = MergedStates, aes(x=long,y=lat,group=group), colour = "black", fill = MergedStates$fill) +
  #Add points (one per fatality) Rural:
  geom_point(data=rural, aes(x=acc_LONGITUD, y=acc_LATITUDE), alpha=0.05, size=0.7, col="red") +
  #Add points (one per fatality) Rural:
  geom_point(data=urban, aes(x=acc_LONGITUD, y=acc_LATITUDE), alpha=0.05, size=0.7, col="blue") +
  #Adjust the map projection
  coord_map("albers",lat0=30, lat1=40) +
  #Add a title:
  ggtitle("Rural (Red) and Urban (Blue) Traffic Fatalities") 
#Adjust the theme:
theme_classic() +
  theme(panel.border = element_blank(),
        axis.text = element_blank(),
        line = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(size=40, face="bold"))  +
  theme(legend.position="right", legend.title = element_text(size=8))
map



################# County Bin by Rural/Urban ###################################################

df<-df2_merge_key_2 %>%
  select(c("acc_aux_STATE_nm", "County.Name","acc_COUNTY_bin"))

df<-df %>%
  select("acc_aux_STATE_nm", "County.Name","acc_COUNTY_bin") %>%
  group_by(acc_aux_STATE_nm, County.Name, acc_COUNTY_bin) %>%
  summarise(n())

df<-df %>%
  select("acc_aux_STATE_nm","County.Name","acc_COUNTY_bin")

MainCounties <- map_data("county")


# merge MainCounties and df files
county <- merge(MainCounties, df, by.x=c("region","subregion") , 
                      by.y=c("acc_aux_STATE_nm","County.Name"), all.x=TRUE)
dim(county)
# 87949     7



county$fill<-ifelse(county$acc_COUNTY_bin=="low_rural_fatal","lightskyblue1",
                     ifelse(county$acc_COUNTY_bin=="med_low_rural_fatal", "lightskyblue2",
                     ifelse(county$acc_COUNTY_bin=="med_high_rural_fatal","lightskyblue3" ,
                     ifelse(county$acc_COUNTY_bin=="high_rural_fatal","lightskyblue4",
                   "grey78"
                   ))))
county$rank<-ifelse(county$acc_COUNTY_bin=="low_rural_fatal",1,
                    ifelse(county$acc_COUNTY_bin=="med_low_rural_fatal", 2,
                           ifelse(county$acc_COUNTY_bin=="med_high_rural_fatal",3 ,
                                  ifelse(county$acc_COUNTY_bin=="high_rural_fatal",4,
                                         0
                                  ))))

county<-arrange(county, region, subregion, group, order)

map_bin<-ggplot() + 
  #Add county borders:
  geom_polygon(data=county, aes(x=long,y=lat,group=group , fill=rank),  colour="white") +
  #Add state borders:
  geom_polygon(data = MainStates, aes(x=long,y=lat,group=group), colour = "black", fill=NA) +

  #Add a title:
  ggtitle("Counties binned by Quartile based on Percent Rural Fatal MVA's") +
#Adjust the theme:
  theme(legend.position="bottom", legend.title = element_text(size=12)) +
  #scale_fill_continous(name = "Bins", labels = c("Low", "Medium Low", "Medium High","High")) +    
theme_classic() +
  theme(panel.border = element_blank(),
        axis.text = element_blank(),
        line = element_blank(),
        axis.title = element_blank(),
        plot.title = element_text(size=14, face="bold"))
map_bin





unique_make<-unique(df2_merge_key_2$veh_MAKE_nm)
write.csv(unique_make,"1a - Final Code/Fixed Code/Data/unique_make.csv")

try<-df2_merge_key_2 %>%
  select("veh_MAK_MOD_bin", "veh_aux_A_BODY_nm") %>%
  group_by(veh_MAK_MOD_bin, veh_aux_A_BODY_nm) %>%
  summarise(n()) 

try2<-try %>%
  group_by(veh_MAK_MOD_bin) %>%
  summarise(Sum=sum(`n()`)) %>% 
  mutate(Percentage=`n()`/Sum)

try_merge<-merge(try, try2, by=c("veh_MAK_MOD_bin"), all.x=TRUE)
try_merge$perc<-try_merge$`n()`/try_merge$Sum

write.csv(try_merge, "1a - Final Code/Fixed Code/Data/veh_MAK_MOD_bin_by_BODY_TYP.csv")

light_truck_pu<-df2_merge_key_2 %>%
  filter(veh_aux_A_BODY_nm=="2_Light_Truck_Pickup" & veh_MAK_MOD_bin=="high_rural_fatal") %>%
  select("veh_MAKE_nm", "veh_MAK_MOD") %>%
  group_by(veh_MAKE_nm,veh_MAK_MOD) %>%
  summarise(n())

veh_high_rural_fatal<-df2_merge_key_2 %>%
  filter(veh_MAK_MOD_bin=="high_rural_fatal") %>%
  select("veh_MAKE_nm", "veh_MAK_MOD") %>%
  group_by(veh_MAKE_nm,veh_MAK_MOD) %>%
  summarise(n())

write.csv(veh_high_rural_fatal, "1a - Final Code/Fixed Code/Data/veh_high_rural_fatal.csv")

sum(veh_high_rural_fatal$`n()`
)
sum(veh_high_rural_fatal$`n()`)











