
select 
[Sessions].[SessionId], 
TestInfo.TestId, 
NetworkInfo.Operator as 'Serving Operator', 
NetworkInfo.HomeOperator as 'Home Operator', 
TestInfo.Technology, 
FileList.CallingModule, 
FileList.ASideDevice, 
Convert(varchar, TestInfo.StartTime, 104) as 'msgDate', 
Convert(varchar, TestInfo.StartTime, 108) as 'msgTime', 
FileList.CollectionName, 
FileList.TestDescription, 
FileList.Zone, 
Round(Convert(float, vResultsKPI.Duration*0.001), 3) as Duration,
  vResultsKPI.KPIStatus
from [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsKPI ON vResultsKPI.SessionId = [Sessions].SessionId and vResultsKPI.KPIID = 20910
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsKPI.TestId and 
     TestInfo.valid = 1 
		 and [Sessions].Valid = 1 

union 
SELECT [Sessions].[SessionId], 
TestInfo.TestId, 
NetworkInfo.Operator as 'Serving Operator', 
NetworkInfo.HomeOperator as 'Home Operator', 
TestInfo.Technology, 
FileList.CallingModule, 
FileList.ASideDevice, 
Convert(varchar, TestInfo.StartTime, 104) as 'msgDate', 
Convert(varchar, TestInfo.StartTime, 108) as 'msgTime', 
FileList.CollectionName, 
FileList.TestDescription, 
FileList.Zone, 
Round(Convert(float, vResultsKPI.Duration*0.001), 3) as Duration,
  vResultsKPI.KPIStatus
FROM [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsKPI ON vResultsKPI.SessionId = [Sessions].SessionId and vResultsKPI.KPIID = 30911
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsKPI.TestId and 
     TestInfo.valid = 1 AND [Sessions].Valid = 1 