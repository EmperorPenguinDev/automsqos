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
Round(Convert(float, vResultsHTTPBrowserTest.Throughput*8*0.001), 3) Throughput, 
vResultsHTTPBrowserTest.URL, 
vResultsHTTPBrowserTest.APN
FROM [vSessionsTechnologyAll] [Sessions]
JOIN FileList ON FileList.FileId = [Sessions].FileId
JOIN NetworkInfo ON Networkinfo.NetworkId = [Sessions].NetworkId
JOIN vResultsHTTPBrowserTest ON vResultsHTTPBrowserTest.SessionId = [Sessions].SessionId
JOIN [vTestInfoTechnologyAll] Testinfo ON TestInfo.TestId = vResultsHTTPBrowserTest.TestId and 
     TestInfo.valid = 1
		 AND [Sessions].Valid = 1 
 