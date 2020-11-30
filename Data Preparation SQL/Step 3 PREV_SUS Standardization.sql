-------------------------------------------------------------------------
--Purpose: Prep PREV_SUS data where data schema changed between 2017 and 2018
--Author: Amy McNamara
--Date: 2020-01-18
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--STEP 1 Sum the number of previous suspensions across PREV_SUS1, PREV_SUS2, and PREV_SUS3 in 2018 file
--Create temp table #Prev_Sus_2018_1
-------------------------------------------------------------------------
drop table if exists #Prev_Sus_2018_1

select year
, st_case
, veh_no
, sum ((CASE WHEN prev_sus1<=97
	THEN prev_sus1
	ELSE 0
	END)
	+ (CASE WHEN prev_sus2<=97
		THEN prev_sus2
		ELSE 0
		END)
	+ (CASE WHEN prev_sus3<=97
		THEN prev_sus3
		ELSE 0
		END)) as prev_sus
, max(CASE WHEN prev_sus1=99
	or prev_sus1=998
	or prev_sus2=99
	or prev_sus2=998
	or prev_sus3=99
	or prev_sus3=998
	THEN -1
	ELSE 0
	END) as prev_sus_na
into #Prev_Sus_2018_1
from dbo.raw_vehicle_2018
group by year
, st_case
, veh_no
--51,872

--View results
--select * from #Prev_Sus_2018_1

-------------------------------------------------------------------------
--STEP 2 Create temp table to combine both prev_sus fields
--Create temp table #Prev_Sus_2018_2
-------------------------------------------------------------------------
drop table if exists #Prev_Sus_2018_2

select a.YEAR
,a.ST_CASE
,a.VEH_NO
,CASE WHEN a.prev_sus>0
	THEN a.prev_sus
	WHEN a.prev_sus_na=-1
	THEN -1
	ELSE 0
	END as prev_sus
into #Prev_Sus_2018_2
from #Prev_Sus_2018_1 a

--View results
--select * from #Prev_Sus_2018_2

-------------------------------------------------------------------------
--STEP 3 Create temp table with prev-sus from in 2017 file
--Create temp table #Prev_Sus_2017_1
-------------------------------------------------------------------------
drop table if exists #Prev_Sus_2017_1

select year
,st_case
,veh_no
,CASE WHEN prev_sus<=97
	THEN prev_sus
	WHEN prev_sus>98
	THEN -1
	ELSE 0
	END as prev_sus
into #Prev_Sus_2017_1
from dbo.raw_vehicle_2017
--53,128


-------------------------------------------------------------------------
--STEP 3 Create table from above 2 temp tables to combine 2017 and 2018 prev_sus
--Create table raw_prev_sus
-------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_prev_sus]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_prev_sus]
END

select * into [dbo].[raw_prev_sus]
from 
	(select a.*
	from #Prev_Sus_2017_1 a

	union

	select a.*
	from #Prev_Sus_2018_2 a) as combined
--105,000

