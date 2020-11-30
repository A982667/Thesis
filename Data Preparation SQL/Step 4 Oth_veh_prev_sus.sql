-------------------------------------------------------------------------
--Purpose: Prep OTH_VEH_PREV_SUS data where data schema changed between 2017 and 2018
--Author: Amy McNamara
--Date: 2020-01-19
-------------------------------------------------------------------------
drop table if exists #Oth_Veh_Prev_Sus_2018_1

select a.year
, a.st_case
, sum ((CASE WHEN a.prev_sus1<=97
	THEN a.prev_sus1
	ELSE 0
	END)
	+ (CASE WHEN a.prev_sus2<=97
		THEN a.prev_sus2
		ELSE 0
		END)
	+ (CASE WHEN a.prev_sus3<=97
		THEN a.prev_sus3
		ELSE 0
		END)) as oth_veh_prev_sus
into #Oth_Veh_Prev_Sus_2018_1
from dbo.raw_vehicle_2018 a
left join dbo.raw_veh_aux_2018 b
on a.ST_CASE=b.ST_CASE
and a.VEH_NO=b.VEH_NO
where
--b.A_BODY in (1,2,3,4,5,6,7)
--and 
b.VEH_NO<>0
group by a.year
,a.ST_CASE
--33,654

--View results
--select * from #Oth_Veh_Prev_Sus_2018_1

-------------------------------------------------------------------------
--STEP 2 Create temp table with prev_sus from in 2017 file
--Create temp table #Oth_Veh_Prev_Sus_2017_1
-------------------------------------------------------------------------
drop table if exists #Oth_Veh_Prev_Sus_2017_1

select a.year
,a.st_case
,sum(CASE WHEN a.prev_sus<=97
	THEN a.prev_sus
	WHEN a.prev_sus>98
	THEN -1
	ELSE 0
	END) as oth_veh_prev_sus
into #Oth_Veh_Prev_Sus_2017_1
from dbo.raw_vehicle_2017 a
left join dbo.raw_veh_aux_2017 b
on a.ST_CASE=b.ST_CASE
and a.VEH_NO=b.VEH_NO
where 
--b.A_BODY in (1,2,3,4,5,6,7)
--and 
b.VEH_NO<>0
group by a.year
, a.st_case
--34,560

--View results
--select * from #Oth_Veh_Prev_Sus_2017_1

-------------------------------------------------------------------------
--STEP 3  Create table from above 2 temp tables to combine 2017 and 2018 prev_sus
--Create table raw_prev_sus
-------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_oth_veh_prev_sus]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_oth_veh_prev_sus]
END

select * into [dbo].[raw_oth_veh_prev_sus]
from 
	(select a.*
	from #Oth_Veh_Prev_Sus_2017_1 a

	union

	select a.*
	from #Oth_Veh_Prev_Sus_2018_1 a) as combined
--68,214
