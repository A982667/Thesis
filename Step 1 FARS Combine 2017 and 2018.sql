-------------------------------------------------------------------------
--Purpose: Combine 2017 and 2018 FARS Data Sets
--Author: Amy McNamara
--Date: 2020-01-18
-------------------------------------------------------------------------

-------------------------------------------------------------------------
--STEP 1 Combine 2017 and 2018 raw_acc_aux
--Create new Table raw_acc_aux
-------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_acc_aux]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_acc_aux]
END

select * into [dbo].[raw_acc_aux]
from 
	(select a.*
	from dbo.raw_acc_aux_2017 a

	union

	select a.*
	from dbo.raw_acc_aux_2018 a) as combined
--68,214 (34,560 + 33,654)

-------------------------------------------------------------------------
--STEP 2 Combine 2017 and 2018 raw_accident
--Create new Table raw_accident
-------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_accident]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_accident]
END

select * into [dbo].[raw_accident]
from 
	(select a.*
	from dbo.raw_accident_2017 a

	union

	select a.*
	from dbo.raw_accident_2018 a) as combined
--68,214

-------------------------------------------------------------------------
--STEP 3 Combine 2017 and 2018 raw_per_aux
--Create new Table raw_per_aux
-------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_per_aux]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_per_aux]
END

select * into [dbo].[raw_per_aux]
from 
	(select a.*
	from dbo.raw_per_aux_2017 a

	union

	select a.*
	from dbo.raw_per_aux_2018 a) as combined
--169,466 (85,840 + 83,626)

-------------------------------------------------------------------------
--STEP 4 Combine 2017 and 2018 raw_person
--Create new Table raw_per_aux
-------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_person]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_person]
END

select * into [dbo].[raw_person]
from 
	(select [STATE]
      ,[ST_CASE]
      ,[VE_FORMS]
      ,[VEH_NO]
      ,[PER_NO]
      ,[STR_VEH]
      ,[COUNTY]
      ,[DAY]
      ,[MONTH]
      ,[HOUR]
      ,[MINUTE]
      ,[RUR_URB]
      ,[FUNC_SYS]
      ,[HARM_EV]
      ,[MAN_COLL]
      ,[SCH_BUS]
      ,[MAKE]
      ,[MAK_MOD]
      ,[BODY_TYP]
      ,[MOD_YEAR]
      ,[TOW_VEH]
      ,[SPEC_USE]
      ,[EMER_USE]
      ,[ROLLOVER]
      ,[IMPACT1]
      ,[FIRE_EXP]
      ,[AGE]
      ,[SEX]
      ,[PER_TYP]
      ,[INJ_SEV]
      ,[SEAT_POS]
      ,[REST_USE]
      ,[REST_MIS]
      ,[AIR_BAG]
      ,[EJECTION]
      ,[EJ_PATH]
      ,[EXTRICAT]
      ,[DRINKING]
      ,[ALC_DET]
      ,[ALC_STATUS]
      ,[ATST_TYP]
      ,[ALC_RES]
      ,[DRUGS]
      ,[DRUG_DET]
      ,[DSTATUS]
      --,[DRUGTST1] handled with dbo.raw_drugs and DRUG Standardization.sql due to changes across years
      --,[DRUGTST2]
      --,[DRUGTST3]
      --,[DRUGRES1]
      --,[DRUGRES2]
      --,[DRUGRES3]
      ,[HOSPITAL]
      ,[DOA]
      ,[DEATH_DA]
      ,[DEATH_MO]
      ,[DEATH_YR]
      ,[DEATH_HR]
      ,[DEATH_MN]
      ,[DEATH_TM]
      ,[LAG_HRS]
      ,[LAG_MINS]
      ,[P_SF1]
      ,[P_SF2]
      ,[P_SF3]
      ,[WORK_INJ]
      ,[HISPANIC]
      ,[RACE]
      ,[LOCATION]
	  ,[YEAR]
	from dbo.raw_person_2017

	union

	select [STATE]
      ,[ST_CASE]
      ,[VE_FORMS]
      ,[VEH_NO]
      ,[PER_NO]
      ,[STR_VEH]
      ,[COUNTY]
      ,[DAY]
      ,[MONTH]
      ,[HOUR]
      ,[MINUTE]
      ,[RUR_URB]
      ,[FUNC_SYS]
      ,[HARM_EV]
      ,[MAN_COLL]
      ,[SCH_BUS]
      ,[MAKE]
      ,[MAK_MOD]
      ,[BODY_TYP]
      ,[MOD_YEAR]
      ,[TOW_VEH]
      ,[SPEC_USE]
      ,[EMER_USE]
      ,[ROLLOVER]
      ,[IMPACT1]
      ,[FIRE_EXP]
      ,[AGE]
      ,[SEX]
      ,[PER_TYP]
      ,[INJ_SEV]
      ,[SEAT_POS]
      ,[REST_USE]
      ,[REST_MIS]
      ,[AIR_BAG]
      ,[EJECTION]
      ,[EJ_PATH]
      ,[EXTRICAT]
      ,[DRINKING]
      ,[ALC_DET]
      ,[ALC_STATUS]
      ,[ATST_TYP]
      ,[ALC_RES]
      ,[DRUGS]
      ,[DRUG_DET]
      ,[DSTATUS]
      ,[HOSPITAL]
      ,[DOA]
      ,[DEATH_DA]
      ,[DEATH_MO]
      ,[DEATH_YR]
      ,[DEATH_HR]
      ,[DEATH_MN]
      ,[DEATH_TM]
      ,[LAG_HRS]
      ,[LAG_MINS]
      ,[P_SF1]
      ,[P_SF2]
      ,[P_SF3]
      ,[WORK_INJ]
      ,[HISPANIC]
      ,[RACE]
      ,[LOCATION]
	  ,[YEAR]
	from dbo.raw_person_2018) as combined
--169,466

-------------------------------------------------------------------------
--STEP 5 Combine 2017 and 2018 raw_veh_aux
--Create new Table raw_veh_aux
-------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_veh_aux]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_veh_aux]
END

select * into [dbo].[raw_veh_aux]
from 
	(select a.*
	from dbo.raw_veh_aux_2017 a

	union

	select a.*
	from dbo.raw_veh_aux_2018 a) as combined
--105,000 (53,128 + 51,872)


-------------------------------------------------------------------------
--STEP 6 Combine 2017 and 2018 raw_vehicle
--Create new Table raw_vehicle
-------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_vehicle]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_vehicle]
END

select * into [dbo].[raw_vehicle]
from 
	(select [STATE]
      ,[ST_CASE]
      ,[VEH_NO]
      ,[VE_FORMS]
      ,[NUMOCCS]
      ,[DAY]
      ,[MONTH]
      ,[HOUR]
      ,[MINUTE]
      ,[HARM_EV]
      ,[MAN_COLL]
      ,[UNITTYPE]
      ,[HIT_RUN]
      ,[REG_STAT]
      ,[OWNER]
      ,[MAKE]
      ,[MODEL]
      ,[MAK_MOD]
      ,[BODY_TYP]
      ,[MOD_YEAR]
      ,[VIN]
      ,[VIN_1]
      ,[VIN_2]
      ,[VIN_3]
      ,[VIN_4]
      ,[VIN_5]
      ,[VIN_6]
      ,[VIN_7]
      ,[VIN_8]
      ,[VIN_9]
      ,[VIN_10]
      ,[VIN_11]
      ,[VIN_12]
      ,[TOW_VEH]
      ,[J_KNIFE]
      ,[MCARR_I1]
      ,[MCARR_I2]
      ,[MCARR_ID]
      ,[GVWR]
      ,[V_CONFIG]
      ,[CARGO_BT]
      ,[HAZ_INV]
      ,[HAZ_PLAC]
      ,[HAZ_ID]
      ,[HAZ_CNO]
      ,[HAZ_REL]
      ,[BUS_USE]
      ,[SPEC_USE]
      ,[EMER_USE]
      ,[TRAV_SP]
      ,[UNDERIDE]
      ,[ROLLOVER]
      ,[ROLINLOC]
      ,[IMPACT1]
      ,[DEFORMED]
      ,[TOWED]
      ,[M_HARM]
      ,[VEH_SC1]
      ,[VEH_SC2]
      ,[FIRE_EXP]
      ,[DR_PRES]
      ,[L_STATE]
      ,[DR_ZIP]
      ,[L_STATUS]
      ,[L_TYPE]
      ,[CDL_STAT]
      ,[L_ENDORS]
      ,[L_COMPL]
      ,[L_RESTRI]
      ,[DR_HGT]
      ,[DR_WGT]
      ,[PREV_ACC]
      --,[PREV_SUS]
      ,[PREV_DWI]
      ,[PREV_SPD]
      ,[PREV_OTH]
      ,[FIRST_MO]
      ,[FIRST_YR]
      ,[LAST_MO]
      ,[LAST_YR]
      ,[SPEEDREL]
      ,[DR_SF1]
      ,[DR_SF2]
      ,[DR_SF3]
      ,[DR_SF4]
      ,[VTRAFWAY]
      ,[VNUM_LAN]
      ,[VSPD_LIM]
      ,[VALIGN]
      ,[VPROFILE]
      ,[VPAVETYP]
      ,[VSURCOND]
      ,[VTRAFCON]
      ,[VTCONT_F]
      ,[P_CRASH1]
      ,[P_CRASH2]
      ,[P_CRASH3]
      ,[PCRASH4]
      ,[PCRASH5]
      ,[ACC_TYPE]
      ,[TRLR1VIN]
      ,[TRLR2VIN]
      ,[TRLR3VIN]
      ,[DEATHS]
      ,[DR_DRINK]
	  ,[YEAR]
	from dbo.raw_vehicle_2017

	union

	select [STATE]
      ,[ST_CASE]
      ,[VEH_NO]
      ,[VE_FORMS]
      ,[NUMOCCS]
      ,[DAY]
      ,[MONTH]
      ,[HOUR]
      ,[MINUTE]
      ,[HARM_EV]
      ,[MAN_COLL]
      ,[UNITTYPE]
      ,[HIT_RUN]
      ,[REG_STAT]
      ,[OWNER]
      ,[MAKE]
      ,[MODEL]
      ,[MAK_MOD]
      ,[BODY_TYP]
      ,[MOD_YEAR]
      ,[VIN]
      ,[VIN_1]
      ,[VIN_2]
      ,[VIN_3]
      ,[VIN_4]
      ,[VIN_5]
      ,[VIN_6]
      ,[VIN_7]
      ,[VIN_8]
      ,[VIN_9]
      ,[VIN_10]
      ,[VIN_11]
      ,[VIN_12]
      ,[TOW_VEH]
      ,[J_KNIFE]
      ,[MCARR_I1]
      ,[MCARR_I2]
      ,[MCARR_ID]
      ,[GVWR]
      ,[V_CONFIG]
      ,[CARGO_BT]
      ,[HAZ_INV]
      ,[HAZ_PLAC]
      ,[HAZ_ID]
      ,[HAZ_CNO]
      ,[HAZ_REL]
      ,[BUS_USE]
      ,[SPEC_USE]
      ,[EMER_USE]
      ,[TRAV_SP]
      ,[UNDERIDE]
      ,[ROLLOVER]
      ,[ROLINLOC]
      ,[IMPACT1]
      ,[DEFORMED]
      ,[TOWED]
      ,[M_HARM]
      ,[VEH_SC1]
      ,[VEH_SC2]
      ,[FIRE_EXP]
      ,[DR_PRES]
      ,[L_STATE]
      ,[DR_ZIP]
      ,[L_STATUS]
      ,[L_TYPE]
      ,[CDL_STAT]
      ,[L_ENDORS]
      ,[L_COMPL]
      ,[L_RESTRI]
      ,[DR_HGT]
      ,[DR_WGT]
      ,[PREV_ACC]
      --,[PREV_SUS1]
      --,[PREV_SUS2]
      --,[PREV_SUS3]
      ,[PREV_DWI]
      ,[PREV_SPD]
      ,[PREV_OTH]
      ,[FIRST_MO]
      ,[FIRST_YR]
      ,[LAST_MO]
      ,[LAST_YR]
      ,[SPEEDREL]
      ,[DR_SF1]
      ,[DR_SF2]
      ,[DR_SF3]
      ,[DR_SF4]
      ,[VTRAFWAY]
      ,[VNUM_LAN]
      ,[VSPD_LIM]
      ,[VALIGN]
      ,[VPROFILE]
      ,[VPAVETYP]
      ,[VSURCOND]
      ,[VTRAFCON]
      ,[VTCONT_F]
      ,[P_CRASH1]
      ,[P_CRASH2]
      ,[P_CRASH3]
      ,[PCRASH4]
      ,[PCRASH5]
      ,[ACC_TYPE]
      ,[TRLR1VIN]
      ,[TRLR2VIN]
      ,[TRLR3VIN]
      ,[DEATHS]
      ,[DR_DRINK]
	  ,[YEAR]
	from dbo.raw_vehicle_2018) as combined
--105,000

