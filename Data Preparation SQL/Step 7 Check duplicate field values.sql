

--Check to see all rural/urban indicators are the same
select distinct a.[acc_RUR_URB]
 ,a.[acc_aux_A_RU]
 ,a.[acc_aux_A_RU_nm]
 ,a.[per_RUR_URB]
 ,count(*)
from dbo.raw_final_7 a
group by a.[acc_RUR_URB]
 ,a.[acc_aux_A_RU]
 ,a.[acc_aux_A_RU_nm]
 ,a.[per_RUR_URB]

--Go with acc_aux_A_RU

--Check func_sys
select distinct
a.[acc_FUNC_SYS]
,a.[per_FUNC_SYS]
from dbo.raw_final_7 a
group by a.[acc_FUNC_SYS]
,a.[per_FUNC_SYS]
--always same value
--go with acc_FUNC_SYS
--needs lookup name
      
--Check HARM_EV
select distinct
     [veh_HARM_EV]
	 ,[per_HARM_EV]
	  ,[acc_HARM_EV]
      ,[acc_HARM_EV_nm]
	 from dbo.raw_final_7
--always the same
--go with acc_HARM_EV

--Check MAN_COLL
select distinct
     [veh_MAN_COLL]
	 ,[per_MAN_COLL]
	 ,[acc_MAN_COLL]
from dbo.raw_final_7
--always the same
--needs lookup name

--Check UNITTYPE
select
    a.[veh_UNITTYPE]
--only one
--needs lookup

--Check Hit_RUN
select distinct
[veh_HIT_RUN]
,[acc_aux_A_HR]
,[acc_aux_A_HR_nm]
from dbo.raw_final_7
--not always the same!!
--veh_HIT_RUN needs to have lookup

--Check REG_STAT
select distinct
[veh_REG_STAT]
--not duplicated
--needs lookup

select distinct
[veh_OWNER]
--not duplicated
--needs lookup

select distinct      
  [veh_TOW_VEH]
   ,[per_TOW_VEH]
from dbo.raw_final_7
--always the same
--one needs to be defined

select distinct  
   [veh_J_KNIFE]
-- not duplicated - needs definition


select distinct
[veh_GVWR]
--not duplicated - needs definition

select distinct
[veh_V_CONFIG]
--not duplicated -- needs defintion

select distinct
[veh_CARGO_BT]
--not duplicated -- needs defintion

select distinct
[veh_HAZ_INV]
 ,a.[veh_HAZ_PLAC]
      ,a.[veh_HAZ_ID]
      ,a.[veh_HAZ_CNO]
      ,a.[veh_HAZ_REL]
--not duplciated -- needs defintiion

select distinct
     [veh_BUS_USE]
	  ,[per_SCH_BUS]
	   ,[acc_SCH_BUS]
      ,[acc_SCH_BUS_nm]
	   ,[veh_aux_A_SBUS]
      ,[veh_aux_A_SBUS_nm]
from dbo.raw_final_7

--veh_BUS_USE not the same -- needs lookup
--per_SCH_BUS and acc_SCH_BUS same.  keep acc_SCH_BUS
--veh_aux_A_SBUS not the same

select distinct
  [veh_SPEC_USE]
   ,[per_SPEC_USE]
from dbo.raw_final_7
--same - keep one- need to define


select distinct
[veh_EMER_USE]
 ,[per_EMER_USE]
from dbo.raw_final_7
--same - keep one - need to define

select distinct
[veh_TRAV_SP]
--not duplicate

select distinct
[veh_UNDERIDE]
--not duplicate

select distinct
[veh_ROLLOVER]
,[per_ROLLOVER]
 ,[acc_aux_A_ROLL]
 ,[acc_aux_A_ROLL_nm]
 ,[veh_aux_A_VROLL]
 ,[veh_aux_A_VROLL_nm]
 from dbo.raw_final_7
 --veh_ROLLLOVER and per_ROLLOVER same value
 --but differ from acc_aux_A_ROLL and veh_aux_A_VROLL





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
	   
   
    
      
     
      ,a.[per_MAKE]
	   ,a.[per_MAK_MOD]
      ,a.[per_BODY_TYP]
      ,a.[per_MOD_YEAR] --int
      
     
  
     
      ,a.[per_IMPACT1]
      ,a.[per_FIRE_EXP]