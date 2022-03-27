select   TOP 10
n.CId as CID	,
n.LAC	,
n.MCC,
n.MNC	,
n.Operator	 ,
n.CGI	,
n.technology	Technology,
p.longitude  Lon,
p.latitude	Lat,
l.SessionId,
l.TestId,
l.NetworkId,
f.Zone SystemName,
f.ASideDevice ADevice,
l.MsgTime Time,
l.PosId,
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
'' NetworkIdLP, 

		--l.EARFCN,
	--	l.PhyCellId as PCI,
		Str(Round(l.RSRP,1),10,1)as RSRP,
		--Str(Round(l.RSRQ,1),10,1)as RSRQ,
		--Str(Round(l.RSSI,1),10,1)as RSSI,
		--Str(Round(l.SINR0,1),10,1)as SINR0,
		--Str(Round(l.SINR1,1),10,1)as SINR1,
		--Str(Round((l.SINR0 + l.SINR1)/2,1),10,1)as SINR,
		l.NumMeasuredCells,
		Convert(varchar,l.EARFCN) + ' ' + Convert(varchar,l.PhyCellId) as ChnPCI
		



from LTEMeasurementReport l 
 join  NetworkInfo n on  l.NetworkId=n.NetworkId  and l.MsgTime =n.MsgTime   
join  "Position" p on l.MsgTime =p.MsgTime and l.SessionId =p.SessionId and l.PosId =p.PosId
join  FileList f on n.FileId =f.FileId  
