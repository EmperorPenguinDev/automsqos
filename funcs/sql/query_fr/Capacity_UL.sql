select 
f.CollectionName as SOURCE, 
n.CId as CID	,
n.LAC	,
n.MCC,
n.MNC	,
n.HomeOperator 	Operator ,
n.CGI	,
n.technology	Technology,
p.longitude  Lon,
p.latitude	Lat,
p.SessionId,
p.TestId,
n.NetworkId,
f.Zone SystemName,
f.ASideDevice ADevice,
p.MsgTime Time,
p.PosId,
n.FileId, 
'' as BTSLon,
'' as BTSLat,
p.longitude  BTSLonDiff	, 
p.latitude	  BTSLatDiff,
'' BTSDist	,
p.longitude  BTS2LonDiff	, 
p.latitude	  BTS2LatDiff,
	''	BTS2Dist ,
p.longitude  BTS3LonDiff	, 
p.latitude	  BTS3LatDiff,			
'' BTS3Dist	,
'' BTSTech	,
'' FloorPlanName,
'' FloorPlanLevel ,
'' SessionIdLP	,
'' TestIdLP ,
'' PosIdLP	,
'' NetworkIdLP ,
r.ErrorCode	, 
		Case When ResultsCapacityTestParameters.Direction='PUT' then 'uplink' else 'downlink' end as Direction,
		r.ThroughputPut as ULLThrpt,		
		ResultsCapacityTestParameters.URICount  ,
		Case When r.ErrorCode = 0 Then 'Success' Else 'Failed' End as Status 
 

from    NetworkInfo n    
join  "Position" p on n.MsgTime =p.MsgTime and n.FileId =p.FileId
join  FileList f on n.FileId =f.FileId 
join  ResultsCapacityTest r on p.SessionId=r.SessionId and 		r.MsgTime=p.MsgTime	
join ResultsCapacityTestParameters  ResultsCapacityTestParameters on r.TestId=ResultsCapacityTestParameters.TestId 
where ResultsCapacityTestParameters.Direction ='PUT';