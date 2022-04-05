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
w.throughput, 
case when w.errorCode=0 then 'Successful' else 'Connecting failed' end  as errorcode	,
w.host,
w.operation,
SUBSTRING(w.fileName, 1, 5 ) as filename 

from    NetworkInfo n    
join  "Position" p on n.MsgTime =p.MsgTime and n.FileId =p.FileId
join  FileList f on n.FileId =f.FileId 
join  ResultsFTPtest  w on  n.NetworkId=w.NetworkId 
where w.operation='GET' and SUBSTRING(w.fileName, 1, 5 ) like '%MB'
; 