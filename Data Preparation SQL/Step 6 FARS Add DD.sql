---------------------------------------------------------------------------------
--Step 13
--Take dbo.raw_final_2 and replace codes with names for acc_aux
--create table dbo.raw_final_3
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_3]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_3]
END

select * into [dbo].[raw_final_3]
from 
	(SELECT  a.[Key]
      ,a.[acc_aux_STATE]
	  ,[aj].Name as acc_aux_STATE_nm
      ,a.[acc_aux_COUNTY]
      ,a.[acc_aux_FATALS]
      ,a.[acc_aux_A_CRAINJ]
      ,a.[acc_aux_A_REGION]
	  ,z.Name as acc_aux_A_REGION_nm
      ,a.[acc_aux_A_RU]
	  ,ad.Name as acc_aux_A_RU_nm
      ,a.[acc_aux_A_INTER]
	  ,n.Name as acc_aux_A_INTER_nm
      ,a.[acc_aux_A_RELRD]
	  ,aa.Name as acc_aux_A_RELRD_nm
      ,a.[acc_aux_A_INTSEC]
	  ,p.Name as acc_aux_A_INTSEC_nm
      ,a.[acc_aux_A_ROADFC]
	  ,ab.Name as acc_aux_A_ROADFC_nm
      ,a.[acc_aux_A_JUNC]
	  ,q.Name as acc_aux_A_JUNC_nm
      ,a.[acc_aux_A_MANCOL]
	  ,s.Name as acc_aux_A_MANCOL_nm
      ,a.[acc_aux_A_TOD]
	  ,[af].Name as acc_aux_A_TOD_nm
      ,a.[acc_aux_A_DOW]
	  ,k.Name as acc_aux_A_DOW_nm
      ,a.[acc_aux_A_CT]
	  ,b.Name as acc_aux_A_CT_nm
      ,a.[acc_aux_A_LT]
	  ,r.Name as acc_aux_A_LT_nm
      ,a.[acc_aux_A_MC]
	  ,t.Name as acc_aux_A_MC_nm
      ,a.[acc_aux_A_SPCRA]
	  ,[ae].Name as acc_aux_A_SPCRA_nm
      ,a.[acc_aux_A_PED]
	  ,u.Name as acc_aux_A_PED_nm
      ,a.[acc_aux_A_PED_F]
      ,a.[acc_aux_A_PEDAL]
	  ,v.Name as acc_aux_A_PEDAL_nm
      ,a.[acc_aux_A_PEDAL_F]
      ,a.[acc_aux_A_ROLL]
	  ,ac.Name as acc_aux_A_ROLL_nm
      ,a.[acc_aux_A_POLPUR]
	  ,w.Name as acc_aux_A_POLPUR_nm
      ,a.[acc_aux_A_POSBAC]
	  ,x.Name as acc_aux_A_POSBAC_nm
      ,a.[acc_aux_A_D15_19]
	  ,c.Name as acc_aux_A_D15_19_nm
      ,a.[acc_aux_A_D16_19]
	  ,e.Name as acc_aux_A_D16_19_nm
      ,a.[acc_aux_A_D15_20]
	  ,d.Name as acc_aux_A_D15_20_nm
      ,a.[acc_aux_A_D16_20]
	  ,f.Name as acc_aux_A_D16_20_nm
      ,a.[acc_aux_A_D65PLS]
	  ,i.Name as acc_aux_A_D65PLS_nm
      ,a.[acc_aux_A_D21_24]
	  ,h.Name as acc_aux_A_D21_24_nm
      ,a.[acc_aux_A_D16_24]
	  ,g.Name as acc_aux_A_D16_24_nm
      ,a.[acc_aux_A_RD]
	  ,y.Name as acc_aux_A_RD_nm
      ,a.[acc_aux_A_HR]
	  ,m.Name as acc_aux_A_HR_nm
      ,a.[acc_aux_A_DIST]
	  ,j.Name as acc_aux_A_DIST_nm
      ,a.[acc_aux_A_DROWSY]
	  ,l.Name as acc_aux_A_DROWSY_nm
      ,a.[acc_aux_BIA]
	  ,[ag].Name as acc_aux_BIA_nm
      ,a.[acc_aux_SPJ_INDIAN]
	  ,[ai].Name as acc_aux_SPJ_INDIAN_nm
      ,a.[acc_aux_INDIAN_RES]
	  ,[ah].Name as acc_aux_INDIAN_RES_nm
      ,a.[acc_VE_TOTAL]
      ,a.[acc_VE_FORMS]
      ,a.[acc_PVH_INVL]
      ,a.[acc_PEDS]
      ,a.[acc_PERNOTMVIT]
      ,a.[acc_PERMVIT]
      ,a.[acc_PERSONS]
      ,a.[acc_COUNTY]
      ,a.[acc_CITY]
      ,a.[acc_DAY]
      ,a.[acc_MONTH]
      ,a.[acc_YEAR]
      ,a.[acc_DAY_WEEK]
      ,a.[acc_HOUR]
      ,a.[acc_MINUTE]
      ,a.[acc_NHS]
      ,a.[acc_RUR_URB]
      ,a.[acc_FUNC_SYS]
      ,a.[acc_RD_OWNER]
      ,a.[acc_ROUTE]
      ,a.[acc_TWAY_ID]
      ,a.[acc_TWAY_ID2]
      ,a.[acc_MILEPT]
      ,a.[acc_LATITUDE]
      ,a.[acc_LONGITUD]
      ,a.[acc_SP_JUR]
      ,a.[acc_HARM_EV]
      ,a.[acc_MAN_COLL]
      ,a.[acc_RELJCT1]
      ,a.[acc_RELJCT2]
      ,a.[acc_TYP_INT]
      ,a.[acc_WRK_ZONE]
      ,a.[acc_REL_ROAD]
      ,a.[acc_LGT_COND]
      ,a.[acc_WEATHER1]
      ,a.[acc_WEATHER2]
      ,a.[acc_WEATHER]
      ,a.[acc_SCH_BUS]
      ,a.[acc_RAIL]
      ,a.[acc_NOT_HOUR]
      ,a.[acc_NOT_MIN]
      ,a.[acc_ARR_HOUR]
      ,a.[acc_ARR_MIN]
      ,a.[acc_HOSP_HR]
      ,a.[acc_HOSP_MN]
      ,a.[acc_CF1]
      ,a.[acc_CF2]
      ,a.[acc_CF3]
      ,a.[acc_FATALS]
      ,a.[acc_DRUNK_DR]
      ,a.[veh_aux_VEH_NO]
      ,a.[veh_aux_A_BODY]
      ,a.[veh_aux_A_IMP1]
      ,a.[veh_aux_A_VROLL]
      ,a.[veh_aux_A_LIC_S]
      ,a.[veh_aux_A_LIC_C]
      ,a.[veh_aux_A_CDL_S]
      ,a.[veh_aux_A_MC_L_S]
      ,a.[veh_aux_A_SPVEH]
      ,a.[veh_aux_A_SBUS]
      ,a.[veh_aux_A_MOD_YR]
      ,a.[veh_aux_A_DRDIS]
      ,a.[veh_aux_A_DRDRO]
      ,a.[veh_NUMOCCS]
      ,a.[veh_DAY]
      ,a.[veh_MONTH]
      ,a.[veh_HOUR]
      ,a.[veh_MINUTE]
      ,a.[veh_HARM_EV]
      ,a.[veh_MAN_COLL]
      ,a.[veh_UNITTYPE]
      ,a.[veh_HIT_RUN]
      ,a.[veh_REG_STAT]
      ,a.[veh_OWNER]
      ,a.[veh_MAKE]
      ,a.[veh_MODEL]
      ,a.[veh_MAK_MOD]
      ,a.[veh_BODY_TYP]
      ,a.[veh_MOD_YEAR]
      ,a.[veh_VIN]
      ,a.[veh_VIN_1]
      ,a.[veh_VIN_2]
      ,a.[veh_VIN_3]
      ,a.[veh_VIN_4]
      ,a.[veh_VIN_5]
      ,a.[veh_VIN_6]
      ,a.[veh_VIN_7]
      ,a.[veh_VIN_8]
      ,a.[veh_VIN_9]
      ,a.[veh_VIN_10]
      ,a.[veh_VIN_11]
      ,a.[veh_VIN_12]
      ,a.[veh_TOW_VEH]
      ,a.[veh_J_KNIFE]
      ,a.[veh_MCARR_11]
      ,a.[veh_MCARR_12]
      ,a.[veh_MCARR_ID]
      ,a.[veh_GVWR]
      ,a.[veh_V_CONFIG]
      ,a.[veh_CARGO_BT]
      ,a.[veh_HAZ_INV]
      ,a.[veh_HAZ_PLAC]
      ,a.[veh_HAZ_ID]
      ,a.[veh_HAZ_CNO]
      ,a.[veh_HAZ_REL]
      ,a.[veh_BUS_USE]
      ,a.[veh_SPEC_USE]
      ,a.[veh_EMER_USE]
      ,a.[veh_TRAV_SP]
      ,a.[veh_UNDERIDE]
      ,a.[veh_ROLLOVER]
      ,a.[veh_ROLINLOC]
      ,a.[veh_IMPACT1]
      ,a.[veh_DEFORMED]
      ,a.[veh_TOWED]
      ,a.[veh_M_HARM]
      ,a.[veh_VEH_SC1]
      ,a.[veh_VEH_SC2]
      ,a.[veh_FIRE_EXP]
      ,a.[veh_DR_PRES]
      ,a.[veh_L_STATE]
      ,a.[veh_DR_ZIP]
      ,a.[veh_L_STATUS]
      ,a.[veh_L_TYPE]
      ,a.[veh_CDL_STAT]
      ,a.[veh_L_ENDORS]
      ,a.[veh_L_COMPL]
      ,a.[veh_L_RESTRI]
      ,a.[veh_DR_HGT]
      ,a.[veh_DR_WGT]
      ,a.[veh_prev_sus]
      ,a.[veh_PREV_ACC]
      ,a.[veh_PREV_DWI]
      ,a.[veh_PREV_SPD]
      ,a.[veh_PREV_OTH]
      ,a.[veh_FIRST_MO]
      ,a.[veh_FIRST_YR]
      ,a.[veh_LAST_MO]
      ,a.[veh_LAST_YR]
      ,a.[veh_SPEEDREL]
      ,a.[veh_DR_SF1]
      ,a.[veh_DR_SF2]
      ,a.[veh_DR_SF3]
      ,a.[veh_DR_SF4]
      ,a.[veh_VTRAFWAY]
      ,a.[veh_VNUM_LAN]
      ,a.[veh_VSPD_LIM]
      ,a.[veh_VALIGN]
      ,a.[veh_VPROFILE]
      ,a.[veh_VPAVETYP]
      ,a.[veh_VSURCOND]
      ,a.[veh_VTRAFCON]
      ,a.[veh_VTCONT_F]
      ,a.[veh_P_CRASH1]
      ,a.[veh_P_CRASH2]
      ,a.[veh_P_CRASH3]
      ,a.[veh_P_CRASH4]
      ,a.[veh_P_CRASH5]
      ,a.[veh_ACC_TYPE]
      ,a.[veh_TRLR1VIN]
      ,a.[veh_TRLR2VIN]
      ,a.[veh_TRLR3VIN]
      ,a.[veh_DEATHS]
      ,a.[veh_DR_DRINK]
      ,a.[oth_veh_prev_sus]
      ,a.[oth_veh_PREV_ACC]
      ,a.[oth_veh_PREV_DWI]
      ,a.[oth_veh_PREV_SPD]
      ,a.[oth_veh_PREV_OTH]
      ,a.[per_aux_A_AGE1]
      ,a.[per_aux_A_AGE2]
      ,a.[per_aux_A_AGE3]
      ,a.[per_aux_A_AGE4]
      ,a.[per_aux_A_AGE5]
      ,a.[per_aux_A_AGE6]
      ,a.[per_aux_A_AGE7]
      ,a.[per_aux_A_AGE8]
      ,a.[per_aux_A_AGE9]
      ,a.[per_aux_PER_NO]
      ,a.[per_aux_A_PTYPE]
      ,a.[per_aux_A_RESTUSE]
      ,a.[per_aux_A_HELMUSE]
      ,a.[per_aux_A_ALCTES]
      ,a.[per_aux_A_HISP]
      ,a.[per_aux_A_RCAT]
      ,a.[per_aux_A_HRACE]
      ,a.[per_aux_A_EJECT]
      ,a.[per_aux_A_PERINJ]
      ,a.[per_aux_A_LOC]
      ,a.[per_STR_VEH]
      ,a.[per_COUNTY]
      ,a.[per_DAY]
      ,a.[per_MONTH]
      ,a.[per_HOUR]
      ,a.[per_MINUTE]
      ,a.[per_RUR_URB]
      ,a.[per_FUNC_SYS]
      ,a.[per_HARM_EV]
      ,a.[per_MAN_COLL]
      ,a.[per_SCH_BUS]
      ,a.[per_MAKE]
      ,a.[per_MAK_MOD]
      ,a.[per_BODY_TYP]
      ,a.[per_MOD_YEAR]
      ,a.[per_TOW_VEH]
      ,a.[per_SPEC_USE]
      ,a.[per_EMER_USE]
      ,a.[per_ROLLOVER]
      ,a.[per_IMPACT1]
      ,a.[per_FIRE_EXP]
      ,a.[per_AGE]
      ,a.[per_SEX]
      ,a.[per_PER_TYPE]
      ,a.[per_INJ_SEV]
      ,a.[per_SEAT_POS]
      ,a.[per_REST_USE]
      ,a.[per_REST_MIS]
      ,a.[per_AIG_BAG]
      ,a.[per_EJECTION]
      ,a.[per_EJ_PATH]
      ,a.[per_EXTRICAT]
      ,a.[per_DRINKING]
      ,a.[per_ALC_DET]
      ,a.[per_ALC_STATUS]
      ,a.[per_ATST_TYPE]
      ,a.[per_ALC_RES]
      ,a.[per_DRUGS]
      ,a.[per_DRUG_DET]
      ,a.[per_DSTATUS]
      ,a.[per_HOSPITAL]
      ,a.[per_DOA]
      ,a.[per_DEATH_DA]
      ,a.[per_DEATH_MO]
      ,a.[per_DEATH_YR]
      ,a.[per_DEATH_HR]
      ,a.[per_DEATH_MN]
      ,a.[per_DEATH_TM]
      ,a.[per_LAG_HRS]
      ,a.[per_LAG_MINS]
      ,a.[per_P_SF1]
      ,a.[per_P_SF2]
      ,a.[per_P_SF3]
      ,a.[per_WORK_INJ]
      ,a.[per_HISPANIC]
      ,a.[per_RACE]
      ,a.[per_LOCATION]
      ,a.[per_DRUG_TEST]
      ,a.[per_Drugs_Not_Tested]
      ,a.[per_Drugs_Negative]
      ,a.[per_Drugs_Not_Reported]
      ,a.[per_Drugs_Other]
      ,a.[per_Drugs_Tested_Result_Unknown]
      ,a.[per_Drugs_Tested_Positive_Unknown_Type]
      ,a.[per_Drugs_Unknown_if_tested]
      ,a.[per_Drugs_Narcotic]
      ,a.[per_Drugs_Depressant]
      ,a.[per_Drugs_Stimulant]
      ,a.[per_Drugs_Hallucinogen]
      ,a.[per_Drugs_Cannabinoid]
      ,a.[per_Drugs_PCP]
      ,a.[per_Drugs_Anabolic_Steroid]
      ,a.[per_Drugs_Inhalant]
  FROM [FARS].[dbo].[raw_final_2] a
  left join [dbo].[v_acc_aux_A_CT] b
	on a.acc_aux_A_CT = b.value
  left join [dbo].[v_acc_aux_A_D15_19] c
	on a.acc_aux_A_D15_19=c.value
  left join [dbo].[v_acc_aux_A_D15_20] d
	on a.acc_aux_A_D15_20=d.value
  left join [dbo].[v_acc_aux_A_D16_19] e
	on a.acc_aux_A_D16_19=e.value
  left join [dbo].[v_acc_aux_A_D16_20] f
    on a.acc_aux_A_D16_20=f.value
  left join [dbo].[v_acc_aux_A_D16_24] g
   on a.acc_aux_A_D16_24=g.value
  left join [dbo].[v_acc_aux_A_D21_24] h
    on a.acc_aux_A_D21_24=h.value
  left join [dbo].[v_acc_aux_A_D65PLS] i
	on a.acc_aux_A_D65PLS=i.value
  left join [dbo].[v_acc_aux_A_DIST] j
	on a.acc_aux_A_DIST=j.value
  left join [dbo].[v_acc_aux_A_DOW] k
	on a.acc_aux_A_DOW=k.value
  left join [dbo].[v_acc_aux_A_DROWSY] l
    on a.acc_aux_A_DROWSY=l.value
  left join [dbo].[v_acc_aux_A_HR] m
    on a.acc_aux_A_HR=m.value
  left join [dbo].[v_acc_aux_A_INTER] n
	on a.acc_aux_A_INTER=n.value
  left join [dbo].[v_acc_aux_A_INTSEC] p
   on a.acc_aux_A_INTSEC=p.value
  left join [dbo].[v_acc_aux_A_JUNC] q
   on a.acc_aux_A_JUNC=q.value
  left join [dbo].[v_acc_aux_A_LT] r
    on a.acc_aux_A_LT=r.value
  left join [dbo].[v_acc_aux_A_MANCOL] s
    on a.acc_aux_A_MANCOL=s.value
  left join [dbo].[v_acc_aux_A_MC] t
    on a.acc_aux_A_MC=t.value
  left join [dbo].[v_acc_aux_A_PED] u
    on a.acc_aux_A_PED=u.value
  left join [dbo].[v_acc_aux_A_PEDAL] v
    on a.acc_aux_A_PEDAL=v.value
  left join [dbo].[v_acc_aux_A_POLPUR] w
    on a.acc_aux_A_POLPUR=w.value
  left join [dbo].[v_acc_aux_A_POSBAC] x
    on a.acc_aux_A_POSBAC=x.value
  left join [dbo].[v_acc_aux_A_RD] y
    on a.acc_aux_A_RD=y.value
  left join [dbo].[v_acc_aux_A_REGION] z
    on a.acc_aux_A_REGION=z.value
  left join [dbo].[v_acc_aux_A_RELRD] aa
    on a.acc_aux_A_RELRD=aa.value
  left join [dbo].[v_acc_aux_A_ROADFC] ab
    on a.acc_aux_A_ROADFC=ab.value
  left join [dbo].[v_acc_aux_A_ROLL] ac
    on a.acc_aux_A_ROLL=ac.value
  left join [dbo].[v_acc_aux_A_RU] ad
    on a.acc_aux_A_RU=ad.value
  left join [dbo].[v_acc_aux_A_SPCRA] [ae]
    on a.acc_aux_A_SPCRA=[ae].value
  left join [dbo].[v_acc_aux_A_TOD] [af]
    on a.acc_aux_A_TOD=[af].value
  left join [dbo].[v_acc_aux_BIA] [ag]
    on a.acc_aux_BIA=[ag].value
  left join [dbo].[v_acc_aux_INDIAN_RES] [ah]
    on a.acc_aux_INDIAN_RES=[ah].value
  left join [dbo].[v_acc_aux_SPJ_INDIAN] [ai]
    on a.acc_aux_SPJ_INDIAN=[ai].value
  left join [dbo].[v_acc_aux_STATE] [aj]
	on a.acc_aux_STATE=[aj].value ) as combined

---------------------------------------------------------------------------------
--Step 14
--Take dbo.raw_final_3 and replace codes with names for per_aux
--create table dbo.raw_final_4
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_4]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_4]
END

select * into [dbo].[raw_final_4]
from 
	(Select a.[Key]
      ,a.[acc_aux_STATE]
      ,a.[acc_aux_STATE_nm]
      ,a.[acc_aux_COUNTY]
      ,a.[acc_aux_FATALS]
      ,a.[acc_aux_A_CRAINJ]
      ,a.[acc_aux_A_REGION]
      ,a.[acc_aux_A_REGION_nm]
      ,a.[acc_aux_A_RU]
      ,a.[acc_aux_A_RU_nm]
      ,a.[acc_aux_A_INTER]
      ,a.[acc_aux_A_INTER_nm]
      ,a.[acc_aux_A_RELRD]
      ,a.[acc_aux_A_RELRD_nm]
      ,a.[acc_aux_A_INTSEC]
      ,a.[acc_aux_A_INTSEC_nm]
      ,a.[acc_aux_A_ROADFC]
      ,a.[acc_aux_A_ROADFC_nm]
      ,a.[acc_aux_A_JUNC]
      ,a.[acc_aux_A_JUNC_nm]
      ,a.[acc_aux_A_MANCOL]
      ,a.[acc_aux_A_MANCOL_nm]
      ,a.[acc_aux_A_TOD]
      ,a.[acc_aux_A_TOD_nm]
      ,a.[acc_aux_A_DOW]
      ,a.[acc_aux_A_DOW_nm]
      ,a.[acc_aux_A_CT]
      ,a.[acc_aux_A_CT_nm]
      ,a.[acc_aux_A_LT]
      ,a.[acc_aux_A_LT_nm]
      ,a.[acc_aux_A_MC]
      ,a.[acc_aux_A_MC_nm]
      ,a.[acc_aux_A_SPCRA]
      ,a.[acc_aux_A_SPCRA_nm]
      ,a.[acc_aux_A_PED]
      ,a.[acc_aux_A_PED_nm]
      ,a.[acc_aux_A_PED_F]
      ,a.[acc_aux_A_PEDAL]
      ,a.[acc_aux_A_PEDAL_nm]
      ,a.[acc_aux_A_PEDAL_F]
      ,a.[acc_aux_A_ROLL]
      ,a.[acc_aux_A_ROLL_nm]
      ,a.[acc_aux_A_POLPUR]
      ,a.[acc_aux_A_POLPUR_nm]
      ,a.[acc_aux_A_POSBAC]
      ,a.[acc_aux_A_POSBAC_nm]
      ,a.[acc_aux_A_D15_19]
      ,a.[acc_aux_A_D15_19_nm]
      ,a.[acc_aux_A_D16_19]
      ,a.[acc_aux_A_D16_19_nm]
      ,a.[acc_aux_A_D15_20]
      ,a.[acc_aux_A_D15_20_nm]
      ,a.[acc_aux_A_D16_20]
      ,a.[acc_aux_A_D16_20_nm]
      ,a.[acc_aux_A_D65PLS]
      ,a.[acc_aux_A_D65PLS_nm]
      ,a.[acc_aux_A_D21_24]
      ,a.[acc_aux_A_D21_24_nm]
      ,a.[acc_aux_A_D16_24]
      ,a.[acc_aux_A_D16_24_nm]
      ,a.[acc_aux_A_RD]
      ,a.[acc_aux_A_RD_nm]
      ,a.[acc_aux_A_HR]
      ,a.[acc_aux_A_HR_nm]
      ,a.[acc_aux_A_DIST]
      ,a.[acc_aux_A_DIST_nm]
      ,a.[acc_aux_A_DROWSY]
      ,a.[acc_aux_A_DROWSY_nm]
      ,a.[acc_aux_BIA]
      ,a.[acc_aux_BIA_nm]
      ,a.[acc_aux_SPJ_INDIAN]
      ,a.[acc_aux_SPJ_INDIAN_nm]
      ,a.[acc_aux_INDIAN_RES]
      ,a.[acc_aux_INDIAN_RES_nm]
      ,a.[acc_VE_TOTAL]
      ,a.[acc_VE_FORMS]
      ,a.[acc_PVH_INVL]
      ,a.[acc_PEDS]
      ,a.[acc_PERNOTMVIT]
      ,a.[acc_PERMVIT]
      ,a.[acc_PERSONS]
      ,a.[acc_COUNTY]
      ,a.[acc_CITY]
      ,a.[acc_DAY]
      ,a.[acc_MONTH]
      ,a.[acc_YEAR]
      ,a.[acc_DAY_WEEK]
      ,a.[acc_HOUR]
      ,a.[acc_MINUTE]
      ,a.[acc_NHS]
      ,a.[acc_RUR_URB]
      ,a.[acc_FUNC_SYS]
      ,a.[acc_RD_OWNER]
      ,a.[acc_ROUTE]
      ,a.[acc_TWAY_ID]
      ,a.[acc_TWAY_ID2]
      ,a.[acc_MILEPT]
      ,a.[acc_LATITUDE]
      ,a.[acc_LONGITUD]
      ,a.[acc_SP_JUR]
      ,a.[acc_HARM_EV]
      ,a.[acc_MAN_COLL]
      ,a.[acc_RELJCT1]
      ,a.[acc_RELJCT2]
      ,a.[acc_TYP_INT]
      ,a.[acc_WRK_ZONE]
      ,a.[acc_REL_ROAD]
      ,a.[acc_LGT_COND]
      ,a.[acc_WEATHER1]
      ,a.[acc_WEATHER2]
      ,a.[acc_WEATHER]
      ,a.[acc_SCH_BUS]
      ,a.[acc_RAIL]
      ,a.[acc_NOT_HOUR]
      ,a.[acc_NOT_MIN]
      ,a.[acc_ARR_HOUR]
      ,a.[acc_ARR_MIN]
      ,a.[acc_HOSP_HR]
      ,a.[acc_HOSP_MN]
      ,a.[acc_CF1]
      ,a.[acc_CF2]
      ,a.[acc_CF3]
      ,a.[acc_FATALS]
      ,a.[acc_DRUNK_DR]
      ,a.[veh_aux_VEH_NO]
      ,a.[veh_aux_A_BODY]
      ,a.[veh_aux_A_IMP1]
      ,a.[veh_aux_A_VROLL]
      ,a.[veh_aux_A_LIC_S]
      ,a.[veh_aux_A_LIC_C]
      ,a.[veh_aux_A_CDL_S]
      ,a.[veh_aux_A_MC_L_S]
      ,a.[veh_aux_A_SPVEH]
      ,a.[veh_aux_A_SBUS]
      ,a.[veh_aux_A_MOD_YR]
      ,a.[veh_aux_A_DRDIS]
      ,a.[veh_aux_A_DRDRO]
      ,a.[veh_NUMOCCS]
      ,a.[veh_DAY]
      ,a.[veh_MONTH]
      ,a.[veh_HOUR]
      ,a.[veh_MINUTE]
      ,a.[veh_HARM_EV]
      ,a.[veh_MAN_COLL]
      ,a.[veh_UNITTYPE]
      ,a.[veh_HIT_RUN]
      ,a.[veh_REG_STAT]
      ,a.[veh_OWNER]
      ,a.[veh_MAKE]
      ,a.[veh_MODEL]
      ,a.[veh_MAK_MOD]
      ,a.[veh_BODY_TYP]
      ,a.[veh_MOD_YEAR]
      ,a.[veh_VIN]
      ,a.[veh_VIN_1]
      ,a.[veh_VIN_2]
      ,a.[veh_VIN_3]
      ,a.[veh_VIN_4]
      ,a.[veh_VIN_5]
      ,a.[veh_VIN_6]
      ,a.[veh_VIN_7]
      ,a.[veh_VIN_8]
      ,a.[veh_VIN_9]
      ,a.[veh_VIN_10]
      ,a.[veh_VIN_11]
      ,a.[veh_VIN_12]
      ,a.[veh_TOW_VEH]
      ,a.[veh_J_KNIFE]
      ,a.[veh_MCARR_11]
      ,a.[veh_MCARR_12]
      ,a.[veh_MCARR_ID]
      ,a.[veh_GVWR]
      ,a.[veh_V_CONFIG]
      ,a.[veh_CARGO_BT]
      ,a.[veh_HAZ_INV]
      ,a.[veh_HAZ_PLAC]
      ,a.[veh_HAZ_ID]
      ,a.[veh_HAZ_CNO]
      ,a.[veh_HAZ_REL]
      ,a.[veh_BUS_USE]
      ,a.[veh_SPEC_USE]
      ,a.[veh_EMER_USE]
      ,a.[veh_TRAV_SP]
      ,a.[veh_UNDERIDE]
      ,a.[veh_ROLLOVER]
      ,a.[veh_ROLINLOC]
      ,a.[veh_IMPACT1]
      ,a.[veh_DEFORMED]
      ,a.[veh_TOWED]
      ,a.[veh_M_HARM]
      ,a.[veh_VEH_SC1]
      ,a.[veh_VEH_SC2]
      ,a.[veh_FIRE_EXP]
      ,a.[veh_DR_PRES]
      ,a.[veh_L_STATE]
      ,a.[veh_DR_ZIP]
      ,a.[veh_L_STATUS]
      ,a.[veh_L_TYPE]
      ,a.[veh_CDL_STAT]
      ,a.[veh_L_ENDORS]
      ,a.[veh_L_COMPL]
      ,a.[veh_L_RESTRI]
      ,a.[veh_DR_HGT]
      ,a.[veh_DR_WGT]
      ,a.[veh_prev_sus]
      ,a.[veh_PREV_ACC]
      ,a.[veh_PREV_DWI]
      ,a.[veh_PREV_SPD]
      ,a.[veh_PREV_OTH]
      ,a.[veh_FIRST_MO]
      ,a.[veh_FIRST_YR]
      ,a.[veh_LAST_MO]
      ,a.[veh_LAST_YR]
      ,a.[veh_SPEEDREL]
      ,a.[veh_DR_SF1]
      ,a.[veh_DR_SF2]
      ,a.[veh_DR_SF3]
      ,a.[veh_DR_SF4]
      ,a.[veh_VTRAFWAY]
      ,a.[veh_VNUM_LAN]
      ,a.[veh_VSPD_LIM]
      ,a.[veh_VALIGN]
      ,a.[veh_VPROFILE]
      ,a.[veh_VPAVETYP]
      ,a.[veh_VSURCOND]
      ,a.[veh_VTRAFCON]
      ,a.[veh_VTCONT_F]
      ,a.[veh_P_CRASH1]
      ,a.[veh_P_CRASH2]
      ,a.[veh_P_CRASH3]
      ,a.[veh_P_CRASH4]
      ,a.[veh_P_CRASH5]
      ,a.[veh_ACC_TYPE]
      ,a.[veh_TRLR1VIN]
      ,a.[veh_TRLR2VIN]
      ,a.[veh_TRLR3VIN]
      ,a.[veh_DEATHS]
      ,a.[veh_DR_DRINK]
      ,a.[oth_veh_prev_sus]
      ,a.[oth_veh_PREV_ACC]
      ,a.[oth_veh_PREV_DWI]
      ,a.[oth_veh_PREV_SPD]
      ,a.[oth_veh_PREV_OTH]
      ,a.[per_aux_A_AGE1]
	  ,b.Name as per_aux_A_AGE1_nm
      ,a.[per_aux_A_AGE2]
	  ,c.Name as per_aux_A_AGE2_nm
      ,a.[per_aux_A_AGE3]
	  ,d.Name as per_aux_A_AGE3_nm
      ,a.[per_aux_A_AGE4]
	  ,e.Name as per_aux_A_AGE4_nm
      ,a.[per_aux_A_AGE5]
	  ,f.Name as per_aux_A_AGE5_nm
      ,a.[per_aux_A_AGE6]
	  ,g.Name as per_aux_A_AGE6_nm
      ,a.[per_aux_A_AGE7]
	  ,h.Name as per_aux_A_AGE7_nm
      ,a.[per_aux_A_AGE8]
	  ,i.Name as per_aux_A_AGE8_nm
      ,a.[per_aux_A_AGE9]
	  ,j.Name as per_aux_A_AGE9_nm
      ,a.[per_aux_PER_NO] --int, part of key
      ,a.[per_aux_A_PTYPE]
	  ,p.Name as per_aux_A_PTYPE_nm
      ,a.[per_aux_A_RESTUSE]
	  ,r.Name as per_aux_A_RESTUSE_nm
      ,a.[per_aux_A_HELMUSE]
	  ,m.Name as per_aux_A_HELMUSE_nm
      ,a.[per_aux_A_ALCTES]
	  ,k.Name as per_aux_A_ALCTES_nm
      ,a.[per_aux_A_HISP]
	  ,n.Name as per_aux_A_HISP_nm
      ,a.[per_aux_A_RCAT]
	  ,q.Name as per_aux_A_RCAT_nm
      ,a.[per_aux_A_HRACE]
	  ,o.Name as per_aux_A_HRACE_nm
      ,a.[per_aux_A_EJECT]
	  ,l.Name as per_aux_A_EJECT_nm
      ,a.[per_aux_A_PERINJ] --not retaining as unary
      ,a.[per_aux_A_LOC]  --not retaining as unary
      ,a.[per_STR_VEH]
      ,a.[per_COUNTY]
      ,a.[per_DAY]
      ,a.[per_MONTH]
      ,a.[per_HOUR]
      ,a.[per_MINUTE]
      ,a.[per_RUR_URB]
      ,a.[per_FUNC_SYS]
      ,a.[per_HARM_EV]
      ,a.[per_MAN_COLL]
      ,a.[per_SCH_BUS]
      ,a.[per_MAKE]
      ,a.[per_MAK_MOD]
      ,a.[per_BODY_TYP]
      ,a.[per_MOD_YEAR]
      ,a.[per_TOW_VEH]
      ,a.[per_SPEC_USE]
      ,a.[per_EMER_USE]
      ,a.[per_ROLLOVER]
      ,a.[per_IMPACT1]
      ,a.[per_FIRE_EXP]
      ,a.[per_AGE]
      ,a.[per_SEX]
      ,a.[per_PER_TYPE]
      ,a.[per_INJ_SEV]
      ,a.[per_SEAT_POS]
      ,a.[per_REST_USE]
      ,a.[per_REST_MIS]
      ,a.[per_AIG_BAG]
      ,a.[per_EJECTION]
      ,a.[per_EJ_PATH]
      ,a.[per_EXTRICAT]
      ,a.[per_DRINKING]
      ,a.[per_ALC_DET]
      ,a.[per_ALC_STATUS]
      ,a.[per_ATST_TYPE]
      ,a.[per_ALC_RES]
      ,a.[per_DRUGS]
      ,a.[per_DRUG_DET]
      ,a.[per_DSTATUS]
      ,a.[per_HOSPITAL]
      ,a.[per_DOA]
      ,a.[per_DEATH_DA]
      ,a.[per_DEATH_MO]
      ,a.[per_DEATH_YR]
      ,a.[per_DEATH_HR]
      ,a.[per_DEATH_MN]
      ,a.[per_DEATH_TM]
      ,a.[per_LAG_HRS]
      ,a.[per_LAG_MINS]
      ,a.[per_P_SF1]
      ,a.[per_P_SF2]
      ,a.[per_P_SF3]
      ,a.[per_WORK_INJ]
      ,a.[per_HISPANIC]
      ,a.[per_RACE]
      ,a.[per_LOCATION]
      ,a.[per_DRUG_TEST]
      ,a.[per_Drugs_Not_Tested]
      ,a.[per_Drugs_Negative]
      ,a.[per_Drugs_Not_Reported]
      ,a.[per_Drugs_Other]
      ,a.[per_Drugs_Tested_Result_Unknown]
      ,a.[per_Drugs_Tested_Positive_Unknown_Type]
      ,a.[per_Drugs_Unknown_if_tested]
      ,a.[per_Drugs_Narcotic]
      ,a.[per_Drugs_Depressant]
      ,a.[per_Drugs_Stimulant]
      ,a.[per_Drugs_Hallucinogen]
      ,a.[per_Drugs_Cannabinoid]
      ,a.[per_Drugs_PCP]
      ,a.[per_Drugs_Anabolic_Steroid]
      ,a.[per_Drugs_Inhalant]
  FROM [FARS].[dbo].[raw_final_3] a
  left join [dbo].[v_per_aux_A_AGE1] b
	on a.per_aux_A_AGE1=b.value
  left join [dbo].[v_per_aux_A_AGE2] c
    on a.per_aux_A_AGE2=c.value
  left join [dbo].[v_per_aux_A_AGE3] d
    on a.per_aux_A_AGE3=d.value
  left join [dbo].[v_per_aux_A_AGE4] e
    on a.per_aux_A_AGE4=e.value
  left join [dbo].[v_per_aux_A_AGE5] f
    on a.per_aux_A_AGE5=f.value
  left join [dbo].[v_per_aux_A_AGE6] g
	on a.per_aux_A_AGE6=g.value
  left join [dbo].[v_per_aux_A_AGE7] h
	on a.per_aux_A_AGE7=h.value
  left join [dbo].[v_per_aux_A_AGE8] i
	on a.per_aux_A_AGE8=i.value
  left join [dbo].[v_per_aux_A_AGE9] j
	on a.per_aux_A_AGE9=j.value
  left join [dbo].[v_per_aux_A_ALCTES] k
	on a.per_aux_A_ALCTES=k.value
  left join [dbo].[v_per_aux_A_EJECT] l
    on a.per_aux_A_EJECT=l.value
  left join [dbo].[v_per_aux_A_HELMUSE] m
   on a.per_aux_A_HELMUSE=m.value
  left join [dbo].[v_per_aux_A_HISP] n
   on a.per_aux_A_HISP=n.value
  left join [dbo].[v_per_aux_A_HRACE] o
   on a.per_aux_A_HRACE=o.value
  left join [dbo].[v_per_aux_A_PTYPE] p
	on a.per_aux_A_PTYPE=p.value
  left join [dbo].[v_per_aux_A_RCAT] q
    on a.per_aux_A_RCAT=q.value
  left join [dbo].[v_per_aux_A_RESTUSE] r
   on a.per_aux_A_RESTUSE=r.value) as combined

---------------------------------------------------------------------------------
--Step 15
--Take dbo.raw_final_4 and replace codes with names for veh_aux
--create table dbo.raw_final_5
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_5]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_5]
END

select * into [dbo].[raw_final_5]
from 
	(Select a.[Key]
      ,a.[acc_aux_STATE]
      ,a.[acc_aux_STATE_nm]
      ,a.[acc_aux_COUNTY]
      ,a.[acc_aux_FATALS]
      ,a.[acc_aux_A_CRAINJ]
      ,a.[acc_aux_A_REGION]
      ,a.[acc_aux_A_REGION_nm]
      ,a.[acc_aux_A_RU]
      ,a.[acc_aux_A_RU_nm]
      ,a.[acc_aux_A_INTER]
      ,a.[acc_aux_A_INTER_nm]
      ,a.[acc_aux_A_RELRD]
      ,a.[acc_aux_A_RELRD_nm]
      ,a.[acc_aux_A_INTSEC]
      ,a.[acc_aux_A_INTSEC_nm]
      ,a.[acc_aux_A_ROADFC]
      ,a.[acc_aux_A_ROADFC_nm]
      ,a.[acc_aux_A_JUNC]
      ,a.[acc_aux_A_JUNC_nm]
      ,a.[acc_aux_A_MANCOL]
      ,a.[acc_aux_A_MANCOL_nm]
      ,a.[acc_aux_A_TOD]
      ,a.[acc_aux_A_TOD_nm]
      ,a.[acc_aux_A_DOW]
      ,a.[acc_aux_A_DOW_nm]
      ,a.[acc_aux_A_CT]
      ,a.[acc_aux_A_CT_nm]
      ,a.[acc_aux_A_LT]
      ,a.[acc_aux_A_LT_nm]
      ,a.[acc_aux_A_MC]
      ,a.[acc_aux_A_MC_nm]
      ,a.[acc_aux_A_SPCRA]
      ,a.[acc_aux_A_SPCRA_nm]
      ,a.[acc_aux_A_PED]
      ,a.[acc_aux_A_PED_nm]
      ,a.[acc_aux_A_PED_F]
      ,a.[acc_aux_A_PEDAL]
      ,a.[acc_aux_A_PEDAL_nm]
      ,a.[acc_aux_A_PEDAL_F]
      ,a.[acc_aux_A_ROLL]
      ,a.[acc_aux_A_ROLL_nm]
      ,a.[acc_aux_A_POLPUR]
      ,a.[acc_aux_A_POLPUR_nm]
      ,a.[acc_aux_A_POSBAC]
      ,a.[acc_aux_A_POSBAC_nm]
      ,a.[acc_aux_A_D15_19]
      ,a.[acc_aux_A_D15_19_nm]
      ,a.[acc_aux_A_D16_19]
      ,a.[acc_aux_A_D16_19_nm]
      ,a.[acc_aux_A_D15_20]
      ,a.[acc_aux_A_D15_20_nm]
      ,a.[acc_aux_A_D16_20]
      ,a.[acc_aux_A_D16_20_nm]
      ,a.[acc_aux_A_D65PLS]
      ,a.[acc_aux_A_D65PLS_nm]
      ,a.[acc_aux_A_D21_24]
      ,a.[acc_aux_A_D21_24_nm]
      ,a.[acc_aux_A_D16_24]
      ,a.[acc_aux_A_D16_24_nm]
      ,a.[acc_aux_A_RD]
      ,a.[acc_aux_A_RD_nm]
      ,a.[acc_aux_A_HR]
      ,a.[acc_aux_A_HR_nm]
      ,a.[acc_aux_A_DIST]
      ,a.[acc_aux_A_DIST_nm]
      ,a.[acc_aux_A_DROWSY]
      ,a.[acc_aux_A_DROWSY_nm]
      ,a.[acc_aux_BIA]
      ,a.[acc_aux_BIA_nm]
      ,a.[acc_aux_SPJ_INDIAN]
      ,a.[acc_aux_SPJ_INDIAN_nm]
      ,a.[acc_aux_INDIAN_RES]
      ,a.[acc_aux_INDIAN_RES_nm]
      ,a.[acc_VE_TOTAL]
      ,a.[acc_VE_FORMS]
      ,a.[acc_PVH_INVL]
      ,a.[acc_PEDS]
      ,a.[acc_PERNOTMVIT]
      ,a.[acc_PERMVIT]
      ,a.[acc_PERSONS]
      ,a.[acc_COUNTY]
      ,a.[acc_CITY]
      ,a.[acc_DAY]
      ,a.[acc_MONTH]
      ,a.[acc_YEAR]
      ,a.[acc_DAY_WEEK]
      ,a.[acc_HOUR]
      ,a.[acc_MINUTE]
      ,a.[acc_NHS]
      ,a.[acc_RUR_URB]
      ,a.[acc_FUNC_SYS]
      ,a.[acc_RD_OWNER]
      ,a.[acc_ROUTE]
      ,a.[acc_TWAY_ID]
      ,a.[acc_TWAY_ID2]
      ,a.[acc_MILEPT]
      ,a.[acc_LATITUDE]
      ,a.[acc_LONGITUD]
      ,a.[acc_SP_JUR]
      ,a.[acc_HARM_EV]
      ,a.[acc_MAN_COLL]
      ,a.[acc_RELJCT1]
      ,a.[acc_RELJCT2]
      ,a.[acc_TYP_INT]
      ,a.[acc_WRK_ZONE]
      ,a.[acc_REL_ROAD]
      ,a.[acc_LGT_COND]
      ,a.[acc_WEATHER1]
      ,a.[acc_WEATHER2]
      ,a.[acc_WEATHER]
      ,a.[acc_SCH_BUS]
      ,a.[acc_RAIL]
      ,a.[acc_NOT_HOUR]
      ,a.[acc_NOT_MIN]
      ,a.[acc_ARR_HOUR]
      ,a.[acc_ARR_MIN]
      ,a.[acc_HOSP_HR]
      ,a.[acc_HOSP_MN]
      ,a.[acc_CF1]
      ,a.[acc_CF2]
      ,a.[acc_CF3]
      ,a.[acc_FATALS]
      ,a.[acc_DRUNK_DR]
      ,a.[veh_aux_VEH_NO] -- int, part of key
      ,a.[veh_aux_A_BODY]
	  ,b.Name as veh_aux_A_BODY_nm
      ,a.[veh_aux_A_IMP1]
	  ,f.Name as veh_aux_A_IMP1_nm
      ,a.[veh_aux_A_VROLL]
	  ,l.Name as veh_aux_A_VROLL_nm
      ,a.[veh_aux_A_LIC_S]
	  ,h.Name as veh_aux_A_LIC_S_nm
      ,a.[veh_aux_A_LIC_C]
	  ,g.Name as veh_aux_A_LIC_C_nm
      ,a.[veh_aux_A_CDL_S]
	  ,c.Name as veh_aux_A_CDL_S_nm
      ,a.[veh_aux_A_MC_L_S]
	  ,i.Name as veh_aux_A_MC_L_S_nm
      ,a.[veh_aux_A_SPVEH]
	  ,k.Name as veh_aux_A_SPVEH_nm
      ,a.[veh_aux_A_SBUS]
	  ,j.Name as veh_aux_A_SBUS_nm
      ,a.[veh_aux_A_MOD_YR] --int
      ,a.[veh_aux_A_DRDIS]
	  ,d.Name as veh_aux_A_DRDIS_nm
      ,a.[veh_aux_A_DRDRO]
	  ,e.Name as veh_aux_A_DRDRO_nm
      ,a.[veh_NUMOCCS] 
      ,a.[veh_DAY]  
      ,a.[veh_MONTH]
      ,a.[veh_HOUR]
      ,a.[veh_MINUTE]
      ,a.[veh_HARM_EV]
      ,a.[veh_MAN_COLL]
      ,a.[veh_UNITTYPE]
      ,a.[veh_HIT_RUN]
      ,a.[veh_REG_STAT]
      ,a.[veh_OWNER]
      ,a.[veh_MAKE]
      ,a.[veh_MODEL]
      ,a.[veh_MAK_MOD]
      ,a.[veh_BODY_TYP]
      ,a.[veh_MOD_YEAR]
      ,a.[veh_VIN]
      ,a.[veh_VIN_1]
      ,a.[veh_VIN_2]
      ,a.[veh_VIN_3]
      ,a.[veh_VIN_4]
      ,a.[veh_VIN_5]
      ,a.[veh_VIN_6]
      ,a.[veh_VIN_7]
      ,a.[veh_VIN_8]
      ,a.[veh_VIN_9]
      ,a.[veh_VIN_10]
      ,a.[veh_VIN_11]
      ,a.[veh_VIN_12]
      ,a.[veh_TOW_VEH]
      ,a.[veh_J_KNIFE]
      ,a.[veh_MCARR_11]
      ,a.[veh_MCARR_12]
      ,a.[veh_MCARR_ID]
      ,a.[veh_GVWR]
      ,a.[veh_V_CONFIG]
      ,a.[veh_CARGO_BT]
      ,a.[veh_HAZ_INV]
      ,a.[veh_HAZ_PLAC]
      ,a.[veh_HAZ_ID]
      ,a.[veh_HAZ_CNO]
      ,a.[veh_HAZ_REL]
      ,a.[veh_BUS_USE]
      ,a.[veh_SPEC_USE]
      ,a.[veh_EMER_USE]
      ,a.[veh_TRAV_SP]
      ,a.[veh_UNDERIDE]
      ,a.[veh_ROLLOVER]
      ,a.[veh_ROLINLOC]
      ,a.[veh_IMPACT1]
      ,a.[veh_DEFORMED]
      ,a.[veh_TOWED]
      ,a.[veh_M_HARM]
      ,a.[veh_VEH_SC1]
      ,a.[veh_VEH_SC2]
      ,a.[veh_FIRE_EXP]
      ,a.[veh_DR_PRES]
      ,a.[veh_L_STATE]
      ,a.[veh_DR_ZIP]
      ,a.[veh_L_STATUS]
      ,a.[veh_L_TYPE]
      ,a.[veh_CDL_STAT]
      ,a.[veh_L_ENDORS]
      ,a.[veh_L_COMPL]
      ,a.[veh_L_RESTRI]
      ,a.[veh_DR_HGT]
      ,a.[veh_DR_WGT]
      ,a.[veh_prev_sus]
      ,a.[veh_PREV_ACC]
      ,a.[veh_PREV_DWI]
      ,a.[veh_PREV_SPD]
      ,a.[veh_PREV_OTH]
      ,a.[veh_FIRST_MO]
      ,a.[veh_FIRST_YR]
      ,a.[veh_LAST_MO]
      ,a.[veh_LAST_YR]
      ,a.[veh_SPEEDREL]
      ,a.[veh_DR_SF1]
      ,a.[veh_DR_SF2]
      ,a.[veh_DR_SF3]
      ,a.[veh_DR_SF4]
      ,a.[veh_VTRAFWAY]
      ,a.[veh_VNUM_LAN]
      ,a.[veh_VSPD_LIM]
      ,a.[veh_VALIGN]
      ,a.[veh_VPROFILE]
      ,a.[veh_VPAVETYP]
      ,a.[veh_VSURCOND]
      ,a.[veh_VTRAFCON]
      ,a.[veh_VTCONT_F]
      ,a.[veh_P_CRASH1]
      ,a.[veh_P_CRASH2]
      ,a.[veh_P_CRASH3]
      ,a.[veh_P_CRASH4]
      ,a.[veh_P_CRASH5]
      ,a.[veh_ACC_TYPE]
      ,a.[veh_TRLR1VIN]
      ,a.[veh_TRLR2VIN]
      ,a.[veh_TRLR3VIN]
      ,a.[veh_DEATHS]
      ,a.[veh_DR_DRINK]
      ,a.[oth_veh_prev_sus]
      ,a.[oth_veh_PREV_ACC]
      ,a.[oth_veh_PREV_DWI]
      ,a.[oth_veh_PREV_SPD]
      ,a.[oth_veh_PREV_OTH]
      ,a.[per_aux_A_AGE1]
	  ,a. per_aux_A_AGE1_nm
      ,a.[per_aux_A_AGE2]
	  ,a.per_aux_A_AGE2_nm
      ,a.[per_aux_A_AGE3]
	  ,a.per_aux_A_AGE3_nm
      ,a.[per_aux_A_AGE4]
	  ,a.per_aux_A_AGE4_nm
      ,a.[per_aux_A_AGE5]
	  ,a. per_aux_A_AGE5_nm
      ,a.[per_aux_A_AGE6]
	  ,a.per_aux_A_AGE6_nm
      ,a.[per_aux_A_AGE7]
	  ,a.per_aux_A_AGE7_nm
      ,a.[per_aux_A_AGE8]
	  ,a.per_aux_A_AGE8_nm
      ,a.[per_aux_A_AGE9]
	  ,a.per_aux_A_AGE9_nm
      ,a.[per_aux_PER_NO]
      ,a.[per_aux_A_PTYPE]
	  ,a.per_aux_A_PTYPE_nm
      ,a.[per_aux_A_RESTUSE]
	  ,a.per_aux_A_RESTUSE_nm
      ,a.[per_aux_A_HELMUSE]
	  ,a.per_aux_A_HELMUSE_nm
      ,a.[per_aux_A_ALCTES]
	  ,a.per_aux_A_ALCTES_nm
      ,a.[per_aux_A_HISP]
	  ,a.per_aux_A_HISP_nm
      ,a.[per_aux_A_RCAT]
	  ,a.per_aux_A_RCAT_nm
      ,a.[per_aux_A_HRACE]
	  ,a.per_aux_A_HRACE_nm
      ,a.[per_aux_A_EJECT]
	  ,a.per_aux_A_EJECT_nm
      ,a.[per_aux_A_PERINJ]
      ,a.[per_aux_A_LOC]
      ,a.[per_STR_VEH]
      ,a.[per_COUNTY]
      ,a.[per_DAY]
      ,a.[per_MONTH]
      ,a.[per_HOUR]
      ,a.[per_MINUTE]
      ,a.[per_RUR_URB]
      ,a.[per_FUNC_SYS]
      ,a.[per_HARM_EV]
      ,a.[per_MAN_COLL]
      ,a.[per_SCH_BUS]
      ,a.[per_MAKE]
      ,a.[per_MAK_MOD]
      ,a.[per_BODY_TYP]
      ,a.[per_MOD_YEAR]
      ,a.[per_TOW_VEH]
      ,a.[per_SPEC_USE]
      ,a.[per_EMER_USE]
      ,a.[per_ROLLOVER]
      ,a.[per_IMPACT1]
      ,a.[per_FIRE_EXP]
      ,a.[per_AGE]
      ,a.[per_SEX]
      ,a.[per_PER_TYPE]
      ,a.[per_INJ_SEV]
      ,a.[per_SEAT_POS]
      ,a.[per_REST_USE]
      ,a.[per_REST_MIS]
      ,a.[per_AIG_BAG]
      ,a.[per_EJECTION]
      ,a.[per_EJ_PATH]
      ,a.[per_EXTRICAT]
      ,a.[per_DRINKING]
      ,a.[per_ALC_DET]
      ,a.[per_ALC_STATUS]
      ,a.[per_ATST_TYPE]
      ,a.[per_ALC_RES]
      ,a.[per_DRUGS]
      ,a.[per_DRUG_DET]
      ,a.[per_DSTATUS]
      ,a.[per_HOSPITAL]
      ,a.[per_DOA]
      ,a.[per_DEATH_DA]
      ,a.[per_DEATH_MO]
      ,a.[per_DEATH_YR]
      ,a.[per_DEATH_HR]
      ,a.[per_DEATH_MN]
      ,a.[per_DEATH_TM]
      ,a.[per_LAG_HRS]
      ,a.[per_LAG_MINS]
      ,a.[per_P_SF1]
      ,a.[per_P_SF2]
      ,a.[per_P_SF3]
      ,a.[per_WORK_INJ]
      ,a.[per_HISPANIC]
      ,a.[per_RACE]
      ,a.[per_LOCATION]
      ,a.[per_DRUG_TEST]
      ,a.[per_Drugs_Not_Tested]
      ,a.[per_Drugs_Negative]
      ,a.[per_Drugs_Not_Reported]
      ,a.[per_Drugs_Other]
      ,a.[per_Drugs_Tested_Result_Unknown]
      ,a.[per_Drugs_Tested_Positive_Unknown_Type]
      ,a.[per_Drugs_Unknown_if_tested]
      ,a.[per_Drugs_Narcotic]
      ,a.[per_Drugs_Depressant]
      ,a.[per_Drugs_Stimulant]
      ,a.[per_Drugs_Hallucinogen]
      ,a.[per_Drugs_Cannabinoid]
      ,a.[per_Drugs_PCP]
      ,a.[per_Drugs_Anabolic_Steroid]
      ,a.[per_Drugs_Inhalant]
  FROM [FARS].[dbo].[raw_final_4] a
  left join [dbo].[v_veh_aux_A_BODY] b
	on a.veh_aux_A_BODY=b.value
  left join [dbo].[v_veh_aux_A_CDL_S] c
    on a.veh_aux_A_CDL_S=c.value
  left join [dbo].[v_veh_aux_A_DRDIS] d
    on a.veh_aux_A_DRDIS=d.value
  left join [dbo].[v_veh_aux_A_DRDRO] e
    on a.veh_aux_A_DRDRO=e.value
  left join [dbo].[v_veh_aux_A_IMP1] f
    on a.veh_aux_A_IMP1=f.value
  left join [dbo].[v_veh_aux_A_LIC_C] g
    on a.veh_aux_A_LIC_C=g.value
  left join [dbo].[v_veh_aux_A_LIC_S] h
    on a.veh_aux_A_LIC_S=h.value
  left join [dbo].[v_veh_aux_A_MC_L_S] i
   on a.veh_aux_A_MC_L_S=i.value
  left join [dbo].[v_veh_aux_A_SBUS] j
   on a.veh_aux_A_SBUS=j.value
  left join [dbo].[v_veh_aux_A_SPVEH] k
   on a.veh_aux_A_SPVEH=k.value
  left join [dbo].[v_veh_aux_A_VROLL] l
   on a.veh_aux_A_VROLL=l.value ) as combined


---------------------------------------------------------------------------------
--Step 16
--Take dbo.raw_final_5 and replace codes with names for accident
--create table dbo.raw_final_6
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_6]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_6]
END

select * into [dbo].[raw_final_6]
from 
	(Select a.[Key]
      ,a.[acc_aux_STATE]
      ,a.[acc_aux_STATE_nm]
      ,a.[acc_aux_COUNTY]
      ,a.[acc_aux_FATALS]
      ,a.[acc_aux_A_CRAINJ]
      ,a.[acc_aux_A_REGION]
      ,a.[acc_aux_A_REGION_nm]
      ,a.[acc_aux_A_RU]
      ,a.[acc_aux_A_RU_nm]
      ,a.[acc_aux_A_INTER]
      ,a.[acc_aux_A_INTER_nm]
      ,a.[acc_aux_A_RELRD]
      ,a.[acc_aux_A_RELRD_nm]
      ,a.[acc_aux_A_INTSEC]
      ,a.[acc_aux_A_INTSEC_nm]
      ,a.[acc_aux_A_ROADFC]
      ,a.[acc_aux_A_ROADFC_nm]
      ,a.[acc_aux_A_JUNC]
      ,a.[acc_aux_A_JUNC_nm]
      ,a.[acc_aux_A_MANCOL]
      ,a.[acc_aux_A_MANCOL_nm]
      ,a.[acc_aux_A_TOD]
      ,a.[acc_aux_A_TOD_nm]
      ,a.[acc_aux_A_DOW]
      ,a.[acc_aux_A_DOW_nm]
      ,a.[acc_aux_A_CT]
      ,a.[acc_aux_A_CT_nm]
      ,a.[acc_aux_A_LT]
      ,a.[acc_aux_A_LT_nm]
      ,a.[acc_aux_A_MC]
      ,a.[acc_aux_A_MC_nm]
      ,a.[acc_aux_A_SPCRA]
      ,a.[acc_aux_A_SPCRA_nm]
      ,a.[acc_aux_A_PED]
      ,a.[acc_aux_A_PED_nm]
      ,a.[acc_aux_A_PED_F]
      ,a.[acc_aux_A_PEDAL]
      ,a.[acc_aux_A_PEDAL_nm]
      ,a.[acc_aux_A_PEDAL_F]
      ,a.[acc_aux_A_ROLL]
      ,a.[acc_aux_A_ROLL_nm]
      ,a.[acc_aux_A_POLPUR]
      ,a.[acc_aux_A_POLPUR_nm]
      ,a.[acc_aux_A_POSBAC]
      ,a.[acc_aux_A_POSBAC_nm]
      ,a.[acc_aux_A_D15_19]
      ,a.[acc_aux_A_D15_19_nm]
      ,a.[acc_aux_A_D16_19]
      ,a.[acc_aux_A_D16_19_nm]
      ,a.[acc_aux_A_D15_20]
      ,a.[acc_aux_A_D15_20_nm]
      ,a.[acc_aux_A_D16_20]
      ,a.[acc_aux_A_D16_20_nm]
      ,a.[acc_aux_A_D65PLS]
      ,a.[acc_aux_A_D65PLS_nm]
      ,a.[acc_aux_A_D21_24]
      ,a.[acc_aux_A_D21_24_nm]
      ,a.[acc_aux_A_D16_24]
      ,a.[acc_aux_A_D16_24_nm]
      ,a.[acc_aux_A_RD]
      ,a.[acc_aux_A_RD_nm]
      ,a.[acc_aux_A_HR]
      ,a.[acc_aux_A_HR_nm]
      ,a.[acc_aux_A_DIST]
      ,a.[acc_aux_A_DIST_nm]
      ,a.[acc_aux_A_DROWSY]
      ,a.[acc_aux_A_DROWSY_nm]
      ,a.[acc_aux_BIA]
      ,a.[acc_aux_BIA_nm]
      ,a.[acc_aux_SPJ_INDIAN]
      ,a.[acc_aux_SPJ_INDIAN_nm]
      ,a.[acc_aux_INDIAN_RES]
      ,a.[acc_aux_INDIAN_RES_nm]
      ,a.[acc_VE_TOTAL] --int
      ,a.[acc_VE_FORMS]--int
      ,a.[acc_PVH_INVL]--int
      ,a.[acc_PEDS]--int
      ,a.[acc_PERNOTMVIT]--int
      ,a.[acc_PERMVIT]--int
      ,a.[acc_PERSONS]--int
      ,a.[acc_COUNTY]
      ,a.[acc_CITY]
      ,a.[acc_DAY]--int
      ,a.[acc_MONTH]
	  ,h.Name as acc_MONTH_nm
      ,a.[acc_YEAR] --int
      ,a.[acc_DAY_WEEK]
	  ,e.Name as acc_DAY_WEEK_nm
      ,a.[acc_HOUR] --int
      ,a.[acc_MINUTE]  --int
      ,a.[acc_NHS]
	  ,i.Name as acc_NHS_nm
      ,a.[acc_RUR_URB]
	  ,v.name as acc_RUR_URB_nm
      ,a.[acc_FUNC_SYS]
	  ,w.name as acc_FUNC_SYS_nm
      ,a.[acc_RD_OWNER]
	  ,j.Name as acc_RD_OWNER_nm
      ,a.[acc_ROUTE]
	  ,n.Name as acc_ROUTE_nm
      ,a.[acc_TWAY_ID] --no coding
      ,a.[acc_TWAY_ID2] --no coding
      ,a.[acc_MILEPT] --no coding
      ,a.[acc_LATITUDE] --no coding
      ,a.[acc_LONGITUD] --no coding
      ,a.[acc_SP_JUR]
	  ,p.Name as acc_SP_JUR_nm
      ,a.[acc_HARM_EV]
	  ,f.Name as acc_HARM_EV_nm
      ,a.[acc_MAN_COLL]
	  ,x.name as acc_MAN_COLL_nm
      ,a.[acc_RELJCT1]
	  ,l.Name as acc_RELJCT1_nm
      ,a.[acc_RELJCT2]
	  ,m.Name as acc_RELJCT2_nm
      ,a.[acc_TYP_INT]
	  ,q.Name as acc_TYP_INT_nm
      ,a.[acc_WRK_ZONE]
	  ,u.Name as acc_WRK_ZONE_nm
      ,a.[acc_REL_ROAD]
	  ,k.Name as acc_REL_ROAD_nm
      ,a.[acc_LGT_COND]
	  ,g.Name as acc_LGT_COND_nm
      ,a.[acc_WEATHER1]
	  ,s.Name as acc_WEATHER1_nm
      ,a.[acc_WEATHER2]
	  ,t.Name as acc_WEATHER2_nm
      ,a.[acc_WEATHER]
	  ,r.Name as acc_WEATHER_nm
      ,a.[acc_SCH_BUS]
	  ,o.Name as acc_SCH_BUS_nm
      ,a.[acc_RAIL]
      ,a.[acc_NOT_HOUR]
      ,a.[acc_NOT_MIN]
      ,a.[acc_ARR_HOUR]
      ,a.[acc_ARR_MIN]
      ,a.[acc_HOSP_HR]
      ,a.[acc_HOSP_MN]
      ,a.[acc_CF1]
	  ,b.Name as acc_CF1_nm
      ,a.[acc_CF2]
	  ,c.Name as acc_CF2_nm
      ,a.[acc_CF3]
	  ,d.Name as acc_CF3_nm
      ,a.[acc_FATALS] --int
      ,a.[acc_DRUNK_DR] --int
      ,a.[veh_aux_VEH_NO]
      ,a.[veh_aux_A_BODY]
	  ,a.veh_aux_A_BODY_nm
      ,a.[veh_aux_A_IMP1]
	  ,a.veh_aux_A_IMP1_nm
      ,a.[veh_aux_A_VROLL]
	  ,a.veh_aux_A_VROLL_nm
      ,a.[veh_aux_A_LIC_S]
	  ,a.veh_aux_A_LIC_S_nm
      ,a.[veh_aux_A_LIC_C]
	  ,a.veh_aux_A_LIC_C_nm
      ,a.[veh_aux_A_CDL_S]
	  ,a.veh_aux_A_CDL_S_nm
      ,a.[veh_aux_A_MC_L_S]
	  ,a.veh_aux_A_MC_L_S_nm
      ,a.[veh_aux_A_SPVEH]
	  ,a.veh_aux_A_SPVEH_nm
      ,a.[veh_aux_A_SBUS]
	  ,a.veh_aux_A_SBUS_nm
      ,a.[veh_aux_A_MOD_YR]
      ,a.[veh_aux_A_DRDIS]
	  ,a.veh_aux_A_DRDIS_nm
      ,a.[veh_aux_A_DRDRO]
	  ,a.veh_aux_A_DRDRO_nm
      ,a.[veh_NUMOCCS]
      ,a.[veh_DAY]
      ,a.[veh_MONTH]
      ,a.[veh_HOUR]
      ,a.[veh_MINUTE]
      ,a.[veh_HARM_EV]
      ,a.[veh_MAN_COLL]
      ,a.[veh_UNITTYPE]
      ,a.[veh_HIT_RUN]
      ,a.[veh_REG_STAT]
      ,a.[veh_OWNER]
      ,a.[veh_MAKE]
      ,a.[veh_MODEL]
      ,a.[veh_MAK_MOD]
      ,a.[veh_BODY_TYP]
      ,a.[veh_MOD_YEAR]
      ,a.[veh_VIN]
      ,a.[veh_VIN_1]
      ,a.[veh_VIN_2]
      ,a.[veh_VIN_3]
      ,a.[veh_VIN_4]
      ,a.[veh_VIN_5]
      ,a.[veh_VIN_6]
      ,a.[veh_VIN_7]
      ,a.[veh_VIN_8]
      ,a.[veh_VIN_9]
      ,a.[veh_VIN_10]
      ,a.[veh_VIN_11]
      ,a.[veh_VIN_12]
      ,a.[veh_TOW_VEH]
      ,a.[veh_J_KNIFE]
      ,a.[veh_MCARR_11]
      ,a.[veh_MCARR_12]
      ,a.[veh_MCARR_ID]
      ,a.[veh_GVWR]
      ,a.[veh_V_CONFIG]
      ,a.[veh_CARGO_BT]
      ,a.[veh_HAZ_INV]
      ,a.[veh_HAZ_PLAC]
      ,a.[veh_HAZ_ID]
      ,a.[veh_HAZ_CNO]
      ,a.[veh_HAZ_REL]
      ,a.[veh_BUS_USE]
      ,a.[veh_SPEC_USE]
      ,a.[veh_EMER_USE]
      ,a.[veh_TRAV_SP]
      ,a.[veh_UNDERIDE]
      ,a.[veh_ROLLOVER]
      ,a.[veh_ROLINLOC]
      ,a.[veh_IMPACT1]
      ,a.[veh_DEFORMED]
      ,a.[veh_TOWED]
      ,a.[veh_M_HARM]
      ,a.[veh_VEH_SC1]
      ,a.[veh_VEH_SC2]
      ,a.[veh_FIRE_EXP]
      ,a.[veh_DR_PRES]
      ,a.[veh_L_STATE]
      ,a.[veh_DR_ZIP]
      ,a.[veh_L_STATUS]
      ,a.[veh_L_TYPE]
      ,a.[veh_CDL_STAT]
      ,a.[veh_L_ENDORS]
      ,a.[veh_L_COMPL]
      ,a.[veh_L_RESTRI]
      ,a.[veh_DR_HGT]
      ,a.[veh_DR_WGT]
      ,a.[veh_prev_sus]
      ,a.[veh_PREV_ACC]
      ,a.[veh_PREV_DWI]
      ,a.[veh_PREV_SPD]
      ,a.[veh_PREV_OTH]
      ,a.[veh_FIRST_MO]
      ,a.[veh_FIRST_YR]
      ,a.[veh_LAST_MO]
      ,a.[veh_LAST_YR]
      ,a.[veh_SPEEDREL]
      ,a.[veh_DR_SF1]
      ,a.[veh_DR_SF2]
      ,a.[veh_DR_SF3]
      ,a.[veh_DR_SF4]
      ,a.[veh_VTRAFWAY]
      ,a.[veh_VNUM_LAN]
      ,a.[veh_VSPD_LIM]
      ,a.[veh_VALIGN]
      ,a.[veh_VPROFILE]
      ,a.[veh_VPAVETYP]
      ,a.[veh_VSURCOND]
      ,a.[veh_VTRAFCON]
      ,a.[veh_VTCONT_F]
      ,a.[veh_P_CRASH1]
      ,a.[veh_P_CRASH2]
      ,a.[veh_P_CRASH3]
      ,a.[veh_P_CRASH4]
      ,a.[veh_P_CRASH5]
      ,a.[veh_ACC_TYPE]
      ,a.[veh_TRLR1VIN]
      ,a.[veh_TRLR2VIN]
      ,a.[veh_TRLR3VIN]
      ,a.[veh_DEATHS]
      ,a.[veh_DR_DRINK]
      ,a.[oth_veh_prev_sus]
      ,a.[oth_veh_PREV_ACC]
      ,a.[oth_veh_PREV_DWI]
      ,a.[oth_veh_PREV_SPD]
      ,a.[oth_veh_PREV_OTH]
      ,a.[per_aux_A_AGE1]
	  ,a.per_aux_A_AGE1_nm
      ,a.[per_aux_A_AGE2]
	  ,a.per_aux_A_AGE2_nm
      ,a.[per_aux_A_AGE3]
	  ,a.per_aux_A_AGE3_nm
      ,a.[per_aux_A_AGE4]
	  ,a.per_aux_A_AGE4_nm
      ,a.[per_aux_A_AGE5]
	  ,a.per_aux_A_AGE5_nm
      ,a.[per_aux_A_AGE6]
	  ,a.per_aux_A_AGE6_nm
      ,a.[per_aux_A_AGE7]
	  ,a.per_aux_A_AGE7_nm
      ,a.[per_aux_A_AGE8]
	  ,a.per_aux_A_AGE8_nm
      ,a.[per_aux_A_AGE9]
	  ,a.per_aux_A_AGE9_nm
      ,a.[per_aux_PER_NO]
      ,a.[per_aux_A_PTYPE]
	  ,a.per_aux_A_PTYPE_nm
      ,a.[per_aux_A_RESTUSE]
	  ,a.per_aux_A_RESTUSE_nm
      ,a.[per_aux_A_HELMUSE]
	  ,a.per_aux_A_HELMUSE_nm
      ,a.[per_aux_A_ALCTES]
	  ,a.per_aux_A_ALCTES_nm
      ,a.[per_aux_A_HISP]
	  ,a.per_aux_A_HISP_nm
      ,a.[per_aux_A_RCAT]
	  ,a.per_aux_A_RCAT_nm
      ,a.[per_aux_A_HRACE]
	  ,a.per_aux_A_HRACE_nm
      ,a.[per_aux_A_EJECT]
	  ,a.per_aux_A_EJECT_nm
      ,a.[per_aux_A_PERINJ]
      ,a.[per_aux_A_LOC]
      ,a.[per_STR_VEH]
      ,a.[per_COUNTY]
      ,a.[per_DAY]
      ,a.[per_MONTH]
      ,a.[per_HOUR]
      ,a.[per_MINUTE]
      ,a.[per_RUR_URB]
      ,a.[per_FUNC_SYS]
      ,a.[per_HARM_EV]
      ,a.[per_MAN_COLL]
      ,a.[per_SCH_BUS]
      ,a.[per_MAKE]
      ,a.[per_MAK_MOD]
      ,a.[per_BODY_TYP]
      ,a.[per_MOD_YEAR]
      ,a.[per_TOW_VEH]
      ,a.[per_SPEC_USE]
      ,a.[per_EMER_USE]
      ,a.[per_ROLLOVER]
      ,a.[per_IMPACT1]
      ,a.[per_FIRE_EXP]
      ,a.[per_AGE]
      ,a.[per_SEX]
      ,a.[per_PER_TYPE]
      ,a.[per_INJ_SEV]
      ,a.[per_SEAT_POS]
      ,a.[per_REST_USE]
      ,a.[per_REST_MIS]
      ,a.[per_AIG_BAG]
      ,a.[per_EJECTION]
      ,a.[per_EJ_PATH]
      ,a.[per_EXTRICAT]
      ,a.[per_DRINKING]
      ,a.[per_ALC_DET]
      ,a.[per_ALC_STATUS]
      ,a.[per_ATST_TYPE]
      ,a.[per_ALC_RES]
      ,a.[per_DRUGS]
      ,a.[per_DRUG_DET]
      ,a.[per_DSTATUS]
      ,a.[per_HOSPITAL]
      ,a.[per_DOA]
      ,a.[per_DEATH_DA]
      ,a.[per_DEATH_MO]
      ,a.[per_DEATH_YR]
      ,a.[per_DEATH_HR]
      ,a.[per_DEATH_MN]
      ,a.[per_DEATH_TM]
      ,a.[per_LAG_HRS]
      ,a.[per_LAG_MINS]
      ,a.[per_P_SF1]
      ,a.[per_P_SF2]
      ,a.[per_P_SF3]
      ,a.[per_WORK_INJ]
      ,a.[per_HISPANIC]
      ,a.[per_RACE]
      ,a.[per_LOCATION]
      ,a.[per_DRUG_TEST]
      ,a.[per_Drugs_Not_Tested]
      ,a.[per_Drugs_Negative]
      ,a.[per_Drugs_Not_Reported]
      ,a.[per_Drugs_Other]
      ,a.[per_Drugs_Tested_Result_Unknown]
      ,a.[per_Drugs_Tested_Positive_Unknown_Type]
      ,a.[per_Drugs_Unknown_if_tested]
      ,a.[per_Drugs_Narcotic]
      ,a.[per_Drugs_Depressant]
      ,a.[per_Drugs_Stimulant]
      ,a.[per_Drugs_Hallucinogen]
      ,a.[per_Drugs_Cannabinoid]
      ,a.[per_Drugs_PCP]
      ,a.[per_Drugs_Anabolic_Steroid]
      ,a.[per_Drugs_Inhalant]
  FROM [FARS].[dbo].[raw_final_5] a
  left join [dbo].[v_acc_CF1] b
    on a.acc_CF1=b.value
  left join [dbo].[v_acc_CF2] c
    on a.acc_CF2=c.value
  left join [dbo].[v_acc_CF3] d
    on a.acc_CF3=d.value
  left join [dbo].[v_acc_DAY_WEEK] e
    on a.acc_DAY_WEEK=e.value
  left join [dbo].[v_acc_HARM_EV] f
    on a.acc_HARM_EV=f.value
  left join [dbo].[v_acc_LGT_COND] g
    on a.acc_LGT_COND=g.value
  left join [dbo].[v_acc_MONTH] h
    on a.acc_MONTH=h.value
  left join [dbo].[v_acc_NHS] i
    on a.acc_NHS=i.value
  left join [dbo].[v_acc_RD_OWNER] j
    on a.acc_RD_OWNER=j.value
  left join [dbo].[v_acc_REL_ROAD] k
    on a.acc_REL_ROAD=k.value
  left join [dbo].[v_acc_RELJCT1] l
    on a.acc_RELJCT1=l.value
  left join [dbo].[v_acc_RELJCT2] m
    on a.acc_RELJCT2=m.value
  left join [dbo].[v_acc_ROUTE] n
   on a.acc_ROUTE=n.value
  left join [dbo].[v_acc_SCH_BUS] o
   on a.acc_SCH_BUS=o.value
  left join [dbo].[v_acc_SP_JUR] p
    on a.acc_SP_JUR=p.value
  left join [dbo].[v_acc_TYP_INT] q
    on a.acc_TYP_INT=q.value
  left join [dbo].[v_acc_WEATHER] r
    on a.acc_WEATHER=r.value
  left join [dbo].[v_acc_WEATHER1] s
    on a.acc_WEATHER1=s.value
  left join [dbo].[v_acc_WEATHER2] t
    on a.acc_WEATHER2=t.value
  left join [dbo].[v_acc_WRK_ZONE] u
    on a.acc_WRK_ZONE=u.value
  left join [dbo].[v_ACC_RUR_URB] v
   on a.ACC_RUR_URB=v.value
  left join [dbo].[v_ACC_FUNC_SYS] w
   on a.ACC_FUNC_SYS=w.value
  left join [dbo].[v_ACC_MAN_COLL] x
   on a.ACC_MAN_COLL=x.value
	) as combined

---------------------------------------------------------------------------------
--Step 17
--Take dbo.raw_final_6 and replace codes with names for person
--create table dbo.raw_final_7
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_7]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_7]
END

select * into [dbo].[raw_final_7]
from 
	(Select a.[Key]
      ,a.[acc_aux_STATE]
      ,a.[acc_aux_STATE_nm]
      ,a.[acc_aux_COUNTY]
      ,a.[acc_aux_FATALS]
      ,a.[acc_aux_A_CRAINJ]
      ,a.[acc_aux_A_REGION]
      ,a.[acc_aux_A_REGION_nm]
      ,a.[acc_aux_A_RU]
      ,a.[acc_aux_A_RU_nm]
      ,a.[acc_aux_A_INTER]
      ,a.[acc_aux_A_INTER_nm]
      ,a.[acc_aux_A_RELRD]
      ,a.[acc_aux_A_RELRD_nm]
      ,a.[acc_aux_A_INTSEC]
      ,a.[acc_aux_A_INTSEC_nm]
      ,a.[acc_aux_A_ROADFC]
      ,a.[acc_aux_A_ROADFC_nm]
      ,a.[acc_aux_A_JUNC]
      ,a.[acc_aux_A_JUNC_nm]
      ,a.[acc_aux_A_MANCOL]
      ,a.[acc_aux_A_MANCOL_nm]
      ,a.[acc_aux_A_TOD]
      ,a.[acc_aux_A_TOD_nm]
      ,a.[acc_aux_A_DOW]
      ,a.[acc_aux_A_DOW_nm]
      ,a.[acc_aux_A_CT]
      ,a.[acc_aux_A_CT_nm]
      ,a.[acc_aux_A_LT]
      ,a.[acc_aux_A_LT_nm]
      ,a.[acc_aux_A_MC]
      ,a.[acc_aux_A_MC_nm]
      ,a.[acc_aux_A_SPCRA]
      ,a.[acc_aux_A_SPCRA_nm]
      ,a.[acc_aux_A_PED]
      ,a.[acc_aux_A_PED_nm]
      ,a.[acc_aux_A_PED_F]
      ,a.[acc_aux_A_PEDAL]
      ,a.[acc_aux_A_PEDAL_nm]
      ,a.[acc_aux_A_PEDAL_F]
      ,a.[acc_aux_A_ROLL]
      ,a.[acc_aux_A_ROLL_nm]
      ,a.[acc_aux_A_POLPUR]
      ,a.[acc_aux_A_POLPUR_nm]
      ,a.[acc_aux_A_POSBAC]
      ,a.[acc_aux_A_POSBAC_nm]
      ,a.[acc_aux_A_D15_19]
      ,a.[acc_aux_A_D15_19_nm]
      ,a.[acc_aux_A_D16_19]
      ,a.[acc_aux_A_D16_19_nm]
      ,a.[acc_aux_A_D15_20]
      ,a.[acc_aux_A_D15_20_nm]
      ,a.[acc_aux_A_D16_20]
      ,a.[acc_aux_A_D16_20_nm]
      ,a.[acc_aux_A_D65PLS]
      ,a.[acc_aux_A_D65PLS_nm]
      ,a.[acc_aux_A_D21_24]
      ,a.[acc_aux_A_D21_24_nm]
      ,a.[acc_aux_A_D16_24]
      ,a.[acc_aux_A_D16_24_nm]
      ,a.[acc_aux_A_RD]
      ,a.[acc_aux_A_RD_nm]
      ,a.[acc_aux_A_HR]
      ,a.[acc_aux_A_HR_nm]
      ,a.[acc_aux_A_DIST]
      ,a.[acc_aux_A_DIST_nm]
      ,a.[acc_aux_A_DROWSY]
      ,a.[acc_aux_A_DROWSY_nm]
      ,a.[acc_aux_BIA]
      ,a.[acc_aux_BIA_nm]
      ,a.[acc_aux_SPJ_INDIAN]
      ,a.[acc_aux_SPJ_INDIAN_nm]
      ,a.[acc_aux_INDIAN_RES]
      ,a.[acc_aux_INDIAN_RES_nm]
      ,a.[acc_VE_TOTAL]
      ,a.[acc_VE_FORMS]
      ,a.[acc_PVH_INVL]
      ,a.[acc_PEDS]
      ,a.[acc_PERNOTMVIT]
      ,a.[acc_PERMVIT]
      ,a.[acc_PERSONS]
      ,a.[acc_COUNTY]
      ,a.[acc_CITY]
      ,a.[acc_DAY]
      ,a.[acc_MONTH]
	  ,a.acc_MONTH_nm
      ,a.[acc_YEAR]
      ,a.[acc_DAY_WEEK]
	  ,a.acc_DAY_WEEK_nm
      ,a.[acc_HOUR]
      ,a.[acc_MINUTE]
      ,a.[acc_NHS]
	  ,a.acc_NHS_nm
      ,a.[acc_RUR_URB]
	  ,a.acc_RUR_URB_nm
      ,a.[acc_FUNC_SYS]
	  ,a.acc_FUNC_SYS_nm
      ,a.[acc_RD_OWNER]
	  ,a.acc_RD_OWNER_nm
      ,a.[acc_ROUTE]
	  ,a.acc_ROUTE_nm
      ,a.[acc_TWAY_ID]
      ,a.[acc_TWAY_ID2]
      ,a.[acc_MILEPT]
      ,a.[acc_LATITUDE]
      ,a.[acc_LONGITUD]
      ,a.[acc_SP_JUR]
	  ,a.acc_SP_JUR_nm
      ,a.[acc_HARM_EV]
	  ,a.acc_HARM_EV_nm
      ,a.[acc_MAN_COLL]
	  ,a.acc_MAN_COLL_nm
      ,a.[acc_RELJCT1]
	  ,a.acc_RELJCT1_nm
      ,a.[acc_RELJCT2]
	  ,a.acc_RELJCT2_nm
      ,a.[acc_TYP_INT]
	  ,a.acc_TYP_INT_nm
      ,a.[acc_WRK_ZONE]
	  ,a.acc_WRK_ZONE_nm
      ,a.[acc_REL_ROAD]
	  ,a.acc_REL_ROAD_nm
      ,a.[acc_LGT_COND]
	  ,a.acc_LGT_COND_nm
      ,a.[acc_WEATHER1]
	  ,a.acc_WEATHER1_nm
      ,a.[acc_WEATHER2]
	  ,a.acc_WEATHER2_nm
      ,a.[acc_WEATHER]
	  ,a.acc_WEATHER_nm
      ,a.[acc_SCH_BUS]
	  ,a.acc_SCH_BUS_nm
      ,a.[acc_RAIL]
      ,a.[acc_NOT_HOUR]
      ,a.[acc_NOT_MIN]
      ,a.[acc_ARR_HOUR]
      ,a.[acc_ARR_MIN]
      ,a.[acc_HOSP_HR]
      ,a.[acc_HOSP_MN]
      ,a.[acc_CF1]
	  ,a.acc_CF1_nm
      ,a.[acc_CF2]
	  ,a.acc_CF2_nm
      ,a.[acc_CF3]
	  ,a.acc_CF3_nm
      ,a.[acc_FATALS]
      ,a.[acc_DRUNK_DR]
      ,a.[veh_aux_VEH_NO]
      ,a.[veh_aux_A_BODY]
	  ,a.veh_aux_A_BODY_nm
      ,a.[veh_aux_A_IMP1]
	  ,a.veh_aux_A_IMP1_nm
      ,a.[veh_aux_A_VROLL]
	  ,a.veh_aux_A_VROLL_nm
      ,a.[veh_aux_A_LIC_S]
	  ,a.veh_aux_A_LIC_S_nm
      ,a.[veh_aux_A_LIC_C]
	  ,a.veh_aux_A_LIC_C_nm
      ,a.[veh_aux_A_CDL_S]
	  ,a.veh_aux_A_CDL_S_nm
      ,a.[veh_aux_A_MC_L_S]
	  ,a.veh_aux_A_MC_L_S_nm
      ,a.[veh_aux_A_SPVEH]
	  ,a.veh_aux_A_SPVEH_nm
      ,a.[veh_aux_A_SBUS]
	  ,a.veh_aux_A_SBUS_nm
      ,a.[veh_aux_A_MOD_YR]
      ,a.[veh_aux_A_DRDIS]
	  ,a.veh_aux_A_DRDIS_nm
      ,a.[veh_aux_A_DRDRO]
	  ,a.veh_aux_A_DRDRO_nm
      ,a.[veh_NUMOCCS]
      ,a.[veh_DAY]
      ,a.[veh_MONTH]
      ,a.[veh_HOUR]
      ,a.[veh_MINUTE]
      ,a.[veh_HARM_EV]
      ,a.[veh_MAN_COLL]
      ,a.[veh_UNITTYPE]
      ,a.[veh_HIT_RUN]
      ,a.[veh_REG_STAT]
      ,a.[veh_OWNER]
      ,a.[veh_MAKE]
      ,a.[veh_MODEL]
      ,a.[veh_MAK_MOD]
      ,a.[veh_BODY_TYP]
      ,a.[veh_MOD_YEAR]
      ,a.[veh_VIN]
      ,a.[veh_VIN_1]
      ,a.[veh_VIN_2]
      ,a.[veh_VIN_3]
      ,a.[veh_VIN_4]
      ,a.[veh_VIN_5]
      ,a.[veh_VIN_6]
      ,a.[veh_VIN_7]
      ,a.[veh_VIN_8]
      ,a.[veh_VIN_9]
      ,a.[veh_VIN_10]
      ,a.[veh_VIN_11]
      ,a.[veh_VIN_12]
      ,a.[veh_TOW_VEH]
      ,a.[veh_J_KNIFE]
      ,a.[veh_MCARR_11]
      ,a.[veh_MCARR_12]
      ,a.[veh_MCARR_ID]
      ,a.[veh_GVWR]
      ,a.[veh_V_CONFIG]
      ,a.[veh_CARGO_BT]
      ,a.[veh_HAZ_INV]
      ,a.[veh_HAZ_PLAC]
      ,a.[veh_HAZ_ID]
      ,a.[veh_HAZ_CNO]
      ,a.[veh_HAZ_REL]
      ,a.[veh_BUS_USE]
      ,a.[veh_SPEC_USE]
      ,a.[veh_EMER_USE]
      ,a.[veh_TRAV_SP]
      ,a.[veh_UNDERIDE]
      ,a.[veh_ROLLOVER]
      ,a.[veh_ROLINLOC]
      ,a.[veh_IMPACT1]
      ,a.[veh_DEFORMED]
      ,a.[veh_TOWED]
      ,a.[veh_M_HARM]
      ,a.[veh_VEH_SC1]
      ,a.[veh_VEH_SC2]
      ,a.[veh_FIRE_EXP]
      ,a.[veh_DR_PRES]
      ,a.[veh_L_STATE]
      ,a.[veh_DR_ZIP]
      ,a.[veh_L_STATUS]
      ,a.[veh_L_TYPE]
      ,a.[veh_CDL_STAT]
      ,a.[veh_L_ENDORS]
      ,a.[veh_L_COMPL]
      ,a.[veh_L_RESTRI]
      ,a.[veh_DR_HGT]
      ,a.[veh_DR_WGT]
      ,a.[veh_prev_sus]
      ,a.[veh_PREV_ACC]
      ,a.[veh_PREV_DWI]
      ,a.[veh_PREV_SPD]
      ,a.[veh_PREV_OTH]
      ,a.[veh_FIRST_MO]
      ,a.[veh_FIRST_YR]
      ,a.[veh_LAST_MO]
      ,a.[veh_LAST_YR]
      ,a.[veh_SPEEDREL]
      ,a.[veh_DR_SF1]
      ,a.[veh_DR_SF2]
      ,a.[veh_DR_SF3]
      ,a.[veh_DR_SF4]
      ,a.[veh_VTRAFWAY]
      ,a.[veh_VNUM_LAN]
      ,a.[veh_VSPD_LIM]
      ,a.[veh_VALIGN]
      ,a.[veh_VPROFILE]
      ,a.[veh_VPAVETYP]
      ,a.[veh_VSURCOND]
      ,a.[veh_VTRAFCON]
      ,a.[veh_VTCONT_F]
      ,a.[veh_P_CRASH1]
      ,a.[veh_P_CRASH2]
      ,a.[veh_P_CRASH3]
      ,a.[veh_P_CRASH4]
      ,a.[veh_P_CRASH5]
      ,a.[veh_ACC_TYPE]
      ,a.[veh_TRLR1VIN]
      ,a.[veh_TRLR2VIN]
      ,a.[veh_TRLR3VIN]
      ,a.[veh_DEATHS]
      ,a.[veh_DR_DRINK]
      ,a.[oth_veh_prev_sus]
      ,a.[oth_veh_PREV_ACC]
      ,a.[oth_veh_PREV_DWI]
      ,a.[oth_veh_PREV_SPD]
      ,a.[oth_veh_PREV_OTH]
      ,a.[per_aux_A_AGE1]
	  ,a.per_aux_A_AGE1_nm
      ,a.[per_aux_A_AGE2]
	  ,a.per_aux_A_AGE2_nm
      ,a.[per_aux_A_AGE3]
	  ,a.per_aux_A_AGE3_nm
      ,a.[per_aux_A_AGE4]
	  ,a.per_aux_A_AGE4_nm
      ,a.[per_aux_A_AGE5]
	  ,a.per_aux_A_AGE5_nm
      ,a.[per_aux_A_AGE6]
	  ,a.per_aux_A_AGE6_nm
      ,a.[per_aux_A_AGE7]
	  ,a.per_aux_A_AGE7_nm
      ,a.[per_aux_A_AGE8]
	  ,a.per_aux_A_AGE8_nm
      ,a.[per_aux_A_AGE9]
	  ,a.per_aux_A_AGE9_nm
      ,a.[per_aux_PER_NO]
      ,a.[per_aux_A_PTYPE]
	  ,a.per_aux_A_PTYPE_nm
      ,a.[per_aux_A_RESTUSE]
	  ,a.per_aux_A_RESTUSE_nm
      ,a.[per_aux_A_HELMUSE]
	  ,a.per_aux_A_HELMUSE_nm
      ,a.[per_aux_A_ALCTES]
	  ,a.per_aux_A_ALCTES_nm
      ,a.[per_aux_A_HISP]
	  ,a.per_aux_A_HISP_nm
      ,a.[per_aux_A_RCAT]
	  ,a.per_aux_A_RCAT_nm
      ,a.[per_aux_A_HRACE]
	  ,a.per_aux_A_HRACE_nm
      ,a.[per_aux_A_EJECT]
	  ,a.per_aux_A_EJECT_nm
      ,a.[per_aux_A_PERINJ]
      ,a.[per_aux_A_LOC]
      ,a.[per_STR_VEH]
      ,a.[per_COUNTY]
      ,a.[per_DAY]
      ,a.[per_MONTH]
      ,a.[per_HOUR]
      ,a.[per_MINUTE]
      ,a.[per_RUR_URB]
      ,a.[per_FUNC_SYS]
      ,a.[per_HARM_EV]
      ,a.[per_MAN_COLL]
      ,a.[per_SCH_BUS]
      ,a.[per_MAKE]
      ,a.[per_MAK_MOD]
      ,a.[per_BODY_TYP]
      ,a.[per_MOD_YEAR] --int
      ,a.[per_TOW_VEH]
      ,a.[per_SPEC_USE]
      ,a.[per_EMER_USE]
      ,a.[per_ROLLOVER]
      ,a.[per_IMPACT1]
      ,a.[per_FIRE_EXP]
      ,a.[per_AGE]--int
      ,a.[per_SEX]
	  ,an.name as per_SEX_nm
      ,a.[per_PER_TYPE]
	  ,ai.name as per_PER_TYPE_nm
      ,a.[per_INJ_SEV] --unary
      ,a.[per_SEAT_POS]
	  ,am.name as per_SEAT_POS_nm
      ,a.[per_REST_USE]
	  ,al.name as per_REST_USE_nm
      ,a.[per_REST_MIS]
	  ,ak.name as per_REST_MIS_nm
      ,a.[per_AIG_BAG]
	  ,b.Name as per_AIG_BAG_nm
      ,a.[per_EJECTION]
	  ,ab.name as per_EJECTION_nm
      ,a.[per_EJ_PATH]
	  ,aa.name as per_EJ_PATH_nm
      ,a.[per_EXTRICAT]
	  ,ac.name as per_EXTRICAT_nm
      ,a.[per_DRINKING]
	  ,g.Name as per_DRINKING_nm
      ,a.[per_ALC_DET]
	  ,c.Name as per_ALC_DET_nm
      ,a.[per_ALC_STATUS]
	  ,d.Name as per_ALC_STATUS_nm
      ,a.[per_ATST_TYPE]
	  ,e.Name as per_ATST_TYPE_nm
      ,a.[per_ALC_RES]
      ,a.[per_DRUGS]
	  ,j.name as per_DRUGS_nm
      ,a.[per_DRUG_DET]
	  ,h.name as per_DRUG_DET_nm
      ,a.[per_DSTATUS]
	  ,z.name as per_DSTATUS_nm
      ,a.[per_HOSPITAL]
	  ,ae.name as per_HOSPITAL_nm
      ,a.[per_DOA]
	  ,f.Name as per_DOA_nm
      ,a.[per_DEATH_DA]
      ,a.[per_DEATH_MO]
	  ,ap.name as per_DEATH_MO_nm
      ,a.[per_DEATH_YR]
      ,a.[per_DEATH_HR]
      ,a.[per_DEATH_MN]
      ,a.[per_DEATH_TM]
      ,a.[per_LAG_HRS]
      ,a.[per_LAG_MINS]
      ,a.[per_P_SF1]
	  ,af.name as per_P_SF1_nm
      ,a.[per_P_SF2]
	  ,ag.name as per_P_SF2_nm
      ,a.[per_P_SF3]
	  ,ah.name as per_P_SF3_nm
      ,a.[per_WORK_INJ]
	  ,ao.name as per_WORK_INJ_nm
      ,a.[per_HISPANIC]
	  ,ad.name as per_HISPANIC_nm
      ,a.[per_RACE]
	  ,aj.name as per_RACE_nm
      ,a.[per_LOCATION] --unary
      ,a.[per_DRUG_TEST]
	  ,i.Name as per_DRUG_TEST_nm
      ,a.[per_Drugs_Not_Tested]
	  ,s.name as per_Drugs_Not_Tested_nm
      ,a.[per_Drugs_Negative]
	  ,q.name as per_Drugs_Negative_nm
      ,a.[per_Drugs_Not_Reported]
	  ,r.name as per_Drugs_Not_Reported_nm
      ,a.[per_Drugs_Other]
	  ,t.name as per_Drugs_Other_nm
      ,a.[per_Drugs_Tested_Result_Unknown]
	  ,x.name as per_Drugs_Tested_Result_Unknown_nm
      ,a.[per_Drugs_Tested_Positive_Unknown_Type]
	  ,w.name as per_Drugs_Tested_Positive_Unknown_Type_nm
      ,a.[per_Drugs_Unknown_if_tested]
	  ,y.name as per_Drugs_Unknown_if_tested_nm
      ,a.[per_Drugs_Narcotic]
	  ,p.name as per_Drugs_Narcotic_nm
      ,a.[per_Drugs_Depressant]
	  ,m.name as per_Drugs_Depressant_nm
      ,a.[per_Drugs_Stimulant]
	  ,v.name as per_Drugs_Stimulant_nm
      ,a.[per_Drugs_Hallucinogen]
	  ,n.name as per_Drugs_Hallucinogen_nm
      ,a.[per_Drugs_Cannabinoid]
	  ,l.name as per_Drugs_Cannabinoid_nm
      ,a.[per_Drugs_PCP]
	  ,u.name as per_Drugs_PCP_nm
      ,a.[per_Drugs_Anabolic_Steroid]
	  ,k.Name as per_Drugs_Anabolic_Steroid_nm
      ,a.[per_Drugs_Inhalant]
	  ,o.name as per_Drugs_Inhanlant_nm
  FROM [FARS].[dbo].[raw_final_6] a
left join [dbo].[v_per_AIG_BAG] b
  on a.per_AIG_BAG=b.value
left join [dbo].[v_per_ALC_DET] c
  on a.per_ALC_DET=c.Value
left join [dbo].[v_per_ALC_STATUS] d
  on a.per_ALC_STATUS=d.Value
left join [dbo].[v_per_ATST_TYPE] e
 on a.per_ATST_TYPE=e.value
left join [dbo].[v_per_DOA] f
 on a.per_DOA=f.value
left join [dbo].[v_per_DRINKING] g
 on a.per_DRINKING=g.value
left join [dbo].[v_per_DRUG_DET] h
 on a.per_DRUG_DET=h.value
left join [dbo].[v_per_DRUG_TEST] i
 on a.per_DRUG_TEST=i.value
left join [dbo].[v_per_DRUGS] j
 on a.per_DRUGS=j.value
left join [dbo].[v_per_Drugs_Anabolic_Steroid] k
 on a.per_Drugs_Anabolic_Steroid=k.value
left join [dbo].[v_per_Drugs_Cannabinoid] l
 on a.per_Drugs_Cannabinoid=l.value
left join [dbo].[v_per_Drugs_Depressant] m
 on a.per_Drugs_Depressant=m.value
left join [dbo].[v_per_Drugs_Hallucinogen] n
 on a.per_Drugs_Hallucinogen=n.value
left join [dbo].[v_per_Drugs_Inhalant] o
 on a.per_Drugs_Inhalant=o.value
left join [dbo].[v_per_Drugs_Narcotic] p
 on a.per_Drugs_Narcotic=p.value
left join [dbo].[v_per_Drugs_Negative] q
 on a.per_Drugs_Negative=q.value
left join [dbo].[v_per_Drugs_Not_Reported] r
 on a.per_Drugs_Not_Reported=r.value
left join [dbo].[v_per_Drugs_Not_Tested] s
 on a.per_Drugs_Not_Tested=s.value
left join [dbo].[v_per_Drugs_Other] t
 on a.per_Drugs_Other=t.value
left join [dbo].[v_per_Drugs_PCP] u
 on a.per_Drugs_PCP=u.value
left join [dbo].[v_per_Drugs_Stimulant] v
 on a.per_Drugs_Stimulant=v.value
left join [dbo].[v_per_Drugs_Tested_Positive_Unknown_Type] w
 on a.per_Drugs_Tested_Positive_Unknown_Type=w.value
left join [dbo].[v_per_Drugs_Tested_Result_Unknown] x
 on a.per_Drugs_Tested_Result_Unknown=x.value
left join [dbo].[v_per_Drugs_Unknown_if_tested] y
 on a.per_Drugs_Unknown_if_tested=y.value
left join [dbo].[v_per_DSTATUS] z
 on a.per_DSTATUS=z.value
left join [dbo].[v_per_EJ_PATH] aa
 on a.per_EJ_PATH=aa.value
left join [dbo].[v_per_EJECTION] ab
 on a.per_EJECTION=ab.value
left join [dbo].[v_per_EXTRICAT] ac
 on a.per_EXTRICAT=ac.value
left join [dbo].[v_per_HISPANIC] ad
 on a.per_HISPANIC=ad.value
left join [dbo].[v_per_HOSPITAL] ae
 on a.per_HOSPITAL=ae.value
left join [dbo].[v_per_P_SF1] af
 on a.per_P_SF1=af.value
left join [dbo].[v_per_P_SF2] ag
 on a.per_P_SF2=ag.value
left join [dbo].[v_per_P_SF3] ah
 on a.per_P_SF3=ah.value
left join [dbo].[v_per_PER_TYPE] ai
 on a.per_PER_TYPE=ai.value
left join [dbo].[v_per_RACE] aj
 on a.per_RACE=aj.value
left join [dbo].[v_per_REST_MIS] ak
 on a.per_REST_MIS=ak.value
left join [dbo].[v_per_REST_USE] al
 on a.per_REST_USE=al.value
left join [dbo].[v_per_SEAT_POS] am
 on a.per_SEAT_POS=am.value
left join [dbo].[v_per_SEX] an
 on a.per_SEX=an.value
left join [dbo].[v_per_WORK_INJ] ao
 on a.per_WORK_INJ=ao.value
 left join [dbo].[v_per_DEATH_MO] ap
 on a.per_DEATH_MO=ap.value
) as combined

---------------------------------------------------------------------------------
--Step 18
--Take dbo.raw_final_7 and replace codes with names for vehicle
--create table dbo.raw_final_8
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_8]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_8]
END

select * into [dbo].[raw_final_8]
from 
	(Select a.[Key]
      ,a.[acc_aux_STATE]
      ,a.[acc_aux_STATE_nm]
      ,a.[acc_aux_COUNTY]
      ,a.[acc_aux_FATALS]
      ,a.[acc_aux_A_CRAINJ]
      ,a.[acc_aux_A_REGION]
      ,a.[acc_aux_A_REGION_nm]
      ,a.[acc_aux_A_RU]
      ,a.[acc_aux_A_RU_nm]
      ,a.[acc_aux_A_INTER]
      ,a.[acc_aux_A_INTER_nm]
      ,a.[acc_aux_A_RELRD]
      ,a.[acc_aux_A_RELRD_nm]
      ,a.[acc_aux_A_INTSEC]
      ,a.[acc_aux_A_INTSEC_nm]
      ,a.[acc_aux_A_ROADFC]
      ,a.[acc_aux_A_ROADFC_nm]
      ,a.[acc_aux_A_JUNC]
      ,a.[acc_aux_A_JUNC_nm]
      ,a.[acc_aux_A_MANCOL]
      ,a.[acc_aux_A_MANCOL_nm]
      ,a.[acc_aux_A_TOD]
      ,a.[acc_aux_A_TOD_nm]
      ,a.[acc_aux_A_DOW]
      ,a.[acc_aux_A_DOW_nm]
      ,a.[acc_aux_A_CT]
      ,a.[acc_aux_A_CT_nm]
      ,a.[acc_aux_A_LT]
      ,a.[acc_aux_A_LT_nm]
      ,a.[acc_aux_A_MC]
      ,a.[acc_aux_A_MC_nm]
      ,a.[acc_aux_A_SPCRA]
      ,a.[acc_aux_A_SPCRA_nm]
      ,a.[acc_aux_A_PED]
      ,a.[acc_aux_A_PED_nm]
      ,a.[acc_aux_A_PED_F]
      ,a.[acc_aux_A_PEDAL]
      ,a.[acc_aux_A_PEDAL_nm]
      ,a.[acc_aux_A_PEDAL_F]
      ,a.[acc_aux_A_ROLL]
      ,a.[acc_aux_A_ROLL_nm]
      ,a.[acc_aux_A_POLPUR]
      ,a.[acc_aux_A_POLPUR_nm]
      ,a.[acc_aux_A_POSBAC]
      ,a.[acc_aux_A_POSBAC_nm]
      ,a.[acc_aux_A_D15_19]
      ,a.[acc_aux_A_D15_19_nm]
      ,a.[acc_aux_A_D16_19]
      ,a.[acc_aux_A_D16_19_nm]
      ,a.[acc_aux_A_D15_20]
      ,a.[acc_aux_A_D15_20_nm]
      ,a.[acc_aux_A_D16_20]
      ,a.[acc_aux_A_D16_20_nm]
      ,a.[acc_aux_A_D65PLS]
      ,a.[acc_aux_A_D65PLS_nm]
      ,a.[acc_aux_A_D21_24]
      ,a.[acc_aux_A_D21_24_nm]
      ,a.[acc_aux_A_D16_24]
      ,a.[acc_aux_A_D16_24_nm]
      ,a.[acc_aux_A_RD]
      ,a.[acc_aux_A_RD_nm]
      ,a.[acc_aux_A_HR]
      ,a.[acc_aux_A_HR_nm]
      ,a.[acc_aux_A_DIST]
      ,a.[acc_aux_A_DIST_nm]
      ,a.[acc_aux_A_DROWSY]
      ,a.[acc_aux_A_DROWSY_nm]
      ,a.[acc_aux_BIA]
      ,a.[acc_aux_BIA_nm]
      ,a.[acc_aux_SPJ_INDIAN]
      ,a.[acc_aux_SPJ_INDIAN_nm]
      ,a.[acc_aux_INDIAN_RES]
      ,a.[acc_aux_INDIAN_RES_nm]
      ,a.[acc_VE_TOTAL]
      ,a.[acc_VE_FORMS]
      ,a.[acc_PVH_INVL]
      ,a.[acc_PEDS]
      ,a.[acc_PERNOTMVIT]
      ,a.[acc_PERMVIT]
      ,a.[acc_PERSONS]
      ,a.[acc_COUNTY]
      ,a.[acc_CITY]
      ,a.[acc_DAY]
      ,a.[acc_MONTH]
	  ,a.acc_MONTH_nm
      ,a.[acc_YEAR]
      ,a.[acc_DAY_WEEK]
	  ,a.acc_DAY_WEEK_nm
      ,a.[acc_HOUR]
      ,a.[acc_MINUTE]
      ,a.[acc_NHS]
	  ,a.acc_NHS_nm
      ,a.[acc_RUR_URB]
	  ,a.acc_RUR_URB_nm
      ,a.[acc_FUNC_SYS]
	  ,a.acc_FUNC_SYS_nm
      ,a.[acc_RD_OWNER]
	  ,a.acc_RD_OWNER_nm
      ,a.[acc_ROUTE]
	  ,a.acc_ROUTE_nm
      ,a.[acc_TWAY_ID]
      ,a.[acc_TWAY_ID2]
      ,a.[acc_MILEPT]
      ,a.[acc_LATITUDE]
      ,a.[acc_LONGITUD]
      ,a.[acc_SP_JUR]
	  ,a.acc_SP_JUR_nm
      ,a.[acc_HARM_EV]
	  ,a.acc_HARM_EV_nm
      ,a.[acc_MAN_COLL]
	  ,a.acc_MAN_COLL_nm
      ,a.[acc_RELJCT1]
	  ,a.acc_RELJCT1_nm
      ,a.[acc_RELJCT2]
	  ,a.acc_RELJCT2_nm
      ,a.[acc_TYP_INT]
	  ,a.acc_TYP_INT_nm
      ,a.[acc_WRK_ZONE]
	  ,a.acc_WRK_ZONE_nm
      ,a.[acc_REL_ROAD]
	  ,a.acc_REL_ROAD_nm
      ,a.[acc_LGT_COND]
	  ,a.acc_LGT_COND_nm
      ,a.[acc_WEATHER1]
	  ,a.acc_WEATHER1_nm
      ,a.[acc_WEATHER2]
	  ,a.acc_WEATHER2_nm
      ,a.[acc_WEATHER]
	  ,a.acc_WEATHER_nm
      ,a.[acc_SCH_BUS]
	  ,a.acc_SCH_BUS_nm
      ,a.[acc_RAIL]
      ,a.[acc_NOT_HOUR]
      ,a.[acc_NOT_MIN]
      ,a.[acc_ARR_HOUR]
      ,a.[acc_ARR_MIN]
      ,a.[acc_HOSP_HR]
      ,a.[acc_HOSP_MN]
      ,a.[acc_CF1]
	  ,a.acc_CF1_nm
      ,a.[acc_CF2]
	  ,a.acc_CF2_nm
      ,a.[acc_CF3]
	  ,a.acc_CF3_nm
      ,a.[acc_FATALS]
      ,a.[acc_DRUNK_DR]
      ,a.[veh_aux_VEH_NO]
      ,a.[veh_aux_A_BODY]
	  ,a.veh_aux_A_BODY_nm
      ,a.[veh_aux_A_IMP1]
	  ,a.veh_aux_A_IMP1_nm
      ,a.[veh_aux_A_VROLL]
	  ,a.veh_aux_A_VROLL_nm
      ,a.[veh_aux_A_LIC_S]
	  ,a.veh_aux_A_LIC_S_nm
      ,a.[veh_aux_A_LIC_C]
	  ,a.veh_aux_A_LIC_C_nm
      ,a.[veh_aux_A_CDL_S]
	  ,a.veh_aux_A_CDL_S_nm
      ,a.[veh_aux_A_MC_L_S]
	  ,a.veh_aux_A_MC_L_S_nm
      ,a.[veh_aux_A_SPVEH]
	  ,a.veh_aux_A_SPVEH_nm
      ,a.[veh_aux_A_SBUS]
	  ,a.veh_aux_A_SBUS_nm
      ,a.[veh_aux_A_MOD_YR]
      ,a.[veh_aux_A_DRDIS]
	  ,a.veh_aux_A_DRDIS_nm
      ,a.[veh_aux_A_DRDRO]
	  ,a.veh_aux_A_DRDRO_nm
      ,a.[veh_NUMOCCS] --int
      ,a.[veh_DAY] --int
      ,a.[veh_MONTH]  --not in dd
      ,a.[veh_HOUR] --int
      ,a.[veh_MINUTE] --int
      ,a.[veh_HARM_EV]
	  ,p.name as veh_HARM_EV_nm
      ,a.[veh_MAN_COLL] --?
      ,a.[veh_UNITTYPE] --?
      ,a.[veh_HIT_RUN]
	  ,u.name as veh_HIT_RUN_nm
      ,a.[veh_REG_STAT]
	  ,ak.name as veh_REG_STAT_nm
      ,a.[veh_OWNER]
	  ,ae.name as veh_OWNER_nm
      ,a.[veh_MAKE] --?lookup
      ,a.[veh_MODEL] --?lookup
      ,a.[veh_MAK_MOD] --?lookup
      ,a.[veh_BODY_TYP]
	  ,b.name as veh_BODY_TYP_nm
      ,a.[veh_MOD_YEAR] --int
      ,a.[veh_VIN] --specific to each car
      ,a.[veh_VIN_1]--specific to each car
      ,a.[veh_VIN_2]--specific to each car
      ,a.[veh_VIN_3]--specific to each car
      ,a.[veh_VIN_4]--specific to each car
      ,a.[veh_VIN_5]--specific to each car
      ,a.[veh_VIN_6]--specific to each car
      ,a.[veh_VIN_7]--specific to each car
      ,a.[veh_VIN_8]--specific to each car
      ,a.[veh_VIN_9]--specific to each car
      ,a.[veh_VIN_10]--specific to each car
      ,a.[veh_VIN_11]--specific to each car
      ,a.[veh_VIN_12]--specific to each car
      ,a.[veh_TOW_VEH]
	  ,ap.name as veh_TOW_VEH_nm
      ,a.[veh_J_KNIFE]
	  ,w.name as veh_J_KNIFE_nm
      ,a.[veh_MCARR_11]--specific to each car
      ,a.[veh_MCARR_12]--specific to each car
      ,a.[veh_MCARR_ID]--specific to each car
      ,a.[veh_GVWR]
	  ,o.name as veh_GVWR_nm
      ,a.[veh_V_CONFIG]
	  ,au.name as veh_V_CONFIG_nm
      ,a.[veh_CARGO_BT]
	  ,d.name as veh_CARGO_BT_nm
      ,a.[veh_HAZ_INV]
	  ,r.name as veh_HAZ_INV_nm
      ,a.[veh_HAZ_PLAC]
	  ,s.name as veh_HAZ_PLAC_nm
      ,a.[veh_HAZ_ID]--specific to each car
      ,a.[veh_HAZ_CNO]
	  ,q.name as veh_HAZ_CNO_nm
      ,a.[veh_HAZ_REL]
	  ,t.name as veh_HAZ_REL_nm
      ,a.[veh_BUS_USE]
	  ,c.name as veh_BUS_USE_nm
      ,a.[veh_SPEC_USE]
	  ,an.name as veh_SPEC_USE_nm
      ,a.[veh_EMER_USE]
	  ,m.name as veh_EMER_USE_nm
      ,a.[veh_TRAV_SP] --?
      ,a.[veh_UNDERIDE]
	  ,ar.name as veh_UNDERIDE_nm
      ,a.[veh_ROLLOVER]
	  ,am.name as veh_ROLLOVER_nm
      ,a.[veh_ROLINLOC]
	  ,al.name as veh_ROLINLOC_nm
      ,a.[veh_IMPACT1]
	  ,v.name as veh_IMPACT1_nm
      ,a.[veh_DEFORMED]
	  ,f.name as veh_DEFORMED_nm
      ,a.[veh_TOWED]
	  ,aq.name as veh_TOWED_nm
      ,a.[veh_M_HARM]
	  ,ad.name as veh_M_HARM_nm
      ,a.[veh_VEH_SC1]
	  ,ax.name as veh_VEH_SC1_nm
      ,a.[veh_VEH_SC2]
	  ,ay.name as veh_VEH_SC2_nm
      ,a.[veh_FIRE_EXP]
	  ,n.name as veh_FIRE_EXP_nm
      ,a.[veh_DR_PRES]
	  ,h.name as veh_DR_PRES_nm
      ,a.[veh_L_STATE]
	  ,aa.name as veh_L_STATE_nm
      ,a.[veh_DR_ZIP] --more granular than rural/urban
      ,a.[veh_L_STATUS]
	  ,ab.name as veh_L_STATUS_nm
      ,a.[veh_L_TYPE]
	  ,ac.name as veh_L_TYPE_nm
      ,a.[veh_CDL_STAT]
	  ,e.name as veh_CDL_STAT_nm
      ,a.[veh_L_ENDORS]
	  ,y.name as veh_L_ENDORS_nm
      ,a.[veh_L_COMPL]
	  ,x.name as veh_L_COMPL_nm
      ,a.[veh_L_RESTRI]
	  ,z.name as veh_L_RESTRI_nm
      ,a.[veh_DR_HGT] --int
      ,a.[veh_DR_WGT]  --int
      ,a.[veh_prev_sus]  --?
      ,a.[veh_PREV_ACC]
      ,a.[veh_PREV_DWI]
      ,a.[veh_PREV_SPD]
      ,a.[veh_PREV_OTH]
      ,a.[veh_FIRST_MO]
	  ,bh.name as veh_FIRST_MO_nm
      ,a.[veh_FIRST_YR]
      ,a.[veh_LAST_MO]
	  ,bi.name as veh_LAST_MO_nm
      ,a.[veh_LAST_YR]
      ,a.[veh_SPEEDREL]
	  ,ao.name as veh_SPEEDREL_nm
      ,a.[veh_DR_SF1]
	  ,i.name as veh_DR_SF1_nm
      ,a.[veh_DR_SF2]
	  ,j.name as veh_DR_SF2_nm
      ,a.[veh_DR_SF3]
	  ,k.name as veh_DR_SF3_nm
      ,a.[veh_DR_SF4]
	  ,l.name as veh_DR_SF4_nm
      ,a.[veh_VTRAFWAY]
	  ,bf.name as veh_VTRAFWAY_nm
      ,a.[veh_VNUM_LAN]
	  ,az.name as veh_VNUM_LAN_nm
      ,a.[veh_VSPD_LIM]  --int?
      ,a.[veh_VALIGN]
	  ,av.name as veh_VALIGN_nm
      ,a.[veh_VPROFILE]
	  ,bb.name as veh_VPROFILE_nm
      ,a.[veh_VPAVETYP]
	  ,ba.name as veh_VPAVETYP_nm
      ,a.[veh_VSURCOND]
	  ,bc.name as veh_VSURCOND_nm
      ,a.[veh_VTRAFCON]
	  ,be.name as veh_VTRAFCON_nm
      ,a.[veh_VTCONT_F]
	  ,bd.name as veh_VTCONT_F_nm
      ,a.[veh_P_CRASH1]
	  ,af.name as veh_P_CRASH1_nm
      ,a.[veh_P_CRASH2]
	  ,ag.name as veh_P_CRASH2_nm
      ,a.[veh_P_CRASH3]
	  ,ah.name as veh_P_CRASH3_nm
      ,a.[veh_P_CRASH4]
	  ,ai.name as veh_P_CRASH_4nm
      ,a.[veh_P_CRASH5]
	  ,aj.name as veh_P_CRASH5_nm
      ,a.[veh_ACC_TYPE]
	  ,bg.name as veh_ACC_TYP_nm
      ,a.[veh_TRLR1VIN] --specific to trailer
      ,a.[veh_TRLR2VIN]--specific to trailer
      ,a.[veh_TRLR3VIN]--specific to trailer
      ,a.[veh_DEATHS] --int
      ,a.[veh_DR_DRINK]
	  ,g.name as veh_DR_DRINK_nm
      ,a.[oth_veh_prev_sus]
      ,a.[oth_veh_PREV_ACC]
      ,a.[oth_veh_PREV_DWI]
      ,a.[oth_veh_PREV_SPD]
      ,a.[oth_veh_PREV_OTH]
      ,a.[per_aux_A_AGE1]
	  ,a.per_aux_A_AGE1_nm
      ,a.[per_aux_A_AGE2]
	  ,a.per_aux_A_AGE2_nm
      ,a.[per_aux_A_AGE3]
	  ,a.per_aux_A_AGE3_nm
      ,a.[per_aux_A_AGE4]
	  ,a.per_aux_A_AGE4_nm
      ,a.[per_aux_A_AGE5]
	  ,a.per_aux_A_AGE5_nm
      ,a.[per_aux_A_AGE6]
	  ,a.per_aux_A_AGE6_nm
      ,a.[per_aux_A_AGE7]
	  ,a.per_aux_A_AGE7_nm
      ,a.[per_aux_A_AGE8]
	  ,a.per_aux_A_AGE8_nm
      ,a.[per_aux_A_AGE9]
	  ,a.per_aux_A_AGE9_nm
      ,a.[per_aux_PER_NO]
      ,a.[per_aux_A_PTYPE]
	  ,a.per_aux_A_PTYPE_nm
      ,a.[per_aux_A_RESTUSE]
	  ,a.per_aux_A_RESTUSE_nm
      ,a.[per_aux_A_HELMUSE]
	  ,a.per_aux_A_HELMUSE_nm
      ,a.[per_aux_A_ALCTES]
	  ,a.per_aux_A_ALCTES_nm
      ,a.[per_aux_A_HISP]
	  ,a.per_aux_A_HISP_nm
      ,a.[per_aux_A_RCAT]
	  ,a.per_aux_A_RCAT_nm
      ,a.[per_aux_A_HRACE]
	  ,a.per_aux_A_HRACE_nm
      ,a.[per_aux_A_EJECT]
	  ,a.per_aux_A_EJECT_nm
      ,a.[per_aux_A_PERINJ]
      ,a.[per_aux_A_LOC]
      ,a.[per_STR_VEH]
      ,a.[per_COUNTY]
      ,a.[per_DAY]
      ,a.[per_MONTH]
      ,a.[per_HOUR]
      ,a.[per_MINUTE]
      ,a.[per_RUR_URB]
      ,a.[per_FUNC_SYS]
      ,a.[per_HARM_EV]
      ,a.[per_MAN_COLL]
      ,a.[per_SCH_BUS]
      ,a.[per_MAKE]
      ,a.[per_MAK_MOD]
      ,a.[per_BODY_TYP]
      ,a.[per_MOD_YEAR] --int
      ,a.[per_TOW_VEH]
      ,a.[per_SPEC_USE]
      ,a.[per_EMER_USE]
      ,a.[per_ROLLOVER]
      ,a.[per_IMPACT1]
      ,a.[per_FIRE_EXP]
      ,a.[per_AGE]--int
      ,a.[per_SEX]
	  ,a.per_SEX_nm
      ,a.[per_PER_TYPE]
	  ,a.per_PER_TYPE_nm
      ,a.[per_INJ_SEV] --unary
      ,a.[per_SEAT_POS]
	  ,a.per_SEAT_POS_nm
      ,a.[per_REST_USE]
	  ,a.per_REST_USE_nm
      ,a.[per_REST_MIS]
	  ,a.per_REST_MIS_nm
      ,a.[per_AIG_BAG]
	  ,a.per_AIG_BAG_nm
      ,a.[per_EJECTION]
	  ,a.per_EJECTION_nm
      ,a.[per_EJ_PATH]
	  ,a.per_EJ_PATH_nm
      ,a.[per_EXTRICAT]
	  ,a.per_EXTRICAT_nm
      ,a.[per_DRINKING]
	  ,a.per_DRINKING_nm
      ,a.[per_ALC_DET]
	  ,a.per_ALC_DET_nm
      ,a.[per_ALC_STATUS]
	  ,a.per_ALC_STATUS_nm
      ,a.[per_ATST_TYPE]
	  ,a.per_ATST_TYPE_nm
      ,a.[per_ALC_RES]
      ,a.[per_DRUGS]
	  ,a.per_DRUGS_nm
      ,a.[per_DRUG_DET]
	  ,a.per_DRUG_DET_nm
      ,a.[per_DSTATUS]
	  ,a.per_DSTATUS_nm
      ,a.[per_HOSPITAL]
	  ,a.per_HOSPITAL_nm
      ,a.[per_DOA]
	  ,a.per_DOA_nm
      ,a.[per_DEATH_DA]
      ,a.[per_DEATH_MO]
	  ,a.per_DEATH_MO_nm
      ,a.[per_DEATH_YR]
      ,a.[per_DEATH_HR]
      ,a.[per_DEATH_MN]
      ,a.[per_DEATH_TM]
      ,a.[per_LAG_HRS]
      ,a.[per_LAG_MINS]
      ,a.[per_P_SF1]
	  ,a.per_P_SF1_nm
      ,a.[per_P_SF2]
	  ,a.per_P_SF2_nm
      ,a.[per_P_SF3]
	  ,a.per_P_SF3_nm
      ,a.[per_WORK_INJ]
	  ,a.per_WORK_INJ_nm
      ,a.[per_HISPANIC]
	  ,a.per_HISPANIC_nm
      ,a.[per_RACE]
	  ,a.per_RACE_nm
      ,a.[per_LOCATION] --unary
      ,a.[per_DRUG_TEST]
	  ,a.per_DRUG_TEST_nm
      ,a.[per_Drugs_Not_Tested]
	  ,a.per_Drugs_Not_Tested_nm
      ,a.[per_Drugs_Negative]
	  ,a.per_Drugs_Negative_nm
      ,a.[per_Drugs_Not_Reported]
	  ,a.per_Drugs_Not_Reported_nm
      ,a.[per_Drugs_Other]
	  ,a.per_Drugs_Other_nm
      ,a.[per_Drugs_Tested_Result_Unknown]
	  ,a.per_Drugs_Tested_Result_Unknown_nm
      ,a.[per_Drugs_Tested_Positive_Unknown_Type]
	  ,a.per_Drugs_Tested_Positive_Unknown_Type_nm
      ,a.[per_Drugs_Unknown_if_tested]
	  ,a.per_Drugs_Unknown_if_tested_nm
      ,a.[per_Drugs_Narcotic]
	  ,a.per_Drugs_Narcotic_nm
      ,a.[per_Drugs_Depressant]
	  ,a.per_Drugs_Depressant_nm
      ,a.[per_Drugs_Stimulant]
	  ,a.per_Drugs_Stimulant_nm
      ,a.[per_Drugs_Hallucinogen]
	  ,a.per_Drugs_Hallucinogen_nm
      ,a.[per_Drugs_Cannabinoid]
	  ,a.per_Drugs_Cannabinoid_nm
      ,a.[per_Drugs_PCP]
	  ,a.per_Drugs_PCP_nm
      ,a.[per_Drugs_Anabolic_Steroid]
	  ,a.per_Drugs_Anabolic_Steroid_nm
      ,a.[per_Drugs_Inhalant]
	  ,a.per_Drugs_Inhanlant_nm
  FROM [FARS].[dbo].[raw_final_7] a
left join [dbo].[v_veh_BODY_TYP] b
  on a.veh_BODY_TYP=b.value
left join [dbo].[v_veh_BUS_USE] c
on a.veh_BUS_USE=c.value
left join [dbo].[v_veh_CARGO_BT] d
on a.veh_CARGO_BT=d.value
left join [dbo].[v_veh_CDL_STAT] e
on a.veh_CDL_STAT=e.value
left join [dbo].[v_veh_DEFORMED] f
on a.veh_DEFORMED=f.value
left join [dbo].[v_veh_DR_DRINK] g
on a.veh_DR_DRINK=g.value
left join [dbo].[v_veh_DR_PRES] h
on a.veh_DR_PRES=h.value
left join [dbo].[v_veh_DR_SF1] i
on a.veh_DR_SF1=i.value
left join [dbo].[v_veh_DR_SF2] j
on a.veh_DR_SF2=j.value
left join [dbo].[v_veh_DR_SF3] k
on a.veh_DR_SF3=k.value
left join [dbo].[v_veh_DR_SF4] l
on a.veh_DR_SF4=l.value
left join [dbo].[v_veh_emer_use] m
on a.veh_emer_use=m.value
left join [dbo].[v_veh_FIRE_EXP] n
on a.veh_FIRE_EXP=n.value
left join [dbo].[v_veh_GVWR] o
on a.veh_GVWR=o.value
left join [dbo].[v_veh_HARM_EV] p
on a.veh_HARM_EV=p.value
left join [dbo].[v_veh_HAZ_CNO] q
on a.veh_HAZ_CNO=q.value
left join [dbo].[v_veh_HAZ_INV] r
on a.veh_HAZ_INV=r.value
left join [dbo].[v_veh_HAZ_PLAC] s
on a.veh_HAZ_PLAC=s.value
left join [dbo].[v_veh_HAZ_REL] t
on a.veh_HAZ_REL=t.value
left join [dbo].[v_veh_HIT_RUN] u
on a.veh_HIT_RUN=u.value
left join [dbo].[v_veh_IMPACT1] v
on a.veh_IMPACT1=v.value
left join [dbo].[v_veh_J_KNIFE] w
on a.veh_J_KNIFE=w.value
left join [dbo].[v_veh_L_COMPL] x
on a.veh_L_COMPL=x.value
left join [dbo].[v_veh_L_ENDORS] y
on a.veh_L_ENDORS=y.value
left join [dbo].[v_veh_L_RESTRI] z
on a.veh_L_RESTRI=z.value
left join [dbo].[v_veh_L_STATE] aa
on a.veh_L_STATE=aa.value
left join [dbo].[v_veh_L_STATUS] ab
on a.veh_L_STATUS=ab.value
left join [dbo].[v_veh_L_TYPE] ac
on a.veh_L_TYPE=ac.value
left join [dbo].[v_veh_M_HARM] ad
on a.veh_M_HARM=ad.value
left join [dbo].[v_veh_OWNER] ae
on a.veh_OWNER=ae.value
left join [dbo].[v_veh_P_CRASH1] af
on a.veh_P_CRASH1=af.value
left join [dbo].[v_veh_P_CRASH2] ag
on a.veh_P_CRASH2=ag.value
left join [dbo].[v_veh_P_CRASH3] ah
on a.veh_P_CRASH3=ah.value
left join [dbo].[v_veh_P_CRASH4] ai
on a.veh_P_CRASH4=ai.value
left join [dbo].[v_veh_P_CRASH5] aj
on a.veh_P_CRASH5=aj.value
left join [dbo].[v_veh_REG_STAT] ak
on a.veh_REG_STAT=ak.value
left join [dbo].[v_veh_ROLINLOC] al
on a.veh_ROLINLOC=al.value
left join [dbo].[v_veh_ROLLOVER] am
on a.veh_ROLLOVER=am.value
left join [dbo].[v_veh_SPEC_USE] an
on a.veh_SPEC_USE=an.value
left join [dbo].[v_veh_SPEEDREL] ao
on a.veh_SPEEDREL=ao.value
left join [dbo].[v_veh_TOW_VEH] ap
on a.veh_TOW_VEH=ap.value
left join [dbo].[v_veh_TOWED] aq
on a.veh_TOWED=aq.value
left join [dbo].[v_veh_UNDERIDE] ar
on a.veh_UNDERIDE=ar.value
left join [dbo].[v_veh_V_CONFIG] au
on a.veh_V_CONFIG=au.value
left join [dbo].[v_veh_VALIGN] av
on a.veh_VALIGN=av.value
left join [dbo].[v_veh_VEH_SC1] ax
on a.veh_VEH_SC1=ax.value
left join [dbo].[v_veh_VEH_SC2] ay
on a.veh_VEH_SC2=ay.value
left join [dbo].[v_veh_VNUM_LAN] az
on a.veh_VNUM_LAN=az.value
left join [dbo].[v_veh_VPAVETYP] ba
on a.veh_VPAVETYP=ba.value
left join [dbo].[v_veh_VPROFILE] bb
on a.veh_VPROFILE=bb.value
left join [dbo].[v_veh_VSURCOND] bc
on a.veh_VSURCOND=bc.value
left join [dbo].[v_veh_VTCONT_F] bd
on a.veh_VTCONT_F=bd.value
left join [dbo].[v_veh_VTRAFCON] be
on a.veh_VTRAFCON=be.value
left join [dbo].[v_veh_VTRAFWAY] bf
on a.veh_VTRAFWAY=bf.value
left join dbo.v_veh_ACC_TYPE bg
on a.veh_ACC_TYPE=bg.value
left join dbo.v_veh_First_Mo bh
on a.veh_first_mo=bh.value
left join dbo.v_veh_last_mo bi
on a.veh_last_mo=bi.value
) as combined

---------------------------------------------------------------------------------
--Step 19
--Take dbo.raw_final_8 and remove unary variables and those not defined in data dictionary
--Also join to dd_make to pull in vehicle make
--create table dbo.raw_final_9
--Row count should be 58,337
---------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_final_9]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_final_9]
END

select * into [dbo].[raw_final_9]
from 
	(select concat([Key],'_',[veh_aux_VEH_NO],'_',[per_aux_PER_NO]) as [Key]--Year_StateCase_VehNo_PerNo
      ,[acc_aux_STATE] --not in data dictionary, but keep as not in acc file
      ,[acc_aux_STATE_nm]--not in data dictionary, but keep as not in acc file
      --,[acc_aux_COUNTY] remove, not in data dictionary; covered in acc file
      --,[acc_aux_FATALS] remove, not in data dictionary; covered in acc file
      --,[acc_aux_A_CRAINJ] remove as unary
      ,[acc_aux_A_REGION]
      ,[acc_aux_A_REGION_nm]
      ,[acc_aux_A_RU]
      ,[acc_aux_A_RU_nm]
      ,[acc_aux_A_INTER]
      ,[acc_aux_A_INTER_nm]
      ,[acc_aux_A_RELRD]
      ,[acc_aux_A_RELRD_nm]
      ,[acc_aux_A_INTSEC]
      ,[acc_aux_A_INTSEC_nm]
      ,[acc_aux_A_ROADFC]
      ,[acc_aux_A_ROADFC_nm]
      ,[acc_aux_A_JUNC]
      ,[acc_aux_A_JUNC_nm]
      ,[acc_aux_A_MANCOL]
      ,[acc_aux_A_MANCOL_nm]
      ,[acc_aux_A_TOD]
      ,[acc_aux_A_TOD_nm]
      ,[acc_aux_A_DOW]
      ,[acc_aux_A_DOW_nm]
      ,[acc_aux_A_CT]
      ,[acc_aux_A_CT_nm]
      ,[acc_aux_A_LT]
      ,[acc_aux_A_LT_nm]
      ,[acc_aux_A_MC]
      ,[acc_aux_A_MC_nm]
      ,[acc_aux_A_SPCRA]
      ,[acc_aux_A_SPCRA_nm]
      ,[acc_aux_A_PED]
      ,[acc_aux_A_PED_nm]
      --,[acc_aux_A_PED_F] remove, not in data dictionary
      ,[acc_aux_A_PEDAL]
      ,[acc_aux_A_PEDAL_nm]
      --,[acc_aux_A_PEDAL_F] remove, not in data dictionary
      ,[acc_aux_A_ROLL]
      ,[acc_aux_A_ROLL_nm]
      ,[acc_aux_A_POLPUR]
      ,[acc_aux_A_POLPUR_nm]
      ,[acc_aux_A_POSBAC]
      ,[acc_aux_A_POSBAC_nm]
      ,[acc_aux_A_D15_19]
      ,[acc_aux_A_D15_19_nm]
      ,[acc_aux_A_D16_19]
      ,[acc_aux_A_D16_19_nm]
      ,[acc_aux_A_D15_20]
      ,[acc_aux_A_D15_20_nm]
      ,[acc_aux_A_D16_20]
      ,[acc_aux_A_D16_20_nm]
      ,[acc_aux_A_D65PLS]
      ,[acc_aux_A_D65PLS_nm]
      ,[acc_aux_A_D21_24]
      ,[acc_aux_A_D21_24_nm]
      ,[acc_aux_A_D16_24]
      ,[acc_aux_A_D16_24_nm]
      ,[acc_aux_A_RD]
      ,[acc_aux_A_RD_nm]
      ,[acc_aux_A_HR]
      ,[acc_aux_A_HR_nm]
      ,[acc_aux_A_DIST]
      ,[acc_aux_A_DIST_nm]
      ,[acc_aux_A_DROWSY]
      ,[acc_aux_A_DROWSY_nm]
      ,[acc_aux_BIA]
      ,[acc_aux_BIA_nm]
      ,[acc_aux_SPJ_INDIAN]
      ,[acc_aux_SPJ_INDIAN_nm]
      ,[acc_aux_INDIAN_RES]
      ,[acc_aux_INDIAN_RES_nm]
	  --34 acc_aux fields - matches data dictionary
      ,[acc_VE_TOTAL] --int
      ,[acc_VE_FORMS] --int
      ,[acc_PVH_INVL] --int
      ,[acc_PEDS] --int
      ,[acc_PERNOTMVIT] --int
      ,[acc_PERMVIT] --int
      ,[acc_PERSONS] --int
      ,[acc_COUNTY] --not defined as likely not keeping as lower level than target variable
      ,[acc_CITY]--not defined as likely not keeping as lower level than target variable
      ,[acc_DAY] --time
      ,[acc_MONTH]
      ,[acc_MONTH_nm]
      ,[acc_YEAR] --time
      ,[acc_DAY_WEEK]
      ,[acc_DAY_WEEK_nm]
      ,[acc_HOUR] --time
      ,[acc_MINUTE]  --time
      ,[acc_NHS]
      ,[acc_NHS_nm]
      ,[acc_RUR_URB]
      ,[acc_RUR_URB_nm]
      ,[acc_FUNC_SYS]
      ,[acc_FUNC_SYS_nm]
      ,[acc_RD_OWNER]
      ,[acc_RD_OWNER_nm]
      ,[acc_ROUTE]
      ,[acc_ROUTE_nm]
      ,[acc_TWAY_ID]--not defined as likely not keeping as lower level than target variable
      ,[acc_TWAY_ID2] --not defined as likely not keeping as lower level than target variable
      ,[acc_MILEPT] --not defined as likely not keeping as lower level than target variable
      ,[acc_LATITUDE] --not defined as likely not keeping as lower level than target variable
      ,[acc_LONGITUD] --not defined as likely not keeping as lower level than target variable
      ,[acc_SP_JUR]
      ,[acc_SP_JUR_nm]
      ,[acc_HARM_EV]
      ,[acc_HARM_EV_nm]
      ,[acc_MAN_COLL]
      ,[acc_MAN_COLL_nm]
      ,[acc_RELJCT1]
      ,[acc_RELJCT1_nm]
      ,[acc_RELJCT2]
      ,[acc_RELJCT2_nm]
      ,[acc_TYP_INT]
      ,[acc_TYP_INT_nm]
      ,[acc_WRK_ZONE]
      ,[acc_WRK_ZONE_nm]
      ,[acc_REL_ROAD]
      ,[acc_REL_ROAD_nm]
      ,[acc_LGT_COND]
      ,[acc_LGT_COND_nm]
      ,[acc_WEATHER1]
      ,[acc_WEATHER1_nm]
      ,[acc_WEATHER2]
      ,[acc_WEATHER2_nm]
      ,[acc_WEATHER]
      ,[acc_WEATHER_nm]
      ,[acc_SCH_BUS]
      ,[acc_SCH_BUS_nm]
      ,[acc_RAIL]--not defined as likely not keeping as lower level than target variable
      ,[acc_NOT_HOUR] --time
      ,[acc_NOT_MIN] --time
      ,[acc_ARR_HOUR] --time
      ,[acc_ARR_MIN] --time
      ,[acc_HOSP_HR] --time
      ,[acc_HOSP_MN] --time
      ,[acc_CF1]
      ,[acc_CF1_nm]
      ,[acc_CF2]
      ,[acc_CF2_nm]
      ,[acc_CF3]
      ,[acc_CF3_nm]
      ,[acc_FATALS] --int
      ,[acc_DRUNK_DR] --int
	   --50 acc fields - matches data dictionary
      --,[veh_aux_VEH_NO] --int, not in data dictionary, part of ID, not to be used in analysis
      ,[veh_aux_A_BODY]
      ,[veh_aux_A_BODY_nm]
      ,[veh_aux_A_IMP1]
      ,[veh_aux_A_IMP1_nm]
      ,[veh_aux_A_VROLL]
      ,[veh_aux_A_VROLL_nm]
      ,[veh_aux_A_LIC_S]
      ,[veh_aux_A_LIC_S_nm]
      ,[veh_aux_A_LIC_C]
      ,[veh_aux_A_LIC_C_nm]
      ,[veh_aux_A_CDL_S]
      ,[veh_aux_A_CDL_S_nm]
      ,[veh_aux_A_MC_L_S]
      ,[veh_aux_A_MC_L_S_nm]
      ,[veh_aux_A_SPVEH]
      ,[veh_aux_A_SPVEH_nm]
      ,[veh_aux_A_SBUS]
      ,[veh_aux_A_SBUS_nm]
      ,[veh_aux_A_MOD_YR] --int
      ,[veh_aux_A_DRDIS]
      ,[veh_aux_A_DRDIS_nm]
      ,[veh_aux_A_DRDRO]
      ,[veh_aux_A_DRDRO_nm]
	  --12 veh_aux fields - matches data dictionary
      ,[veh_NUMOCCS] --int
      --,[veh_DAY] --remove, not in data dictionary
      --,[veh_MONTH] --remove, not in data dictionary
      --,[veh_HOUR] --remove, not in data dictionary
      --,[veh_MINUTE] --remove, not in data dictionary
      ,[veh_HARM_EV]
      ,[veh_HARM_EV_nm]
      --,[veh_MAN_COLL] --remove, not in data dictionary
      --,[veh_UNITTYPE] --remove, unary
      ,[veh_HIT_RUN]
      ,[veh_HIT_RUN_nm]
      ,[veh_REG_STAT]
      ,[veh_REG_STAT_nm]
      ,[veh_OWNER]
      ,[veh_OWNER_nm]
      ,[veh_MAKE]
	  ,b.make_name as veh_MAKE_nm
      ,[veh_MODEL]
      ,[veh_MAK_MOD]
      ,[veh_BODY_TYP]
      ,[veh_BODY_TYP_nm]
      ,[veh_MOD_YEAR] --int
      --,[veh_VIN] --remove, too granular
      --,[veh_VIN_1] --remove, too granular
      --,[veh_VIN_2]--remove, too granular
      --,[veh_VIN_3]--remove, too granular
      --,[veh_VIN_4]--remove, too granular
      --,[veh_VIN_5]--remove, too granular
      --,[veh_VIN_6]--remove, too granular
      --,[veh_VIN_7]--remove, too granular
      --,[veh_VIN_8]--remove, too granular
      --,[veh_VIN_9]--remove, too granular
      --,[veh_VIN_10]--remove, too granular
      --,[veh_VIN_11]--remove, too granular
      --,[veh_VIN_12]--remove, too granular
      ,[veh_TOW_VEH]
      ,[veh_TOW_VEH_nm]
      ,[veh_J_KNIFE]
      ,[veh_J_KNIFE_nm]
      --,[veh_MCARR_11]--remove, too granular
      --,[veh_MCARR_12]--remove, too granular, all null
      --,[veh_MCARR_ID] --remove, too granular
      ,[veh_GVWR]
      ,[veh_GVWR_nm]
      ,[veh_V_CONFIG]
      ,[veh_V_CONFIG_nm]
      ,[veh_CARGO_BT]
      ,[veh_CARGO_BT_nm]
      ,[veh_HAZ_INV]
      ,[veh_HAZ_INV_nm]
      ,[veh_HAZ_PLAC]
      ,[veh_HAZ_PLAC_nm]
      ,[veh_HAZ_ID]--remove, too granular
      ,[veh_HAZ_CNO]
      ,[veh_HAZ_CNO_nm]
      ,[veh_HAZ_REL]
      ,[veh_HAZ_REL_nm]
      ,[veh_BUS_USE]
      ,[veh_BUS_USE_nm]
      ,[veh_SPEC_USE]
      ,[veh_SPEC_USE_nm]
      ,[veh_EMER_USE]
      ,[veh_EMER_USE_nm]
      ,[veh_TRAV_SP]--int
      ,[veh_UNDERIDE]
      ,[veh_UNDERIDE_nm]
      ,[veh_ROLLOVER]
      ,[veh_ROLLOVER_nm]
      ,[veh_ROLINLOC]
      ,[veh_ROLINLOC_nm]
      ,[veh_IMPACT1]
      ,[veh_IMPACT1_nm]
      ,[veh_DEFORMED]
      ,[veh_DEFORMED_nm]
      ,[veh_TOWED]
      ,[veh_TOWED_nm]
      ,[veh_M_HARM]
      ,[veh_M_HARM_nm]
      ,[veh_VEH_SC1]
      ,[veh_VEH_SC1_nm]
      ,[veh_VEH_SC2]
      ,[veh_VEH_SC2_nm]
      ,[veh_FIRE_EXP]
      ,[veh_FIRE_EXP_nm]
      ,[veh_DR_PRES]
      ,[veh_DR_PRES_nm]
      ,[veh_L_STATE]
      ,[veh_L_STATE_nm]
      ,[veh_DR_ZIP]--remove, too granular
      ,[veh_L_STATUS]
      ,[veh_L_STATUS_nm]
      ,[veh_L_TYPE]
      ,[veh_L_TYPE_nm]
      ,[veh_CDL_STAT]
      ,[veh_CDL_STAT_nm]
      ,[veh_L_ENDORS]
      ,[veh_L_ENDORS_nm]
      ,[veh_L_COMPL]
      ,[veh_L_COMPL_nm]
      ,[veh_L_RESTRI]
      ,[veh_L_RESTRI_nm]
      ,[veh_DR_HGT]--int
      ,[veh_DR_WGT]--int
      ,[veh_prev_sus]--int
      ,[veh_PREV_ACC]--int
      ,[veh_PREV_DWI]--int
      ,[veh_PREV_SPD]--int
      ,[veh_PREV_OTH]--int
      ,[veh_FIRST_MO]
      ,[veh_FIRST_MO_nm]
      ,[veh_FIRST_YR]--int
      ,[veh_LAST_MO]
      ,[veh_LAST_MO_nm]
      ,[veh_LAST_YR]--int
      ,[veh_SPEEDREL]
      ,[veh_SPEEDREL_nm]
      ,[veh_DR_SF1]
      ,[veh_DR_SF1_nm]
      ,[veh_DR_SF2]
      ,[veh_DR_SF2_nm]
      ,[veh_DR_SF3]
      ,[veh_DR_SF3_nm]
      ,[veh_DR_SF4]
      ,[veh_DR_SF4_nm]
      ,[veh_VTRAFWAY]
      ,[veh_VTRAFWAY_nm]
      ,[veh_VNUM_LAN]
      ,[veh_VNUM_LAN_nm]
      ,[veh_VSPD_LIM]--int
      ,[veh_VALIGN]
      ,[veh_VALIGN_nm]
      ,[veh_VPROFILE]
      ,[veh_VPROFILE_nm]
      ,[veh_VPAVETYP]
      ,[veh_VPAVETYP_nm]
      ,[veh_VSURCOND]
      ,[veh_VSURCOND_nm]
      ,[veh_VTRAFCON]
      ,[veh_VTRAFCON_nm]
      ,[veh_VTCONT_F]
      ,[veh_VTCONT_F_nm]
      ,[veh_P_CRASH1]
      ,[veh_P_CRASH1_nm]
      ,[veh_P_CRASH2]
      ,[veh_P_CRASH2_nm]
      ,[veh_P_CRASH3]
      ,[veh_P_CRASH3_nm]
      ,[veh_P_CRASH4]
      ,[veh_P_CRASH_4nm]
      ,[veh_P_CRASH5]
      ,[veh_P_CRASH5_nm]
      ,[veh_ACC_TYPE]
	  ,[veh_ACC_TYP_nm]
      ,[veh_TRLR1VIN]--remove, too granular
      ,[veh_TRLR2VIN]--remove, too granular
      ,[veh_TRLR3VIN]--remove, too granular
      ,[veh_DEATHS]--int
      ,[veh_DR_DRINK]
      ,[veh_DR_DRINK_nm]
	  --95 veh fields - matches data dictionary
      ,[oth_veh_prev_sus]--int
      ,[oth_veh_PREV_ACC]--int
      ,[oth_veh_PREV_DWI]--int
      ,[oth_veh_PREV_SPD]--int
      ,[oth_veh_PREV_OTH]--int
	  --derived from other vehicles in same accident
      ,[per_aux_A_AGE1]
      ,[per_aux_A_AGE1_nm]
      ,[per_aux_A_AGE2]
      ,[per_aux_A_AGE2_nm]
      ,[per_aux_A_AGE3]
      ,[per_aux_A_AGE3_nm]
      ,[per_aux_A_AGE4]
      ,[per_aux_A_AGE4_nm]
      ,[per_aux_A_AGE5]
      ,[per_aux_A_AGE5_nm]
      ,[per_aux_A_AGE6]
      ,[per_aux_A_AGE6_nm]
      ,[per_aux_A_AGE7]
      ,[per_aux_A_AGE7_nm]
      ,[per_aux_A_AGE8]
      ,[per_aux_A_AGE8_nm]
      ,[per_aux_A_AGE9]
      ,[per_aux_A_AGE9_nm]
      --,[per_aux_PER_NO]--ID part of provided key, not to be used in analysis, not in data dictionary
      ,[per_aux_A_PTYPE]
      ,[per_aux_A_PTYPE_nm]
      ,[per_aux_A_RESTUSE]
      ,[per_aux_A_RESTUSE_nm]
      ,[per_aux_A_HELMUSE]
      ,[per_aux_A_HELMUSE_nm]
      ,[per_aux_A_ALCTES]
      ,[per_aux_A_ALCTES_nm]
      ,[per_aux_A_HISP]
      ,[per_aux_A_HISP_nm]
      ,[per_aux_A_RCAT]
      ,[per_aux_A_RCAT_nm]
      ,[per_aux_A_HRACE]
      ,[per_aux_A_HRACE_nm]
      ,[per_aux_A_EJECT]
      ,[per_aux_A_EJECT_nm]
     -- ,[per_aux_A_PERINJ]--remove unary
     -- ,[per_aux_A_LOC] -- remove unary
	  --19 variables in per_aux, same as data dictionary
      --,[per_STR_VEH]--remove unary
      --,[per_COUNTY]-- remove not in data dictionary
      --,[per_DAY] -- remove not in data dictionary
      --,[per_MONTH]-- remove not in data dictionary
      --,[per_HOUR]-- remove not in data dictionary
      --,[per_MINUTE]-- remove not in data dictionary
      --,[per_RUR_URB] --remove, not in data dictionary
      --,[per_FUNC_SYS]-- remove not in data dictionary
      --,[per_HARM_EV]-- remove not in data dictionary
      --,[per_MAN_COLL]-- remove not in data dictionary
      --,[per_SCH_BUS]-- remove not in data dictionary
      --,[per_MAKE]-- remove not in data dictionary
      --,[per_MAK_MOD]-- remove not in data dictionary
      --,[per_BODY_TYP]-- remove not in data dictionary
      --,[per_MOD_YEAR]-- remove not in data dictionary
      --,[per_TOW_VEH]-- remove not in data dictionary
      --,[per_SPEC_USE]-- remove not in data dictionary
      --,[per_EMER_USE]-- remove not in data dictionary
      --,[per_ROLLOVER]-- remove not in data dictionary
      --,[per_IMPACT1]-- remove not in data dictionary
      --,[per_FIRE_EXP]-- remove not in data dictionary
      ,[per_AGE]
      ,[per_SEX]
      ,[per_SEX_nm]
      ,[per_PER_TYPE]
      ,[per_PER_TYPE_nm]
      --,[per_INJ_SEV] -- remove unary
      ,[per_SEAT_POS]
      ,[per_SEAT_POS_nm]
      ,[per_REST_USE]
      ,[per_REST_USE_nm]
      ,[per_REST_MIS]
      ,[per_REST_MIS_nm]
      ,[per_AIG_BAG]
      ,[per_AIG_BAG_nm]
      ,[per_EJECTION]
      ,[per_EJECTION_nm]
      ,[per_EJ_PATH]
      ,[per_EJ_PATH_nm]
      ,[per_EXTRICAT]
      ,[per_EXTRICAT_nm]
      ,[per_DRINKING]
      ,[per_DRINKING_nm]
      ,[per_ALC_DET]
      ,[per_ALC_DET_nm]
      ,[per_ALC_STATUS]
      ,[per_ALC_STATUS_nm]
      ,[per_ATST_TYPE]
      ,[per_ATST_TYPE_nm]
      ,[per_ALC_RES]
      ,[per_DRUGS]
      ,[per_DRUGS_nm]
      ,[per_DRUG_DET]
      ,[per_DRUG_DET_nm]
      ,[per_DSTATUS]
      ,[per_DSTATUS_nm]
      ,[per_HOSPITAL]
      ,[per_HOSPITAL_nm]
      ,[per_DOA]
      ,[per_DOA_nm]
      ,[per_DEATH_DA]
      ,[per_DEATH_MO]
	  ,per_DEATH_MO_nm
      ,[per_DEATH_YR]
      ,[per_DEATH_HR]
      ,[per_DEATH_MN]
      ,[per_DEATH_TM]
      ,[per_LAG_HRS]
      ,[per_LAG_MINS]
      ,[per_P_SF1]
      ,[per_P_SF1_nm]
      ,[per_P_SF2]
      ,[per_P_SF2_nm]
      ,[per_P_SF3]
      ,[per_P_SF3_nm]
      ,[per_WORK_INJ]
      ,[per_WORK_INJ_nm]
      ,[per_HISPANIC]
      ,[per_HISPANIC_nm]
      ,[per_RACE]
      ,[per_RACE_nm]
      --,[per_LOCATION]--remove unary
	  --Per data dictionary has 43 entries, less 6 variables for DRUGTST and DRUGRES due to changes between 2017 & 2018, should be 37
	  --number of variables matches data dictionary
      ,[per_DRUG_TEST]
      ,[per_DRUG_TEST_nm]
      ,[per_Drugs_Not_Tested]
      ,[per_Drugs_Not_Tested_nm]
      ,[per_Drugs_Negative]
      ,[per_Drugs_Negative_nm]
      ,[per_Drugs_Not_Reported]
      ,[per_Drugs_Not_Reported_nm]
      ,[per_Drugs_Other]
      ,[per_Drugs_Other_nm]
      ,[per_Drugs_Tested_Result_Unknown]
      ,[per_Drugs_Tested_Result_Unknown_nm]
      ,[per_Drugs_Tested_Positive_Unknown_Type]
      ,[per_Drugs_Tested_Positive_Unknown_Type_nm]
      ,[per_Drugs_Unknown_if_tested]
      ,[per_Drugs_Unknown_if_tested_nm]
      ,[per_Drugs_Narcotic]
      ,[per_Drugs_Narcotic_nm]
      ,[per_Drugs_Depressant]
      ,[per_Drugs_Depressant_nm]
      ,[per_Drugs_Stimulant]
      ,[per_Drugs_Stimulant_nm]
      ,[per_Drugs_Hallucinogen]
      ,[per_Drugs_Hallucinogen_nm]
      ,[per_Drugs_Cannabinoid]
      ,[per_Drugs_Cannabinoid_nm]
      ,[per_Drugs_PCP]
      ,[per_Drugs_PCP_nm]
      ,[per_Drugs_Anabolic_Steroid]
      ,[per_Drugs_Anabolic_Steroid_nm]
      ,[per_Drugs_Inhalant]
      ,[per_Drugs_Inhanlant_nm]
	  --added as separate query as 2017 and 2018 data layout changed
  FROM [FARS].[dbo].[raw_final_8]
  left join FARS.dbo.dd_Makes b
  on [FARS].[dbo].[raw_final_8].[veh_MAKE] = b.make
  ) as combined