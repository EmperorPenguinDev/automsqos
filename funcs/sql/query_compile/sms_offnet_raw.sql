select [Sessions].[SessionId], 
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
Round(Convert(float, vSMSE2E.Duration/1000), 3)
from [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vSMSE2E ON vSMSE2E.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vSMSE2E.TestId and 
     TestInfo.valid = 1
		 and [Sessions].Valid = 1
 union 
 
 select [Sessions].[SessionId], 
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
Round(Convert(float, vResultsKPI.Duration*0.001), 3)
from [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsKPI ON vResultsKPI.SessionId = [Sessions].SessionId and vResultsKPI.KPIID = 10900
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsKPI.TestId and 
     TestInfo.valid = 1
		 and [Sessions].Valid = 1 
 union 
 
 select [Sessions].[SessionId], 
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
Round(Convert(float, vResultsKPI.Duration*0.001), 3)
from [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsKPI ON vResultsKPI.SessionId = [Sessions].SessionId and vResultsKPI.KPIID = 20900
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsKPI.TestId and 
     TestInfo.valid = 1 and [Sessions].Valid = 1 