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
Round(Convert(float, AppVideoAccessDuration*1.0), 3)  as AppVideoAccessDuration,
FactVideoStreaming.Player as url
from [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN FactVideoStreaming ON FactVideoStreaming.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = FactVideoStreaming.TestId 
where      TestInfo.valid = 1 		 and [Sessions].Valid = 1 
		 and setup='URL' 