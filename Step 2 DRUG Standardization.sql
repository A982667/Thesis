/****** Script for SelectTopNRows command from SSMS  ******/
-------------------------------------------------------------------------
--Purpose: Prep DRUG data where data schema changed between 2017 and 2018
--Author: Amy McNamara
--Date: 2020-01-18
-------------------------------------------------------------------------
-------------------------------------------------------------------------
--STEP 1 Standardize to 3 values, the DRUGTST in 2017 file
-- values are 0 test not given, 1 test given and -1 unknown, not reported
--Create temp table #Drug_2017_1
-------------------------------------------------------------------------
drop table if exists #Drug_2017_1

select '2017' as YEAR
, st_case
, veh_no
, per_no
, CASE WHEN DRUGTST1=0
	THEN 0
	WHEN DRUGTST1 in (6,9)
	THEN -1
	ELSE 1
	END as DRUGTST1
, CASE WHEN DRUGTST2=0
	THEN 0
	WHEN DRUGTST2 in (6,9)
	THEN -1
	ELSE 1
	END as DRUGTST2
, CASE WHEN DRUGTST3=0
	THEN 0
	WHEN DRUGTST3 in (6,9)
	THEN -1
	ELSE 1
	END as DRUGTST3
into #Drug_2017_1
from dbo.raw_person_2017
--85,840

-------------------------------------------------------------------------
--STEP 2 Take max of standardized to values for above
-- values are 0 test not given, 1 test given and -1 unknown, not reported
--Create temp table #Drug_2017_2
-------------------------------------------------------------------------
drop table if exists #Drug_2017_2
select [YEAR]
, st_case
, veh_no
, per_no
, max(CASE WHEN DRUGTST1=1
	OR DRUGTST2=1
	OR DRUGTST3=1
	THEN 1
	WHEN DRUGTST1=0
	OR DRUGTST2=0
	OR DRUGTST3=0
	THEN 0
	ELSE -1
	END) as DRUGTST
into #Drug_2017_2
from #Drug_2017_1
group by [YEAR]
, st_case
,veh_no
,per_no
--85,840

-------------------------------------------------------------------------
--STEP 3 Standardize to 3 values, the DRUGTST in 2018 file
-- values are 0 test not given, 1 test given and -1 unknown, not reported
--Create temp table #Drug_2018_1
-------------------------------------------------------------------------

drop table if exists #Drug_2018_1

select '2018' as YEAR
,st_case
,veh_no
,per_no
,max(CASE WHEN DRUGSPEC=0
	THEN 0
	WHEN DRUGSPEC in (6,9)
	THEN -1
	ELSE 1
	END) as DRUGTST
,max(CASE WHEN DRUGRES=0
	THEN 1
	ELSE 0
	END) as 'Drugs_Not_Tested'
, max(CASE WHEN DRUGRES=1
	THEN 1
	ELSE 0
	END) as 'Drugs_Negative'
, max(CASE WHEN DRUGRES=95
	THEN 1
	ELSE 0
	END) as 'Drugs_Not_Reported'
, max(CASE WHEN DRUGRES=996
	THEN 1
	ELSE 0
	END) as 'Drugs_Other'
, max(CASE WHEN DRUGRES=997
	THEN 1
	ELSE 0
	END) as 'Drugs_Tested_Result_Unknown'
, max(CASE WHEN DRUGRES=998
	THEN 1
	ELSE 0
	END) as 'Drugs_Tested_Positive_Unknown_Type'
, max(CASE WHEN DRUGRES=999
	THEN 1
	ELSE 0
	END) as 'Drugs_Unknown_if_tested'
, max(CASE WHEN DRUGRES between 100 and 295
	THEN 1
	ELSE 0
	END) as 'Drugs_Narcotic'
, max(CASE WHEN DRUGRES between 300 and 395
	THEN 1
	ELSE 0
	END) as 'Drugs_Depressant'
, max(CASE WHEN DRUGRES between 400 and 495
	THEN 1
	ELSE 0
	END) as 'Drugs_Stimulant'
, max(CASE WHEN DRUGRES between 500 and 595
	THEN 1
	ELSE 0
	END) as 'Drugs_Hallucinogen'
, max(CASE WHEN DRUGRES between 600 and 695
	THEN 1
	ELSE 0
	END) as 'Drugs_Cannabinoid'
, max(CASE WHEN DRUGRES between 700 and 795
	THEN 1
	ELSE 0
	END) as 'Drugs_Phencyclidine(PCP)'
, max(CASE WHEN DRUGRES between 800 and 895
	THEN 1
	ELSE 0
	END) as 'Drugs_Anabolic Steroid'
, max(CASE WHEN DRUGRES between 900 and 959
	THEN 1
	ELSE 0
	END) as 'Drugs_Inhalant'
into #Drug_2018_1
from dbo.raw_drugs_2018
group by st_case
,veh_no
,per_no
--83,626

-------------------------------------------------------------------------
--STEP 4 Flatten the DRUGRES in 2017 file
--Create temp table #Drug_2017_3
-------------------------------------------------------------------------
drop table if exists #Drug_2017_3

select a.YEAR
, a.st_case
, a.veh_no
, a.per_no
, a.DRUGTST
,max(CASE WHEN b.DRUGRES1=0
	or b.DRUGRES2=0
	or b.DRUGRES3=0
	THEN 1
	ELSE 0
	END) as 'Drugs_Not_Tested'
, max(CASE WHEN b.DRUGRES1=1
	or b.DRUGRES2=1
	or b.DRUGRES3=1
	THEN 1
	ELSE 0
	END) as 'Drugs_Negative'
, max(CASE WHEN b.DRUGRES1=95
	or b.DRUGRES2=95
	or b.DRUGRES3=95
	THEN 1
	ELSE 0
	END) as 'Drugs_Not_Reported'
, max(CASE WHEN b.DRUGRES1=996
	or b.DRUGRES2=996
	or b.DRUGRES3=996
	THEN 1
	ELSE 0
	END) as 'Drugs_Other'
, max(CASE WHEN b.DRUGRES1=997
	or b.DRUGRES2=997
	or b.DRUGRES3=997
	THEN 1
	ELSE 0
	END) as 'Drugs_Tested_Result_Unknown'
, max(CASE WHEN b.DRUGRES1=998
	or b.DRUGRES2=998
	or b.DRUGRES3=998
	THEN 1
	ELSE 0
	END) as 'Drugs_Tested_Positive_Unknown_Type'
, max(CASE WHEN b.DRUGRES1=999
	or b.DRUGRES2=999
	or b.DRUGRES3=999
	THEN 1
	ELSE 0
	END) as 'Drugs_Unknown_if_tested'
, max(CASE WHEN b.DRUGRES1 between 100 and 295
	or b.DRUGRES2 between 100 and 295
	or b.DRUGRES3 between 100 and 295
	THEN 1
	ELSE 0
	END) as 'Drugs_Narcotic'
, max(CASE WHEN b.DRUGRES1 between 300 and 395
	or b.DRUGRES2 between 300 and 395
	or b.DRUGRES3 between 300 and 395
	THEN 1
	ELSE 0
	END) as 'Drugs_Depressant'
, max(CASE WHEN b.DRUGRES1 between 400 and 495
	or b.DRUGRES2 between 400 and 495
	or b.DRUGRES3 between 400 and 495
	THEN 1
	ELSE 0
	END) as 'Drugs_Stimulant'
, max(CASE WHEN b.DRUGRES1 between 500 and 595
	or b.DRUGRES2 between 500 and 595
	or b.DRUGRES3 between 500 and 595
	THEN 1
	ELSE 0
	END) as 'Drugs_Hallucinogen'
, max(CASE WHEN b.DRUGRES1 between 600 and 695
	or b.DRUGRES2 between 600 and 695
	or b.DRUGRES3 between 600 and 695
	THEN 1
	ELSE 0
	END) as 'Drugs_Cannabinoid'
, max(CASE WHEN b.DRUGRES1 between 700 and 795
	or b.DRUGRES2 between 700 and 795
	or b.DRUGRES3 between 700 and 795
	THEN 1
	ELSE 0
	END) as 'Drugs_Phencyclidine(PCP)'
, max(CASE WHEN b.DRUGRES1 between 800 and 895
	or b.DRUGRES2 between 800 and 895
	or b.DRUGRES3 between 800 and 895
	THEN 1
	ELSE 0
	END) as 'Drugs_Anabolic Steroid'
, max(CASE WHEN b.DRUGRES1 between 900 and 959
	or b.DRUGRES2 between 900 and 995
	or b.DRUGRES3 between 900 and 995
	THEN 1
	ELSE 0
	END) as 'Drugs_Inhalant'
into #Drug_2017_3
from #Drug_2017_2 a
left join dbo.raw_person_2017 b
on a.st_case=b.st_case
and a.veh_no=b.veh_no
and a.per_no=b.per_no
group by a.year 
, a.st_case
, a.veh_no
, a.per_no
, a.DRUGTST
--85,840

-------------------------------------------------------------------------
--STEP 5 Combine 2017 and 2018 raw_drugs
--Create new Table raw_acc_aux
-------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[raw_drugs]') 
AND type in (N'U'))
BEGIN
      DROP TABLE [dbo].[raw_drugs]
END

select * into [dbo].[raw_drugs]
from 
	(select a.*
	from #Drug_2017_3 a

	union

	select a.*
	from #Drug_2018_1 a) as combined
--169,466
