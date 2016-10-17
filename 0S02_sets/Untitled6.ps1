﻿35F39DAD-9868-4853-BA93-BB9034ADEAC6  BA93BB9034ADEAC6	0	SP2013-S4-58	                            1	No description available.	1	13	0x1439497C2BFE994B9E1678C3E8A1608C	0	0	0	0	0	0	0	0	2014-09-29 17:03:39.260	2014-09-29 17:03:39.263	4
{ #p.63
Param(
  [string] $publisherServer,
  [string] $pdbname,
  [string] $distServer
)

##
$tsql_select=@"      
select distinct p.publication as [Publication],p.publisher_db as [publisherdb],r.name as [subscriber],s.subscriber_db as [subscriberdb]
from distribution.dbo.MSpublications  p 
join distribution.dbo.MSsubscriptions  s on p.publication_id=s.publication_id
join sys.servers  r on s.subscriber_id =r.server_id
where p.publication='$PName'
"@
$getpublication=Invoke-Sqlcmd -Query $tsql_select -ServerInstance $distServer  -Database $dDBName
$publisherdb =$getpublication.publisherdb
$subscriber  =$getpublication.subscriber
$subscriberdb=$getpublication.subscriberdb
##
$tsql_selectagent=@"  
select name FROM [distribution]..MSsnapshot_agents where publication='$PName'
"@
$snapshotagent=Invoke-Sqlcmd -Query $tsql_selectagent -ServerInstance $distServer  -Database $dDBName
$snapshota=$snapshotagent.name
##
EXEC sp_reinitsubscription 
    @subscriber     = N'$subscriber',
    @destination_db = N'$subscriberdb',
    @publication    = N'$PName';
GO