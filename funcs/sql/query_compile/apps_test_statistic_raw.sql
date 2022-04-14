with #Sessions  (SessionId, FileId, info) as ( 
SELECT SessionId, FileId, info from Sessions where valid = 1)
, #MinDur(MinDuration,TestId, SessionId, FileId) AS (  
				SELECT   COALESCE(MIN(k1.Duration),  MIN(k2.Duration), MIN(k3.Duration), 100) MinDuration,
				raam.TestId,
				raam.SessionId,
				s.FileId
				FROM #Sessions s
				INNER JOIN ResultsAppActionMessaging raam on raam.SessionId = s.SessionId
					 LEFT OUTER JOIN ResultsKPI k1 ON k1.SessionId = s.SessionId -- KPI in same Test
												AND k1.KPIId = 31000
												AND k1.TestId = raam.TestId
					 LEFT OUTER JOIN  ResultsKPI k2 ON k2.SessionId = raam.SessionId --- KPI in same Session 
										   AND k2.KPIId = 31000
					 LEFT OUTER JOIN Sessions sss ON sss.FileId = s.FileId -- KPI in same File
					 INNER JOIN ResultsKPI k3 ON k3.SessionId = sss.SessionId
										   AND k3.KPIId = 31000
										   AND k3.SessionId = sss.SessionId
				GROUP BY raam.TestId, raam.SessionId, s.FileId
				--order by raam.TestId, raam.SessionId, s.FileId
				)
, #MinDelDur (MinDeliveryTime,FileId ) AS (
 SELECT    ISNULL(MIN(DATEDIFF(ms, aab.StartTime, aa.LogTime)), 0) MinDeliveryTime,
				s.FileId
				FROM ResultsAppActionMessaging aa
					 LEFT JOIN ResultsAppActionMessaging aab ON aab.Identifier = aa.Identifier
																AND aab.ActionId = aa.ActionId
																AND aab.Direction = 0 
																AND aa.Direction = 1
																AND aab.TestId <> aa.TestId
					 INNER JOIN #Sessions s ON s.SessionId = aa.SessionId
				GROUP BY  s.FileId)


SELECT
	ti.SessionId,ti.TestId,
	fl.CollectionName,
	fl.ASideDevice,
	fl.ASideFileName,
	fl.TestDescription,
	fl.ASideNumber,
	Session_Info = s.info,
	ti.TestName,
	ti.TypeOfTest,
	ni.Operator,
	ni.HomeOperator,
	ni.technology,
	t.PrevTechnology,

	EndTime = CONVERT(VARCHAR,COALESCE(aa.MsgTime,aaf.MsgTime,aam.MsgTime, sm.MsgTime),121),
	App = atp.ServiceProvider,
	ProfileName = atp.ServiceProfileName,
	ActionId = COALESCE(aa.ActionId, aaf.ActionId,aam.ActionId, sm.ActionId),
	Duration = COALESCE(aa.Duration,aaf.Duration,aam.Duration, sm.CoreDuration),
	Throughput = CASE ISNULL(CAST(aa.Throughput AS real),aaf.Thp)*8/1000 WHEN 0 THEN NULL ELSE ISNULL(CAST(aa.Throughput AS real),aaf.Thp)*8/1000 END ,
	ActionStatus = CASE COALESCE(aa.ErrorCode,aaf.ErrorCode,aam.ErrorCode, sm.ErrorCode) WHEN 0 THEN 'Success' ELSE 'Failed' END,
	ActionName = CASE WHEN aap.ActionName = 'Ohome' THEN 'Open Home'
					WHEN aap.ActionName = 'Dp' THEN 'Delete Post'
					WHEN aap.ActionName = 'Cp' THEN 'Create Post'
					WHEN aap.ActionName = 'Lp' THEN 'Like Post'
					WHEN aap.ActionName = 'Cpicture' THEN 'Comment Post'
					WHEN aap.ActionName = 'Opost' THEN 'Open Post'
					WHEN aap.ActionName = 'Oprofile' THEN 'Open Profile'
					ELSE COALESCE(aap.ActionName,aad.ActionName,aau.ActionName,aaf.ActionName,aam.ActionName)
					END,
	aaf.Latency,
	aaf.PacketLossPercent,
	ni.CGI,
	StartTime = DATEADD(MS,-1*COALESCE(aa.Duration,aaf.Duration,aam.Duration, sm.CoreDuration),COALESCE(aa.MsgTime,aaf.MsgTime,aam.MsgTime, sm.MsgTime)),
	DATEADD(MS,-1*COALESCE(aa.Duration,aaf.Duration,aam.Duration, sm.CoreDuration),COALESCE(aa.MsgTime,aaf.MsgTime,aam.MsgTime, sm.MsgTime)) as MsgDate

FROM #Sessions s
INNER JOIN FileList fl ON fl.FileId = s.FileId
INNER JOIN TestInfo ti ON s.SessionId = ti.SessionId AND ti.valid = 1
INNER JOIN ResultsAppTestParameters atp ON ti.TestId = atp.TestId
LEFT OUTER JOIN ResultsAppActionSocialMedia sm ON sm.TestId = ti.TestId
LEFT OUTER JOIN ResultsAppAction aa ON ti.TestId = aa.TestId and aa.LastBlock = 1
LEFT OUTER JOIN ResultsAppActionParams aap ON (aap.TestId = aa.TestId OR aap.TestId = sm.TestId)AND (aap.ActionId = aa.ActionId OR aap.ActionId = sm.ActionId) 
LEFT OUTER JOIN ResultsAppActionDownloadFileParams aad  ON ti.TestId = aad.TestId AND aad.ActionId = aa.ActionId
LEFT OUTER JOIN ResultsAppActionUploadFileParams aau ON ti.TestId = aau.TestId AND aau.ActionId = aa.ActionId
LEFT OUTER JOIN (
					SELECT 
						TestId,
						ActionId,
						MsgTime,
						ErrorCode,
						NetworkId,
						Duration = 1000*CAST(DLSize AS real) / NULLIF(DLThroughput, 0),
						TransSize= DLSize,
						Thp = DLThroughput,
						ActionName = 'Downlink Performance',
						Latency = ISNULL(Ping,Latency),
						PacketLossPercent
					FROM ResultsAppActionPerformance
						INNER JOIN #Sessions s1 ON s1.SessionId = ResultsAppActionPerformance.SessionId
					UNION ALL
					SELECT 
						TestId,
						ActionId,
						MsgTime,
						ErrorCode,
						NetworkId,
						Duration = 1000*CAST(ULSize AS real) / NULLIF(ULThroughput, 0),
						TransSize= ULSize,
						Thp = ULThroughput,
						ActionName = 'Uplink Performance',
						Latency = ISNULL(Ping,Latency),
						PacketLossPercent
					FROM ResultsAppActionPerformance
						INNER JOIN #Sessions s2 ON s2.SessionId = ResultsAppActionPerformance.SessionId
					) aaf ON ti.TestId = aaf.TestId
LEFT OUTER JOIN (SELECT  
					r.TestId,
					r.ActionId,
					r.MsgTime,
					r.ErrorCode,
					r.NetworkId,
					r.Direction,
					ActionName = CASE r.MessagingType WHEN 1 THEN 'Text'
													WHEN 2 THEN 'Sticker'
													When 3 THEN 'Photo'
													WHEN 4 THEN 'Audio'
													WHEN 5 THEN 'Video' 
													ELSE NULL END,
					Duration = CASE r.Direction WHEN 0 THEN r.Duration 
												WHEN 1 THEN DATEDIFF(ms,s.StartTime,r.LogTime) -ISNULL(mdd.MinDeliveryTime,0) + ISNULL(md.MinDuration,100) -- Calculate Delivery Duration: substract the MinDeliveryTime which defines the Time difference of the 2 systems and add a minimal delivery duratio wich is the minimal TCP roundtrip time
												ELSE NULL END
				FROM  ResultsAppActionMessaging r
				INNER JOIN #Sessions s3 ON s3.SessionId = r.SessionId
				LEFT OUTER JOIN #MinDur md ON r.TestId = md.TestId
				INNER JOIN #MinDelDur mdd On s3.FileId = mdd.FileId
				LEFT OUTER JOIN ResultsAppActionMessaging s on s.Identifier = r.Identifier AND s.ActionId = r.ActionId AND s.Direction=0 and r.Direction=1
				) aam ON ti.TestId = aam.TestId 
	INNER JOIN NetworkInfo ni ON ni.NetworkId = ISNULL(ISNULL(ISNULL(aa.NetworkId, aaf.NetworkId),aam.NetworkId),ti.NetworkId)
LEFT OUTER JOIN Technology t ON t.PrevTechnology IS NOT NULL AND 
								((t.testid = sm.testId AND sm.MsgTime BETWEEN DATEADD(ms,t.Duration*-1,t.Msgtime) AND t.MsgTime)
								OR
								(t.testid = aam.testId AND aam.MsgTime BETWEEN DATEADD(ms,t.Duration*-1,t.Msgtime) AND t.MsgTime)
								OR
								(t.testid = aaf.testId AND aaf.MsgTime BETWEEN DATEADD(ms,t.Duration*-1,t.Msgtime) AND t.MsgTime)
								OR
								(t.testid = aa.testId AND aa.MsgTime BETWEEN DATEADD(ms,t.Duration*-1,t.Msgtime) AND t.MsgTime))
WHERE ti.qualityIndication NOT LIKE ' Error=Initialization failed'
ORDER by ti.TestId, ISNULL(aa.ActionId, aaf.ActionId) 
