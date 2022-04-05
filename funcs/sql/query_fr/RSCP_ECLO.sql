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
Str(Round(w.AggrRSCP,1),10,1)as AvgRSCP, 
Str(Round(w.AggrEcIo,1),10,1)as AvgEcIo,
w.numCells,
Convert(varchar,w.FreqDL) + ' ' + Convert(varchar,w.PrimScCode) as ChPSC

from    NetworkInfo n    
join  "Position" p on n.MsgTime =p.MsgTime and n.FileId =p.FileId
join  FileList f on n.FileId =f.FileId 
join  WCDMAActiveSet  w on  n.NetworkId=w.NetworkId and p.SessionId=w.SessionId	and  p.MsgTime=w.MsgTime 
 
; 