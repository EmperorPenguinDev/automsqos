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
Round(Convert(float, vResultsCapacityTestPut.Throughput*0.008), 3), 
vResultsCapacityTestPut.Host,
 vResultsCapacityTestPut.Status ,
vResultsCapacityTestPut.URICount 
FROM [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsCapacityTestPut ON vResultsCapacityTestPut.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsCapacityTestPut.TestId and 
     TestInfo.valid = 1
		 AND [Sessions].Valid = 1 
		 
UNION 
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
Round(Convert(float, vResultsCapacityTestGet.Throughput*0.008), 3), 
vResultsCapacityTestGet.Host,
  vResultsCapacityTestGet.Status ,
vResultsCapacityTestGet.URICount 
FROM [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsCapacityTestGet ON vResultsCapacityTestGet.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsCapacityTestGet.TestId and 
     TestInfo.valid = 1 AND [Sessions].Valid = 1 
		 
 UNION 
 
 

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
Round(Convert(float, vResultsCapacityTestGet.Throughput*0.008), 3), 
vResultsCapacityTestGet.Host,
  vResultsCapacityTestGet.Status ,
vResultsCapacityTestGet.URICount 
FROM [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsCapacityTestGet ON vResultsCapacityTestGet.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsCapacityTestGet.TestId and 
     TestInfo.valid = 1 AND [Sessions].Valid = 1 