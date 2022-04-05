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
Str(Round(w.RxLev,1),10,1)as RxLev,
Str(Round(w.RxQual,1),10,1)as RxQual,  
Convert(varchar,w.BCCH) as ChNr
from    NetworkInfo n    
join  "Position" p on n.MsgTime =p.MsgTime and n.FileId =p.FileId
join  FileList f on n.FileId =f.FileId 
join  FactGSMRadio  w on  n.NetworkId=w.NetworkId and p.SessionId=w.SessionId	and p.MsgTime=w.FullDate 
; 