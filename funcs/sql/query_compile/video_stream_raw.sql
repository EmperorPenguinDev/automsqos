with #Sessions( FileId,SessionId, TestId) as (
select

Sessions.FileId,
Sessions.SessionId,
Testinfo.TestId
from
Sessions Join Testinfo On(Sessions.SessionId=Testinfo.SessionId)
where Sessions.Valid=1 And
TestInfo.Valid=1 And
Sessions.jtId in (4,5,7)
group by  Sessions.FileId,
Sessions.SessionId,
Testinfo.TestId)
, #MsgEtherealVideoServer(Sessionid,Testid,VideoServer) as (

Select
MsgEthereal.Sessionid,
MsgEthereal.Testid,
MsgEthereal.dst as 'VideoServer'
From
#Sessions Join MsgEthereal On(#Sessions.TestId=MsgEthereal.TestId)
where-- msg like 'GET /videoplayback%' and
      MsgId = (Select Max(MsgId) from MsgEthereal m2
               where --m2.msg like 'GET /videoplayback%' and
               m2.TestId = MsgEthereal.TestId)
Group by
MsgEthereal.Sessionid,
MsgEthereal.Testid,
MsgEthereal.dst

)
Select
FileList.ASideFileName,
FileList.TestDescription,
FileList.CollectionName,
FileList.CampaignName,
FileList.UserName,
FileList.CallingModule,
FileList.ASideDevice,
FileList.ASideNumber,
FileList.ASideLocation,
FileList.Region,
DataSession.JobName,
TestInfo.TestName,
#Sessions.SessionId,
TestInfo.TestId,
TestInfo.StartTime as MsgDateTime,
convert(varchar,TestInfo.StartTime,104) as 'Date',
convert(varchar,TestInfo.StartTime,108) as 'Time',
Testinfo.typeoftest as 'Test Type',
Case When TestInfo.typeoftest like '%YouTube%' Then 'YouTube' Else 'MediaServer' end as 'Source',
NetworkInfo.Cid,
NetworkInfo.LAC,
NetworkInfo.Operator,
NetworkInfo.Technology,
ResultsVideoStream.Player,
ResultsVideoStream.URL,
ResultsVideoStream.VideoResolution,
Convert(varchar,ResultsVideoStream.HorResolution)+' * '+Convert(varchar,ResultsVideoStream.VerResolution) as 'DisplayResolution',
ResultsVideoStreamTCPData.Container,
#MsgEtherealVideoServer.VideoServer,
vResultsVideoStreamAvg.Model as 'VQ Series',
vResultsVideoStreamAvg.SessionQuality,
vResultsVideoStreamAvg.TestQualityAvg,
vResultsVideoStreamAvg.TestQualityMin,
vResultsVideoStreamAvg.TestQualityMax,
vResultsVideoStreamAvg.Freezing,
vResultsVideoStreamAvg.FreezingPercent*0.01,
case ResultsVideoStream.State when 'Completed' then 'ok' else ResultsVideoStream.State end as Status,
Case when ResultsVideoStream.State = 'Completed' then 1 else 0 end as 'StatusOk',
Case when ResultsVideoStream.State = 'Completed' then 0 else 1 end as 'StatusFailed',
case when ResultsVideoStreamTCPData.TimeToFirstPicture is not NULL then ResultsVideoStreamTCPData.TimeToFirstPicture*0.001 else ResultsVideoStreamTCPData.TimeToFirstPicturePlayer *0.001 end,
ResultsVQ08StreamAvg.Jerkiness,
ResultsVQ08StreamAvg.Blurring,
ResultsVQ08StreamAvg.Tiling

From
#Sessions	Join	Filelist On(#Sessions.FileID=FileList.FileID)
		Join	Testinfo On(#Sessions.TestId=Testinfo.TestId)
		Join	NetworkInfo On(Testinfo.NetworkId=NetworkInfo.NetworkId)
		Join	vResultsVideoStreamAvg On(Testinfo.TestId=vResultsVideoStreamAvg.TestId)
		Join	ResultsVQ08StreamAvg On(Testinfo.TestId=ResultsVQ08StreamAvg.TestId)
		Join	ResultsVideoStream On(Testinfo.TestId=ResultsVideoStream.TestId)
		Join	DataSession On(#Sessions.SessionId=DataSession.SessionID)
		Left Join	ResultsVideoStreamTCPData On(Testinfo.TestId=ResultsVideoStreamTCPData.TestId)
		Left Join	#MsgEtherealVideoServer On(Testinfo.TestId=#MsgEtherealVideoServer.TestId)

