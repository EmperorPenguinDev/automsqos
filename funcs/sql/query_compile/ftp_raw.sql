SELECT 
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
Round(Convert(float, vResultsFTPTestGetFD.Throughput*8*0.001), 3) Throughput, 
'GET' as ket,
vResultsFTPTestGetFD.Host,
  vResultsFTPTestGetFD.Status,
vResultsFTPTestGetFD.APN 
FROM [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsFTPTestGetFD ON vResultsFTPTestGetFD.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsFTPTestGetFD.TestId and 
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
Round(Convert(float, vResultsFTPTestPutFD.Throughput*8*0.001), 3) Throughput, 
'PUT' as ket,
vResultsFTPTestPutFD.Host,
  vResultsFTPTestPutFD.Status,
vResultsFTPTestPutFD.APN 
FROM [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsFTPTestPutFD ON vResultsFTPTestPutFD.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsFTPTestPutFD.TestId and 
     TestInfo.valid = 1 AND [Sessions].Valid = 1 
		 
 union 
 select Sessions.SessionId, 
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
Round(Convert(float, vResultsFTPTestGet.Throughput*8*0.001), 3) Throughput, 
'GET' as ket,
vResultsFTPTestGet.Host,
        vResultsFTPTestGet.Status,
vResultsFTPTestGet.APN 
from [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsFTPTestGet ON vResultsFTPTestGet.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsFTPTestGet.TestId and 
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
Round(Convert(float, vResultsFTPTestPut.Throughput*8*0.001), 3) Throughput, 
'PUT' as ket,
vResultsFTPTestPut.Host,
vResultsFTPTestPut.Status,
vResultsFTPTestPut.APN
from [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsFTPTestPut ON vResultsFTPTestPut.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsFTPTestPut.TestId and 
     TestInfo.valid = 1 and [Sessions].Valid = 1 
 
