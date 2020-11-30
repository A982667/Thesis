-------------------------------------------------------------------------
--Purpose: Develop FARS data set to be used for Data Science Analysis
--Author: Amy McNamara
--Date: 2020-01-18
-------------------------------------------------------------------------
USE FARS;
--------------------------------------------------------------------------
--Step 1
--initial data set joining accident and person files for fatal injuries.
--------------------------------------------------------------------------

drop table if exists #Init

select p.[A_AGE1] as per_aux_A_AGE1
      ,p.[A_AGE2] as per_aux_A_AGE2
      ,p.[A_AGE3] as per_aux_A_AGE3
      ,p.[A_AGE4] as per_aux_A_AGE4
      ,p.[A_AGE5] as per_aux_A_AGE5
      ,p.[A_AGE6] as per_aux_A_AGE6
      ,p.[A_AGE7] as per_aux_A_AGE7
      ,p.[A_AGE8] as per_aux_A_AGE8
      ,p.[A_AGE9] as per_aux_A_AGE9
      ,p.[ST_CASE] as per_aux_ST_CASE
      ,p.[VEH_NO] as per_aux_VEH_NO
      ,p.[PER_NO] as per_aux_PER_NO
      ,p.[YEAR] as per_aux_YEAR
      ,p.[A_PTYPE] as per_aux_A_PTYPE
      ,p.[A_RESTUSE] as per_aux_A_RESTUSE
      ,p.[A_HELMUSE] as per_aux_A_HELMUSE
      ,p.[A_ALCTES] as per_aux_A_ALCTES
      ,p.[A_HISP] as per_aux_A_HISP
      ,p.[A_RCAT] as per_aux_A_RCAT
      ,p.[A_HRACE] as per_aux_A_HRACE
      ,p.[A_EJECT] as per_aux_A_EJECT
      ,p.[A_PERINJ] as per_aux_A_PERINJ
      ,p.[A_LOC] as per_aux_A_LOC
	  ,p.[A_DOA] as per_aux_A_DOA
	  ,a.[YEAR] as acc_aux_YEAR
      ,a.[STATE] as acc_aux_STATE
      ,a.[ST_CASE] as acc_aux_ST_CASE
      ,a.[COUNTY] as acc_aux_COUNTY
      ,a.[FATALS] as acc_aux_FATALS
      ,a.[A_CRAINJ] as acc_aux_A_CRAINJ
      ,a.[A_REGION] as acc_aux_A_REGION
      ,a.[A_RU] as acc_aux_A_RU
      ,a.[A_INTER] as acc_aux_A_INTER
      ,a.[A_RELRD] as acc_aux_A_RELRD
      ,a.[A_INTSEC] as acc_aux_A_INTSEC
      ,a.[A_ROADFC] as acc_aux_A_ROADFC
      ,a.[A_JUNC] as acc_aux_A_JUNC
      ,a.[A_MANCOL] as acc_aux_A_MANCOL
      ,a.[A_TOD] as acc_aux_A_TOD
      ,a.[A_DOW] as acc_aux_A_DOW
      ,a.[A_CT] as acc_aux_A_CT
	  ,a.[A_WEATHER] as acc_aux_A_WEATHER
      ,a.[A_LT] as acc_aux_A_LT
      ,a.[A_MC] as acc_aux_A_MC
      ,a.[A_SPCRA] as acc_aux_A_SPCRA
      ,a.[A_PED] as acc_aux_A_PED
      ,a.[A_PED_F] as acc_aux_A_PED_F
      ,a.[A_PEDAL] as acc_aux_A_PEDAL
      ,a.[A_PEDAL_F] as acc_aux_A_PEDAL_F
      ,a.[A_ROLL] as acc_aux_A_ROLL
      ,a.[A_POLPUR] as acc_aux_A_POLPUR
      ,a.[A_POSBAC] as acc_aux_A_POSBAC
      ,a.[A_D15_19] as acc_aux_A_D15_19
      ,a.[A_D16_19] as acc_aux_A_D16_19
      ,a.[A_D15_20] as acc_aux_A_D15_20
      ,a.[A_D16_20] as acc_aux_A_D16_20
      ,a.[A_D65PLS] as acc_aux_A_D65PLS
      ,a.[A_D21_24] as acc_aux_A_D21_24
      ,a.[A_D16_24] as acc_aux_A_D16_24
      ,a.[A_RD] as acc_aux_A_RD
      ,a.[A_HR] as acc_aux_A_HR
      ,a.[A_DIST] as acc_aux_A_DIST
      ,a.[A_DROWSY] as acc_aux_A_DROWSY
      ,a.[BIA] as acc_aux_BIA
      ,a.[SPJ_INDIAN] as acc_aux_SPJ_INDIAN
      ,a.[INDIAN_RES] as acc_aux_INDIAN_RES
into #Init
from dbo.raw_per_aux p
join dbo.raw_acc_aux a
on p.ST_CASE=a.ST_CASE
and p.YEAR=a.YEAR
where p.A_PERINJ=1 --fatal injury
--37,473 - matches NHTSA's total mva fatalities 2017
--36,560 -- matches NHTSA's total mva fatalities in 2018
--74,033 total -- matches NHTAS's total mva fatalities 

--View results
--select * from #Init

---------------------------------------------------------------------------------
--Step 2
--Add aux_vehicle table to #Init
--create new temp table #Init2
---------------------------------------------------------------------------------

drop table if exists #Init2

select i.*
	  ,v.[YEAR] as veh_aux_year
      ,v.[ST_CASE] as veh_aux_ST_CASE
      ,v.[VEH_NO] as veh_aux_VEH_NO
      ,v.[A_BODY] as veh_aux_A_BODY
      ,v.[A_IMP1] as veh_aux_A_IMP1
      ,v.[A_IMP2] as veh_aux_A_IMP2
      ,v.[A_VROLL] as veh_aux_A_VROLL
      ,v.[A_LIC_S] as veh_aux_A_LIC_S
      ,v.[A_LIC_C] as veh_aux_A_LIC_C
      ,v.[A_CDL_S] as veh_aux_A_CDL_S
      ,v.[A_MC_L_S] as veh_aux_A_MC_L_S
      ,v.[A_SPVEH] as veh_aux_A_SPVEH
      ,v.[A_SBUS] as veh_aux_A_SBUS
      ,v.[A_MOD_YR] as veh_aux_A_MOD_YR
      ,v.[A_DRDIS] as veh_aux_A_DRDIS
      ,v.[A_DRDRO] as veh_aux_A_DRDRO
	  ,v.[A_FIRE_EXP] as veh_aux_A_FIRE_EXP
into #Init2
from #Init i
inner join dbo.raw_veh_aux v
on i.per_aux_YEAR=v.YEAR
and i.per_aux_ST_CASE=v.ST_CASE
and i.per_aux_VEH_NO=v.VEH_NO
where v.VEH_NO<>0
and v.A_BODY in (1,2,3,4,5,6,7) --passenger cars, light trucks, large trucks, motorcycles
--58,337
--Matched Occupants total from NHTSA

--View results
--select * from #Init2

---------------------------------------------------------------------------------
--Step 3
--Pull in Accident file data to supplement Acc_Aux
--create new temp table #Init3
---------------------------------------------------------------------------------

drop table if exists #Init3

select a.*
,b.VE_TOTAL as acc_VE_TOTAL
,b.VE_FORMS as acc_VE_FORMS
,b.PVH_INVL as acc_PVH_INVL
,b.PEDS as acc_PEDS
,b.PERNOTMVIT as acc_PERNOTMVIT
,b.PERMVIT as acc_PERMVIT
,b.PERSONS as acc_PERSONS
,b.COUNTY as acc_COUNTY
,b.CITY as acc_CITY
,b.DAY as acc_DAY
,b.MONTH as acc_MONTH
,b.YEAR as acc_YEAR
,b.DAY_WEEK as acc_DAY_WEEK
,b.HOUR as acc_HOUR
,b.MINUTE as acc_MINUTE
,b.NHS as acc_NHS
,b.RUR_URB as acc_RUR_URB
,b.FUNC_SYS as acc_FUNC_SYS
,b.RD_OWNER as acc_RD_OWNER
,b.ROUTE as acc_ROUTE
,b.TWAY_ID as acc_TWAY_ID
,b.TWAY_ID2 as acc_TWAY_ID2
,b.MILEPT as acc_MILEPT
,b.LATITUDE as acc_LATITUDE
,b.LONGITUD as acc_LONGITUD
,b.SP_JUR as acc_SP_JUR
,b.HARM_EV as acc_HARM_EV
,b.MAN_COLL as acc_MAN_COLL
,b.RELJCT1 as acc_RELJCT1
,b.RELJCT2 as acc_RELJCT2
,b.TYP_INT as acc_TYP_INT
,b.WRK_ZONE as acc_WRK_ZONE
,b.REL_ROAD as acc_REL_ROAD
,b.LGT_COND as acc_LGT_COND
,b.WEATHER1 as acc_WEATHER1
,b.WEATHER2 as acc_WEATHER2
,b.WEATHER as acc_WEATHER
,b.SCH_BUS as acc_SCH_BUS
,b.RAIL as acc_RAIL
,b.NOT_HOUR as acc_NOT_HOUR
,b.NOT_MIN as acc_NOT_MIN
,b.ARR_HOUR as acc_ARR_HOUR
,b.ARR_MIN as acc_ARR_MIN
,b.HOSP_HR as acc_HOSP_HR
,b.HOSP_MN as acc_HOSP_MN
,b.CF1 as acc_CF1
,b.CF2 as acc_CF2
,b.CF3 as acc_CF3
,b.FATALS as acc_FATALS
,b.DRUNK_DR as acc_DRUNK_DR
into #Init3
from #Init2 a
left join dbo.raw_accident b
on a.per_aux_ST_CASE=b.ST_CASE
and a.per_aux_YEAR=b.YEAR
--58,337

--View results
-- * from #Init3

---------------------------------------------------------------------------------
--Step 4
--Take #Init3 and join with dbo.raw_PERSON
--Row count should be 58,337
--create new temp table #Init6
---------------------------------------------------------------------------------

drop table if exists #Init4

select a.*
, b.STR_VEH as per_STR_VEH
, b.COUNTY as per_COUNTY
, b.DAY as per_DAY
, b.MONTH as per_MONTH
, b.HOUR as per_HOUR
, b.MINUTE as per_MINUTE
, b.RUR_URB as per_RUR_URB
, b.FUNC_SYS as per_FUNC_SYS
, b.HARM_EV as per_HARM_EV
, b.MAN_COLL as per_MAN_COLL
, b.SCH_BUS as per_SCH_BUS
, b.MAKE as per_MAKE
, b.MAK_MOD as per_MAK_MOD
, b.BODY_TYP as per_BODY_TYP
, b.MOD_YEAR as per_MOD_YEAR
, b.TOW_VEH as per_TOW_VEH
, b.SPEC_USE as per_SPEC_USE
, b.EMER_USE as per_EMER_USE
, b.ROLLOVER as per_ROLLOVER
, b.IMPACT1 as per_IMPACT1
, b.FIRE_EXP as per_FIRE_EXP
, b.AGE as per_AGE
, b.SEX as per_SEX
, b.PER_TYP as per_PER_TYPE
, b.INJ_SEV as per_INJ_SEV
, b.SEAT_POS as per_SEAT_POS
, b.REST_USE as per_REST_USE
, b.REST_MIS as per_REST_MIS
, b.AIR_BAG as per_AIG_BAG
, b.EJECTION as per_EJECTION
, b.EJ_PATH as per_EJ_PATH
, b.EXTRICAT as per_EXTRICAT
, b.DRINKING as per_DRINKING
, b.ALC_DET as per_ALC_DET
, b.ALC_STATUS as per_ALC_STATUS
, b.ATST_TYP as per_ATST_TYPE
, b.ALC_RES as per_ALC_RES
, b.DRUGS as per_DRUGS
, b.DRUG_DET as per_DRUG_DET
, b.DSTATUS	 as per_DSTATUS
, b.HOSPITAL as per_HOSPITAL
, b.DOA as per_DOA
, b.DEATH_DA as per_DEATH_DA
, b.DEATH_MO as per_DEATH_MO
, b.DEATH_YR as per_DEATH_YR
, b.DEATH_HR as per_DEATH_HR
, b.DEATH_MN as per_DEATH_MN
, b.DEATH_TM as per_DEATH_TM
, b.LAG_HRS as per_LAG_HRS
, b.LAG_MINS as per_LAG_MINS
, b.P_SF1 as per_P_SF1
, b.P_SF2 as per_P_SF2
, b.P_SF3 as per_P_SF3
, b.WORK_INJ as per_WORK_INJ
, b.HISPANIC as per_HISPANIC
, b.RACE as per_RACE
, b.LOCATION as per_LOCATION
into #Init4
from #Init3 a
left join dbo.raw_person b
on a.per_aux_YEAR=b.YEAR
and a.per_aux_ST_CASE=b.ST_CASE
and a.per_aux_PER_NO=b.PER_NO
and a.veh_aux_VEH_NO=b.VEH_NO
--58,337

--View results
--select * from #Init4

---------------------------------------------------------------------------------
--Step 5
--Pull VEHICLE data to supplement VEH_AUX
--Row count should be 58,337
--create new temp table #Init5
---------------------------------------------------------------------------------

drop table if exists #Init5

select a.*
, b.NUMOCCS as veh_NUMOCCS
, b.DAY as veh_DAY
, b.MONTH as veh_MONTH
, b.HOUR as veh_HOUR
, b.MINUTE as veh_MINUTE
, b.HARM_EV as veh_HARM_EV
, b.MAN_COLL as veh_MAN_COLL
, b.UNITTYPE as veh_UNITTYPE
, b.HIT_RUN as veh_HIT_RUN
, b.REG_STAT as veh_REG_STAT
, b.OWNER as veh_OWNER
, b.MAKE as veh_MAKE
, b.MODEL as veh_MODEL
, b.MAK_MOD as veh_MAK_MOD
, b.BODY_TYP as veh_BODY_TYP
, b.MOD_YEAR as veh_MOD_YEAR
, b.VIN as veh_VIN
, b.VIN_1 as veh_VIN_1
, b.VIN_2 as veh_VIN_2
, b.VIN_3 as veh_VIN_3
, b.VIN_4 as veh_VIN_4
, b.VIN_5 as veh_VIN_5
, b.VIN_6 as veh_VIN_6
, b.VIN_7 as veh_VIN_7
, b.VIN_8 as veh_VIN_8
, b.VIN_9 as veh_VIN_9
, b.VIN_10 as veh_VIN_10
, b.VIN_11 as veh_VIN_11
, b.VIN_12 as veh_VIN_12
, b.[TOW_VEH] as veh_TOW_VEH
,b.[J_KNIFE] as veh_J_KNIFE
,b.[MCARR_I1] as veh_MCARR_11
,b.[MCARR_I2] as veh_MCARR_12
,b.[MCARR_ID] as veh_MCARR_ID
,b.[GVWR] as veh_GVWR
,b.[V_CONFIG] as veh_V_CONFIG
,b.[CARGO_BT] as veh_CARGO_BT
,b.[HAZ_INV] as veh_HAZ_INV
,b.[HAZ_PLAC] as veh_HAZ_PLAC
,b.[HAZ_ID] as veh_HAZ_ID
,b.[HAZ_CNO] as veh_HAZ_CNO
,b.[HAZ_REL] as veh_HAZ_REL
,b.[BUS_USE] as veh_BUS_USE
,b.[SPEC_USE] as veh_SPEC_USE
,b.[EMER_USE] as veh_EMER_USE
,b.[TRAV_SP] as veh_TRAV_SP
,b.[UNDERIDE] as veh_UNDERIDE
,b.[ROLLOVER] as veh_ROLLOVER
,b.[ROLINLOC] as veh_ROLINLOC
,b.[IMPACT1] as veh_IMPACT1
,b.[DEFORMED] as veh_DEFORMED
,b.[TOWED] as veh_TOWED
,b.[M_HARM] as veh_M_HARM
,b.[VEH_SC1] as veh_VEH_SC1
,b.[VEH_SC2] as veh_VEH_SC2
,b.[FIRE_EXP] as veh_FIRE_EXP
,b.[DR_PRES]  as veh_DR_PRES
,b.[L_STATE] as veh_L_STATE
,b.[DR_ZIP] as veh_DR_ZIP
,b.[L_STATUS] as veh_L_STATUS
,b.[L_TYPE] as veh_L_TYPE
,b.[CDL_STAT] as veh_CDL_STAT
,b.[L_ENDORS] as veh_L_ENDORS
,b.[L_COMPL] as veh_L_COMPL
,b.[L_RESTRI] as veh_L_RESTRI
,b.[DR_HGT] as veh_DR_HGT
,b.[DR_WGT] as veh_DR_WGT
,b.[PREV_ACC] as veh_PREV_ACC
,b.[PREV_DWI] as veh_PREV_DWI
,b.[PREV_SPD] as veh_PREV_SPD
,b.[PREV_OTH] as veh_PREV_OTH
,b.[FIRST_MO] as veh_FIRST_MO
,b.[FIRST_YR] as veh_FIRST_YR
,b.[LAST_MO] as veh_LAST_MO
,b.[LAST_YR] as veh_LAST_YR
,b.[SPEEDREL] as veh_SPEEDREL
,b.[DR_SF1] as veh_DR_SF1
,b.[DR_SF2] as veh_DR_SF2
,b.[DR_SF3] as veh_DR_SF3
,b.[DR_SF4] as veh_DR_SF4
,b.[VTRAFWAY] as veh_VTRAFWAY
,b.[VNUM_LAN] as veh_VNUM_LAN
,b.[VSPD_LIM] as veh_VSPD_LIM
,b.[VALIGN] as veh_VALIGN
,b.[VPROFILE] as veh_VPROFILE
,b.[VPAVETYP] as veh_VPAVETYP
,b.[VSURCOND] as veh_VSURCOND
,b.[VTRAFCON] as veh_VTRAFCON
,b.[VTCONT_F] as veh_VTCONT_F
,b.[P_CRASH1] as veh_P_CRASH1
,b.[P_CRASH2] as veh_P_CRASH2
,b.[P_CRASH3] as veh_P_CRASH3
,b.[PCRASH4] as veh_P_CRASH4
,b.[PCRASH5] as veh_P_CRASH5
,b.[ACC_TYPE] as veh_ACC_TYPE
,b.[TRLR1VIN] as veh_TRLR1VIN
,b.[TRLR2VIN] as veh_TRLR2VIN
,b.[TRLR3VIN] as veh_TRLR3VIN
,b.[DEATHS] as veh_DEATHS
,b.[DR_DRINK] as veh_DR_DRINK
into #Init5
from #Init4 a
left join dbo.raw_vehicle b
on a.acc_aux_YEAR=b.year
and a.acc_aux_ST_CASE=b.ST_CASE
and a.per_aux_VEH_NO=b.VEH_NO

--58,337

--View results
--select * from #Init5

---------------------------------------------------------------------------------
--Step 6
--Take vehicle file and find the sum of previous moving violations for all vehicles in crash
--create new temp table #Init6
---------------------------------------------------------------------------------

drop table if exists #Init6

select a.year
,a.ST_CASE
, sum(CASE WHEN a.PREV_ACC<=97
	THEN a.PREV_ACC
	ELSE 0 -- -1 indicates unknown/no driver present
	END )as oth_veh_PREV_ACC 
, sum(CASE WHEN a.PREV_DWI<=97
	THEN a.PREV_DWI
	ELSE 0 -- -1 indicates unknown/no driver present
	END) as oth_veh_PREV_DWI 
, sum(CASE WHEN a.PREV_SPD<=97
	THEN a.PREV_SPD
	ELSE 0 -- -1 indicates unknown/no driver present
	END) as oth_veh_PREV_SPD 
, sum(CASE WHEN a.PREV_OTH<=97
	THEN a.PREV_OTH
	ELSE -0 -- -1 indicates unknown/no driver present
	END) as oth_veh_PREV_OTH
into #Init6
from dbo.raw_vehicle a
left join dbo.raw_veh_aux b
on a.ST_CASE=b.ST_CASE
and a.VEH_NO=b.VEH_NO
where b.A_BODY in (1,2,3,4,5,6,7)
and b.VEH_NO<>0
group by a.year
,a.ST_CASE
--67,951

---------------------------------------------------------------------------------
--Step 7
--Take #Init6 and join with #Init5 to pull in additional fields from VEHICLE
--Row count should be 58,337
--create new temp table #Init7
---------------------------------------------------------------------------------
 
 drop table if exists #Init7
 
 select a.*
 ,b.oth_veh_PREV_ACC
 ,b.oth_veh_PREV_DWI
 ,b.oth_veh_PREV_SPD
 ,b.oth_veh_PREV_OTH
 into #Init7
 from #Init5 a
 left join #Init6 b
on a.acc_aux_YEAR=b.YEAR
and a.per_aux_ST_CASE=b.ST_CASE
--58,337

--View results
--select * from #Init7

---------------------------------------------------------------------------------
--Step 8
--Take #Init7 and join with dbo.raw_drugs to pull drug test and drug results
--Row count should be 58,337
--create new temp table #Init8
---------------------------------------------------------------------------------
 drop table if exists #Init8

select a.*
,b.DRUGTST as per_DRUG_TEST
,b.[Drugs_Not_Tested] as per_Drugs_Not_Tested
,b.[Drugs_Negative] as per_Drugs_Negative
,b.[Drugs_Not_Reported] as per_Drugs_Not_Reported
,b.[Drugs_Other] as per_Drugs_Other
,b.[Drugs_Tested_Result_Unknown] as per_Drugs_Tested_Result_Unknown
,b.[Drugs_Tested_Positive_Unknown_Type] as per_Drugs_Tested_Positive_Unknown_Type
,b.[Drugs_Unknown_if_tested] as per_Drugs_Unknown_if_tested
,b.[Drugs_Narcotic] as per_Drugs_Narcotic
,b.[Drugs_Depressant] as per_Drugs_Depressant
,b.[Drugs_Stimulant] as per_Drugs_Stimulant
,b.[Drugs_Hallucinogen] as per_Drugs_Hallucinogen
,b.[Drugs_Cannabinoid] as per_Drugs_Cannabinoid
,b.[Drugs_Phencyclidine(PCP)] as per_Drugs_PCP
,b.[Drugs_Anabolic Steroid] as per_Drugs_Anabolic_Steroid
,b.[Drugs_Inhalant] as per_Drugs_Inhalant
into #Init8
from #Init7 a
left join dbo.raw_drugs b
on a.acc_aux_YEAR=b.YEAR
and a.acc_aux_ST_CASE=b.st_case
and a.per_aux_per_no=b.per_no
and a.per_aux_VEH_NO=b.veh_no
--58,337

--View results
--select * from #Init8

---------------------------------------------------------------------------------
--Step 9
--Take #Init8 and join with dbo.raw_prev_sus to pull previous suspensions of fatality
--Row count should be 58,337
--create new temp table #Init9
---------------------------------------------------------------------------------
 drop table if exists #Init9

 select a.*
 ,b.prev_sus as veh_prev_sus
 into #Init9
 from #Init8 a
 left join dbo.raw_prev_sus b
 on a.acc_aux_YEAR=b.YEAR
 and a.acc_aux_ST_CASE=b.st_case
 and a.per_aux_VEH_NO=b.veh_no
 --58,337

 --View results
 --select * from #Init9

 ---------------------------------------------------------------------------------
--Step 10
--Take #Init9 and join with dbo.raw_oth_veh_prev_sus to pull other
--Row count should be 58,337
--create new temp table #Init10
---------------------------------------------------------------------------------
drop table if exists #Init10

select a.*
, b.oth_veh_prev_sus
into #Init10
from #Init9 a
left join dbo.raw_oth_veh_prev_sus b
on a.acc_aux_YEAR=b.year
and a.acc_aux_ST_CASE=b.st_case
--58,337

--View results
--select * from #Init10

--Count columns in #Init10
--SELECT COUNT(*)
--FROM tempdb.sys.columns
--WHERE object_id = object_id('tempdb..#Init10')
----134

--select * from tempdb.sys.columns where object_id =
--object_id('tempdb..#Init10')

 ---------------------------------------------------------------------------------
--Step 11
--Take #Init10 and create table dbo.raw_final_1
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_1]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_1]
END

select * into [dbo].[raw_final_1]
from 
	(select a.*
	from #Init10 a) as combined
--58,337

--Count columns in raw_final_1
--SELECT COUNT(*)
--FROM sys.columns
--WHERE object_id = object_id('dbo.raw_final_1')
----311


 ---------------------------------------------------------------------------------
--Step 12
--Take dbo.raw_final_1 and remove duplicate key fields and organize fields by source file
--Create one single key of Year + St_CASE
--create table dbo.raw_final_2
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_2]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_2]
END

select * into [dbo].[raw_final_2]
from 
	( select concat([acc_aux_YEAR],'_',[acc_aux_ST_CASE]) as 'Key'
      ,[acc_aux_STATE]
      ,[acc_aux_COUNTY]
      ,[acc_aux_FATALS]
      ,[acc_aux_A_CRAINJ]
      ,[acc_aux_A_REGION]
      ,[acc_aux_A_RU]
      ,[acc_aux_A_INTER]
      ,[acc_aux_A_RELRD]
      ,[acc_aux_A_INTSEC]
      ,[acc_aux_A_ROADFC]
      ,[acc_aux_A_JUNC]
      ,[acc_aux_A_MANCOL]
      ,[acc_aux_A_TOD]
      ,[acc_aux_A_DOW]
      ,[acc_aux_A_CT]
      ,[acc_aux_A_WEATHER]
      ,[acc_aux_A_LT]
      ,[acc_aux_A_MC]
      ,[acc_aux_A_SPCRA]
      ,[acc_aux_A_PED]
      ,[acc_aux_A_PED_F]
      ,[acc_aux_A_PEDAL]
      ,[acc_aux_A_PEDAL_F]
      ,[acc_aux_A_ROLL]
      ,[acc_aux_A_POLPUR]
      ,[acc_aux_A_POSBAC]
      ,[acc_aux_A_D15_19]
      ,[acc_aux_A_D16_19]
      ,[acc_aux_A_D15_20]
      ,[acc_aux_A_D16_20]
      ,[acc_aux_A_D65PLS]
      ,[acc_aux_A_D21_24]
      ,[acc_aux_A_D16_24]
      ,[acc_aux_A_RD]
      ,[acc_aux_A_HR]
      ,[acc_aux_A_DIST]
      ,[acc_aux_A_DROWSY]
      ,[acc_aux_BIA]
      ,[acc_aux_SPJ_INDIAN]
      ,[acc_aux_INDIAN_RES]
	  ,[acc_VE_TOTAL]
      ,[acc_VE_FORMS]
      ,[acc_PVH_INVL]
      ,[acc_PEDS]
      ,[acc_PERNOTMVIT]
      ,[acc_PERMVIT]
      ,[acc_PERSONS]
      ,[acc_COUNTY]
      ,[acc_CITY]
      ,[acc_DAY]
      ,[acc_MONTH]
      ,[acc_YEAR]
      ,[acc_DAY_WEEK]
      ,[acc_HOUR]
      ,[acc_MINUTE]
      ,[acc_NHS]
      ,[acc_RUR_URB]
      ,[acc_FUNC_SYS]
      ,[acc_RD_OWNER]
      ,[acc_ROUTE]
      ,[acc_TWAY_ID]
      ,[acc_TWAY_ID2]
      ,[acc_MILEPT]
      ,[acc_LATITUDE]
      ,[acc_LONGITUD]
      ,[acc_SP_JUR]
      ,[acc_HARM_EV]
      ,[acc_MAN_COLL]
      ,[acc_RELJCT1]
      ,[acc_RELJCT2]
      ,[acc_TYP_INT]
      ,[acc_WRK_ZONE]
      ,[acc_REL_ROAD]
      ,[acc_LGT_COND]
      ,[acc_WEATHER1]
      ,[acc_WEATHER2]
      ,[acc_WEATHER]
      ,[acc_SCH_BUS]
      ,[acc_RAIL]
      ,[acc_NOT_HOUR]
      ,[acc_NOT_MIN]
      ,[acc_ARR_HOUR]
      ,[acc_ARR_MIN]
      ,[acc_HOSP_HR]
      ,[acc_HOSP_MN]
      ,[acc_CF1]
      ,[acc_CF2]
      ,[acc_CF3]
      ,[acc_FATALS]
      ,[acc_DRUNK_DR]
      ,[veh_aux_VEH_NO]
      ,[veh_aux_A_BODY]
      ,[veh_aux_A_IMP1]
      --,[veh_aux_A_IMP2] removed as all null and maybe causing issue loading to R
      ,[veh_aux_A_VROLL]
      ,[veh_aux_A_LIC_S]
      ,[veh_aux_A_LIC_C]
      ,[veh_aux_A_CDL_S]
      ,[veh_aux_A_MC_L_S]
      ,[veh_aux_A_SPVEH]
      ,[veh_aux_A_SBUS]
      ,[veh_aux_A_MOD_YR]
      ,[veh_aux_A_DRDIS]
      ,[veh_aux_A_DRDRO]
      ,[veh_aux_A_FIRE_EXP]
	  ,[veh_NUMOCCS]
      ,[veh_DAY]
      ,[veh_MONTH]
      ,[veh_HOUR]
      ,[veh_MINUTE]
      ,[veh_HARM_EV]
      ,[veh_MAN_COLL]
      ,[veh_UNITTYPE]
      ,[veh_HIT_RUN]
      ,[veh_REG_STAT]
      ,[veh_OWNER]
      ,[veh_MAKE]
      ,[veh_MODEL]
      ,[veh_MAK_MOD]
      ,[veh_BODY_TYP]
      ,[veh_MOD_YEAR]
      ,[veh_VIN]
      ,[veh_VIN_1]
      ,[veh_VIN_2]
      ,[veh_VIN_3]
      ,[veh_VIN_4]
      ,[veh_VIN_5]
      ,[veh_VIN_6]
      ,[veh_VIN_7]
      ,[veh_VIN_8]
      ,[veh_VIN_9]
      ,[veh_VIN_10]
      ,[veh_VIN_11]
      ,[veh_VIN_12]
      ,[veh_TOW_VEH]
      ,[veh_J_KNIFE]
      ,[veh_MCARR_11]
      ,[veh_MCARR_12]
      ,[veh_MCARR_ID]
      ,[veh_GVWR]
      ,[veh_V_CONFIG]
      ,[veh_CARGO_BT]
      ,[veh_HAZ_INV]
      ,[veh_HAZ_PLAC]
      ,[veh_HAZ_ID]
      ,[veh_HAZ_CNO]
      ,[veh_HAZ_REL]
      ,[veh_BUS_USE]
      ,[veh_SPEC_USE]
      ,[veh_EMER_USE]
      ,[veh_TRAV_SP]
      ,[veh_UNDERIDE]
      ,[veh_ROLLOVER]
      ,[veh_ROLINLOC]
      ,[veh_IMPACT1]
      ,[veh_DEFORMED]
      ,[veh_TOWED]
      ,[veh_M_HARM]
      ,[veh_VEH_SC1]
      ,[veh_VEH_SC2]
      ,[veh_FIRE_EXP]
      ,[veh_DR_PRES]
      ,[veh_L_STATE]
      ,[veh_DR_ZIP]
      ,[veh_L_STATUS]
      ,[veh_L_TYPE]
      ,[veh_CDL_STAT]
      ,[veh_L_ENDORS]
      ,[veh_L_COMPL]
      ,[veh_L_RESTRI]
      ,[veh_DR_HGT]
      ,[veh_DR_WGT]
	  ,[veh_prev_sus]
      ,[veh_PREV_ACC]
      ,[veh_PREV_DWI]
      ,[veh_PREV_SPD]
      ,[veh_PREV_OTH]
      ,[veh_FIRST_MO]
      ,[veh_FIRST_YR]
      ,[veh_LAST_MO]
      ,[veh_LAST_YR]
      ,[veh_SPEEDREL]
      ,[veh_DR_SF1]
      ,[veh_DR_SF2]
      ,[veh_DR_SF3]
      ,[veh_DR_SF4]
      ,[veh_VTRAFWAY]
      ,[veh_VNUM_LAN]
      ,[veh_VSPD_LIM]
      ,[veh_VALIGN]
      ,[veh_VPROFILE]
      ,[veh_VPAVETYP]
      ,[veh_VSURCOND]
      ,[veh_VTRAFCON]
      ,[veh_VTCONT_F]
      ,[veh_P_CRASH1]
      ,[veh_P_CRASH2]
      ,[veh_P_CRASH3]
      ,[veh_P_CRASH4]
      ,[veh_P_CRASH5]
      ,[veh_ACC_TYPE]
      ,[veh_TRLR1VIN]
      ,[veh_TRLR2VIN]
      ,[veh_TRLR3VIN]
      ,[veh_DEATHS]
      ,[veh_DR_DRINK]
	  ,[oth_veh_prev_sus]
      ,[oth_veh_PREV_ACC]
      ,[oth_veh_PREV_DWI]
      ,[oth_veh_PREV_SPD]
      ,[oth_veh_PREV_OTH]
	  ,[per_aux_A_AGE1]
      ,[per_aux_A_AGE2]
      ,[per_aux_A_AGE3]
      ,[per_aux_A_AGE4]
      ,[per_aux_A_AGE5]
      ,[per_aux_A_AGE6]
      ,[per_aux_A_AGE7]
      ,[per_aux_A_AGE8]
      ,[per_aux_A_AGE9]
      ,[per_aux_PER_NO]
      ,[per_aux_A_PTYPE]
      ,[per_aux_A_RESTUSE]
      ,[per_aux_A_HELMUSE]
      ,[per_aux_A_ALCTES]
      ,[per_aux_A_HISP]
      ,[per_aux_A_RCAT]
      ,[per_aux_A_HRACE]
      ,[per_aux_A_EJECT]
      ,[per_aux_A_PERINJ]
      ,[per_aux_A_LOC]
      ,[per_aux_A_DOA]
      ,[per_STR_VEH]
      ,[per_COUNTY]
      ,[per_DAY]
      ,[per_MONTH]
      ,[per_HOUR]
      ,[per_MINUTE]
      ,[per_RUR_URB]
      ,[per_FUNC_SYS]
      ,[per_HARM_EV]
      ,[per_MAN_COLL]
      ,[per_SCH_BUS]
      ,[per_MAKE]
      ,[per_MAK_MOD]
      ,[per_BODY_TYP]
      ,[per_MOD_YEAR]
      ,[per_TOW_VEH]
      ,[per_SPEC_USE]
      ,[per_EMER_USE]
      ,[per_ROLLOVER]
      ,[per_IMPACT1]
      ,[per_FIRE_EXP]
      ,[per_AGE]
      ,[per_SEX]
      ,[per_PER_TYPE]
      ,[per_INJ_SEV]
      ,[per_SEAT_POS]
      ,[per_REST_USE]
      ,[per_REST_MIS]
      ,[per_AIG_BAG]
      ,[per_EJECTION]
      ,[per_EJ_PATH]
      ,[per_EXTRICAT]
      ,[per_DRINKING]
      ,[per_ALC_DET]
      ,[per_ALC_STATUS]
      ,[per_ATST_TYPE]
      ,[per_ALC_RES]
      ,[per_DRUGS]
      ,[per_DRUG_DET]
      ,[per_DSTATUS]
      ,[per_HOSPITAL]
      ,[per_DOA]
      ,[per_DEATH_DA]
      ,[per_DEATH_MO]
      ,[per_DEATH_YR]
	  ,[per_DEATH_HR]
      ,[per_DEATH_MN]
      ,[per_DEATH_TM]
      ,[per_LAG_HRS]
      ,[per_LAG_MINS]
      ,[per_P_SF1]
      ,[per_P_SF2]
      ,[per_P_SF3]
      ,[per_WORK_INJ]
      ,[per_HISPANIC]
      ,[per_RACE]
      ,[per_LOCATION]
      ,[per_DRUG_TEST]
      ,[per_Drugs_Not_Tested]
      ,[per_Drugs_Negative]
      ,[per_Drugs_Not_Reported]
      ,[per_Drugs_Other]
      ,[per_Drugs_Tested_Result_Unknown]
      ,[per_Drugs_Tested_Positive_Unknown_Type]
      ,[per_Drugs_Unknown_if_tested]
      ,[per_Drugs_Narcotic]
      ,[per_Drugs_Depressant]
      ,[per_Drugs_Stimulant]
      ,[per_Drugs_Hallucinogen]
      ,[per_Drugs_Cannabinoid]
      ,[per_Drugs_PCP]
      ,[per_Drugs_Anabolic_Steroid]
      ,[per_Drugs_Inhalant]     
  FROM [FARS].[dbo].[raw_final_1]) as combined
--58,337

--Count columns in raw_final_1
SELECT COUNT(*)
FROM sys.columns
WHERE object_id = object_id('dbo.raw_final_2')
----304