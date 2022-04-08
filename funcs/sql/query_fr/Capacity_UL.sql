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
w.ErrorCode	, 
Case When t.Direction='PUT' then 'uplink' else 'downlink' end as Direction,
convert(float,w.ThroughputPut) as ULThrpt,
t.URICount  ,
Case When w.ErrorCode = 0 Then 'Success' Else 'Failed' End as Status 

from    ResultsCapacityTest w  
left  join  NetworkInfo n    on  w.NetworkId=n.NetworkId 
left  join   "Position" p  on w.PosId =p.PosId 
left  join   FileList f on n.FileId =f.FileId 
left  join  ResultsCapacityTestParameters  t on w.TestId=t.TestId 
where t.Direction ='PUT';
