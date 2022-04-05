select FileList.ASideFileName,
FileList.TestDescription,
FileList.CollectionName,
FileList.CampaignName,
FileList.UserName,
FileList.Zone,
FileList.CallingModule,
FileList.ASideDevice,
FileList.BSideDevice,
FileList.ASideNumber,
FileList.BSideNumber,
FileList.ASideLocation,
FileList.BSideLocation,
CallSession.JobName,
TestInfo.TestName,
Sessions.SessionId,
TestInfo.TestId,
convert(VARCHAR, TestInfo.StartTime, 104) AS 'msgDate',
convert(VARCHAR, TestInfo.StartTime, 108) AS 'msgTime',
NetworkInfo.Cid,
NetworkInfo.LAC,
NetworkInfo.Operator,
NetworkInfo.Technology,
CallSession.CallTechnology,
dbo.GetTCHTechperTest(Testinfo.TestId, Testinfo.SessionID) AS 'TCHTechnology',
infoB.CId AS 'CIDBSide',
infoB.Operator AS 'OperatorBSide',
infoB.technology AS 'TechnologyBSide',
CallSession.CallDir AS 'CallDirection',
CallSession.CallType AS 'CallType',
CallSession.MediaClient,
SampleSettingsInfo.Direction AS 'SampleDirection',
SampleSettingsInfo.RefFileName,
SampleSettingsInfo.CodedFileName,
CAST(CASE ResultsLq08Avg.Appl % 10
        WHEN 0
            THEN CASE (ResultsLq08Avg.Appl / 10) % 10
                    WHEN 0
                        THEN ResultsLq08Avg.LQNB
                    ELSE ResultsLq08Avg.OptionalNB
                    END
        WHEN 2
            THEN CASE (ResultsLq08Avg.Appl / 10) % 10
                    WHEN 0
                        THEN ResultsLq08Avg.LQWB
                    ELSE ResultsLq08Avg.OptionalWB
                    END
        END AS DECIMAL(5, 2)) AS 'MOS',
Round(ResultsLq08Avg.p862LQ, 3) AS 'P.862.1',
CASE 
    WHEN ResultsLQ08Avg.OptionalWB > 0
        THEN 'P.863-SWB'
    WHEN (ResultsLq08Avg.LQWB > 0)
        THEN 'SQuad08-WB'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'P.863-NB'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.863-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'P.863-NB/SQuad08-NB'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.863-NB/SQuad08-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'SQuad08-NB'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'SQuad08-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.862.1'
    WHEN (
            (ResultsLq08Avg.LQWB IS NULL)
            AND (ResultsLq08Avg.LQNB IS NULL)
            AND (ResultsLQ08Avg.OptionalWB IS NULL)
            AND (ResultsLQ08Avg.OptionalNB IS NULL)
            AND (ResultsLq08Avg.P862LQ IS NULL)
            AND (ResultsLq08Avg.STATUS = 'Silence')
            )
        THEN 'Silence'
    ELSE NULL
    END AS 'LQType',
ResultsLq08Avg.appl,
Round(ResultsLq08Avg.MissedVoice, 3),
Round(ResultsLq08Avg.FrontClipping, 3),
Round(ResultsLq08Avg.ReferDCOffset, 3),
Round(ResultsLq08Avg.codedDcOffset, 3),
Round(ResultsLq08Avg.posFreqShift, 3),
Round(ResultsLq08Avg.negFreqShift, 3),
Round(ResultsLq08Avg.delaySpread, 3),
Round(ResultsLq08Avg.TotalGain, 3),
Round(ResultsLq08Avg.aSLrcvP56, 3),
Round(ResultsLq08Avg.noiseRcv, 3),
Round(ResultsLq08Avg.staticSNR, 3),
CASE 
    WHEN vvct.CodecName IS NULL
        THEN 'no codec rate'
    WHEN vvct.CodecName = '-'
        THEN 'no codec rate'
    ELSE vvct.CodecName
    END AS 'CodecName',
vvct.CodecRate,
CASE 
    WHEN vvctBSide.CodecName IS NULL
        THEN 'no codec rate'
    WHEN vvctBSide.CodecName = '-'
        THEN 'no codec rate'
    ELSE vvctBSide.CodecName
    END AS 'CodecNameBSide',
vvctBSide.CodecRate,
CASE 
    WHEN ResultsLq08Avg.QualityCode <> ''
        THEN 1
    ELSE 0
    END AS 'QCode',
ResultsLq08Avg.QualityCode 
from Sessions 	Join FileList On(Sessions.FileID = FileList.FileID)
		Join TestInfo On(Sessions.SessionID = TestInfo.SessionID)
		Join CallSession On(Sessions.SessionID = CallSession.SessionID)
		Join SampleSettingsInfo On(TestInfo.SampleID = SampleSettingsInfo.SampleID)
		Join ResultsLq08Avg On(TestInfo.TestID =ResultsLq08Avg.TestID)
		Join NetworkInfo On(TestInfo.NetworkID = NetworkInfo.NetworkID)
		Left Join vVoiceCodecTest vvct On(ResultsLq08Avg.TestID = vvct.TestID and
						((TestInfo.direction='A->B'And vvct.Direction='U')or
						(TestInfo.direction='B->A'And vvct.Direction='D')))
		Left Join vVoiceCodecTestBSide vvctBSide On(ResultsLq08Avg.TestID=vvctBSide.TestID and
						((TestInfo.direction='A->B'And vvctBSide.Direction='D')or
						(TestInfo.direction='B->A'And vvctBSide.Direction='U')))
		Left Join SessionsB On(Sessions.SessionId=SessionsB.SessionIdA)
		Left Join NetworkIdRelation On(Testinfo.TestId=NetworkIdRelation.TestId and SessionsB.SessionId=NetworkIdRelation.SessionId and type='TestID')
		Left Join NetworkInfo infoB On(NetworkIdRelation.NetworkId=infoB.NetworkId)
		where Sessions.Valid = 1 And
TestInfo.Valid = 1

union 

select FileList.ASideFileName,
FileList.TestDescription,
FileList.CollectionName,
FileList.CampaignName,
FileList.UserName,
FileList.Zone,
FileList.CallingModule,
FileList.ASideDevice,
FileList.BSideDevice,
FileList.ASideNumber,
FileList.BSideNumber,
FileList.ASideLocation,
FileList.BSideLocation,
CallSession.JobName,
TestInfo.TestName,
Sessions.SessionId,
TestInfo.TestId,
convert(VARCHAR, TestInfo.StartTime, 104) AS 'msgDate',
convert(VARCHAR, TestInfo.StartTime, 108) AS 'msgTime',
NetworkInfo.Cid,
NetworkInfo.LAC,
NetworkInfo.Operator,
NetworkInfo.Technology,
CallSession.CallTechnology,
dbo.GetTCHTechperTest(Testinfo.TestId, Testinfo.SessionID) AS 'TCHTechnology',
infoB.CId AS 'CIDBSide',
infoB.Operator AS 'OperatorBSide',
infoB.technology AS 'TechnologyBSide',
CallSession.CallDir AS 'CallDirection',
CallSession.CallType AS 'CallType',
CallSession.MediaClient,
SampleSettingsInfo.Direction AS 'SampleDirection',
SampleSettingsInfo.RefFileName,
SampleSettingsInfo.CodedFileName,
CAST(CASE ResultsLq08Avg.Appl % 10
        WHEN 0
            THEN CASE (ResultsLq08Avg.Appl / 10) % 10
                    WHEN 0
                        THEN ResultsLq08Avg.LQNB
                    ELSE ResultsLq08Avg.OptionalNB
                    END
        WHEN 2
            THEN CASE (ResultsLq08Avg.Appl / 10) % 10
                    WHEN 0
                        THEN ResultsLq08Avg.LQWB
                    ELSE ResultsLq08Avg.OptionalWB
                    END
        END AS DECIMAL(5, 2)) AS 'MOS',
Round(ResultsLq08Avg.p862LQ, 3) AS 'P.862.1',
CASE 
    WHEN ResultsLQ08Avg.OptionalWB > 0
        THEN 'P.863-SWB'
    WHEN (ResultsLq08Avg.LQWB > 0)
        THEN 'SQuad08-WB'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'P.863-NB'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.863-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'P.863-NB/SQuad08-NB'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.863-NB/SQuad08-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'SQuad08-NB'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'SQuad08-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.862.1'
    WHEN (
            (ResultsLq08Avg.LQWB IS NULL)
            AND (ResultsLq08Avg.LQNB IS NULL)
            AND (ResultsLQ08Avg.OptionalWB IS NULL)
            AND (ResultsLQ08Avg.OptionalNB IS NULL)
            AND (ResultsLq08Avg.P862LQ IS NULL)
            AND (ResultsLq08Avg.STATUS = 'Silence')
            )
        THEN 'Silence'
    ELSE NULL
    END AS 'LQType',
ResultsLq08Avg.appl,
Round(ResultsLq08Avg.MissedVoice, 3),
Round(ResultsLq08Avg.FrontClipping, 3),
Round(ResultsLq08Avg.ReferDCOffset, 3),
Round(ResultsLq08Avg.codedDcOffset, 3),
Round(ResultsLq08Avg.posFreqShift, 3),
Round(ResultsLq08Avg.negFreqShift, 3),
Round(ResultsLq08Avg.delaySpread, 3),
Round(ResultsLq08Avg.TotalGain, 3),
Round(ResultsLq08Avg.aSLrcvP56, 3),
Round(ResultsLq08Avg.noiseRcv, 3),
Round(ResultsLq08Avg.staticSNR, 3),
CASE 
    WHEN vvct.CodecName IS NULL
        THEN 'no codec rate'
    WHEN vvct.CodecName = '-'
        THEN 'no codec rate'
    ELSE vvct.CodecName
    END AS 'CodecName',
vvct.CodecRate,
CASE 
    WHEN vvctBSide.CodecName IS NULL
        THEN 'no codec rate'
    WHEN vvctBSide.CodecName = '-'
        THEN 'no codec rate'
    ELSE vvctBSide.CodecName
    END AS 'CodecNameBSide',
vvctBSide.CodecRate,
CASE 
    WHEN ResultsLq08Avg.QualityCode <> ''
        THEN 1
    ELSE 0
    END AS 'QCode',
ResultsLq08Avg.QualityCode 
from Sessions 	Join FileList On(Sessions.FileID = FileList.FileID)
		Join TestInfo On(Sessions.SessionID = TestInfo.SessionID)
		Join CallSession On(Sessions.SessionID = CallSession.SessionID)
		Join SampleSettingsInfo On(TestInfo.SampleID = SampleSettingsInfo.SampleID)
		Join ResultsLq08Avg On(TestInfo.TestID =ResultsLq08Avg.TestID)
		Join NetworkInfo On(TestInfo.NetworkID = NetworkInfo.NetworkID)
		Left Join vVoiceCodecTest vvct On(ResultsLq08Avg.TestID = vvct.TestID and
						((TestInfo.direction='A->B'And vvct.Direction='U')or
						(TestInfo.direction='B->A'And vvct.Direction='D')))
		Left Join vVoiceCodecTestBSide vvctBSide On(ResultsLq08Avg.TestID=vvctBSide.TestID and
						((TestInfo.direction='A->B'And vvctBSide.Direction='D')or
						(TestInfo.direction='B->A'And vvctBSide.Direction='U')))
		Left Join SessionsB On(Sessions.SessionId=SessionsB.SessionIdA)
		Left Join NetworkIdRelation On(Testinfo.TestId=NetworkIdRelation.TestId and SessionsB.SessionId=NetworkIdRelation.SessionId and type='TestID')
		Left Join NetworkInfo infoB On(NetworkIdRelation.NetworkId=infoB.NetworkId)
		where Sessions.Valid = 1 And
TestInfo.Valid = 1 

union 

select FileList.ASideFileName,
FileList.TestDescription,
FileList.CollectionName,
FileList.CampaignName,
FileList.UserName,
FileList.Zone,
FileList.CallingModule,
FileList.ASideDevice,
FileList.BSideDevice,
FileList.ASideNumber,
FileList.BSideNumber,
FileList.ASideLocation,
FileList.BSideLocation,
CallSession.JobName,
TestInfo.TestName,
Sessions.SessionId,
TestInfo.TestId,
convert(VARCHAR, TestInfo.StartTime, 104) AS 'msgDate',
convert(VARCHAR, TestInfo.StartTime, 108) AS 'msgTime',
NetworkInfo.Cid,
NetworkInfo.LAC,
NetworkInfo.Operator,
NetworkInfo.Technology,
CallSession.CallTechnology,
dbo.GetTCHTechperTest(Testinfo.TestId, Testinfo.SessionID) AS 'TCHTechnology',
infoB.CId AS 'CIDBSide',
infoB.Operator AS 'OperatorBSide',
infoB.technology AS 'TechnologyBSide',
CallSession.CallDir AS 'CallDirection',
CallSession.CallType AS 'CallType',
CallSession.MediaClient,
SampleSettingsInfo.Direction AS 'SampleDirection',
SampleSettingsInfo.RefFileName,
SampleSettingsInfo.CodedFileName,
CAST(CASE ResultsLq08Avg.Appl % 10
        WHEN 0
            THEN CASE (ResultsLq08Avg.Appl / 10) % 10
                    WHEN 0
                        THEN ResultsLq08Avg.LQNB
                    ELSE ResultsLq08Avg.OptionalNB
                    END
        WHEN 2
            THEN CASE (ResultsLq08Avg.Appl / 10) % 10
                    WHEN 0
                        THEN ResultsLq08Avg.LQWB
                    ELSE ResultsLq08Avg.OptionalWB
                    END
        END AS DECIMAL(5, 2)) AS 'MOS',
Round(ResultsLq08Avg.p862LQ, 3) AS 'P.862.1',
CASE 
    WHEN ResultsLQ08Avg.OptionalWB > 0
        THEN 'P.863-SWB'
    WHEN (ResultsLq08Avg.LQWB > 0)
        THEN 'SQuad08-WB'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'P.863-NB'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.863-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'P.863-NB/SQuad08-NB'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB > 0)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.863-NB/SQuad08-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ IS NULL)
        THEN 'SQuad08-NB'
    WHEN (ResultsLQ08Avg.LQNB > 0)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'SQuad08-NB/P.862.1'
    WHEN (ResultsLQ08Avg.LQNB IS NULL)
        AND (ResultsLQ08Avg.OptionalNB IS NULL)
        AND (ResultsLQ08Avg.P862LQ > 0)
        THEN 'P.862.1'
    WHEN (
            (ResultsLq08Avg.LQWB IS NULL)
            AND (ResultsLq08Avg.LQNB IS NULL)
            AND (ResultsLQ08Avg.OptionalWB IS NULL)
            AND (ResultsLQ08Avg.OptionalNB IS NULL)
            AND (ResultsLq08Avg.P862LQ IS NULL)
            AND (ResultsLq08Avg.STATUS = 'Silence')
            )
        THEN 'Silence'
    ELSE NULL
    END AS 'LQType',
ResultsLq08Avg.appl,
Round(ResultsLq08Avg.MissedVoice, 3),
Round(ResultsLq08Avg.FrontClipping, 3),
Round(ResultsLq08Avg.ReferDCOffset, 3),
Round(ResultsLq08Avg.codedDcOffset, 3),
Round(ResultsLq08Avg.posFreqShift, 3),
Round(ResultsLq08Avg.negFreqShift, 3),
Round(ResultsLq08Avg.delaySpread, 3),
Round(ResultsLq08Avg.TotalGain, 3),
Round(ResultsLq08Avg.aSLrcvP56, 3),
Round(ResultsLq08Avg.noiseRcv, 3),
Round(ResultsLq08Avg.staticSNR, 3),
CASE 
    WHEN vvct.CodecName IS NULL
        THEN 'no codec rate'
    WHEN vvct.CodecName = '-'
        THEN 'no codec rate'
    ELSE vvct.CodecName
    END AS 'CodecName',
vvct.CodecRate,
CASE 
    WHEN vvctBSide.CodecName IS NULL
        THEN 'no codec rate'
    WHEN vvctBSide.CodecName = '-'
        THEN 'no codec rate'
    ELSE vvctBSide.CodecName
    END AS 'CodecNameBSide',
vvctBSide.CodecRate,
CASE 
    WHEN ResultsLq08Avg.QualityCode <> ''
        THEN 1
    ELSE 0
    END AS 'QCode',
ResultsLq08Avg.QualityCode
from Sessions 	Join FileList On(Sessions.FileID = FileList.FileID)
		Join TestInfo On(Sessions.SessionID = TestInfo.SessionID)
		Join CallSession On(Sessions.SessionID = CallSession.SessionID)
		Join SampleSettingsInfo On(TestInfo.SampleID = SampleSettingsInfo.SampleID)
		Join ResultsLq08Avg On(TestInfo.TestID =ResultsLq08Avg.TestID)
		Join NetworkInfo On(TestInfo.NetworkID = NetworkInfo.NetworkID)
		Left Join vVoiceCodecTest vvct On(ResultsLq08Avg.TestID = vvct.TestID and
						((TestInfo.direction='A->B'And vvct.Direction='U')or
						(TestInfo.direction='B->A'And vvct.Direction='D')))
		Left Join vVoiceCodecTestBSide vvctBSide On(ResultsLq08Avg.TestID=vvctBSide.TestID and
						((TestInfo.direction='A->B'And vvctBSide.Direction='D')or
						(TestInfo.direction='B->A'And vvctBSide.Direction='U')))
		Left Join SessionsB On(Sessions.SessionId=SessionsB.SessionIdA)
		Left Join NetworkIdRelation On(Testinfo.TestId=NetworkIdRelation.TestId and SessionsB.SessionId=NetworkIdRelation.SessionId and type='TestID')
		Left Join NetworkInfo infoB On(NetworkIdRelation.NetworkId=infoB.NetworkId)
		where Sessions.Valid = 1 And
TestInfo.Valid = 1 