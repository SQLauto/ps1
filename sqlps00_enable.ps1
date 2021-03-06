<#SQLPS00
\\192.168.112.124\c$\Users\administrator.CSD\OneDrive\download\PS1\sqlps00_enable.ps1

SQL Server PowerShell  Basic Task

lastupdate: Apr.25.2014
1.sqlcmd 公用程式
2.Invoke-Sqlcmd  SQLPS03.sql

SQLPath  vs SMO

$ps1fS=gi C:\Users\administrator.CSD\OneDrive\download\ps1\sqlps00_enable.ps1

foreach ($ps1f in $ps1fS)
{
    start-sleep 1
    $ps1fname         =$ps1fS.name
    $ps1fFullname     =$ps1fS.FullName 
    $ps1flastwritetime=$ps1fS.LastWriteTime
    $getdagte         = get-date -format yyyyMMdd
    $ps1length        =$ps1fS.Length

    Send-MailMessage -SmtpServer  '172.16.200.27'  -To "a0921887912@gmail.com","abcd12@gmail.com" -from 'a0921887912@gmail.com' `
    -attachment $ps1fFullname  `
    -Subject "ps1source  -- $getdagte      --        $ps1fname       --   $ps1flastwritetime -- $ps1length " `
    -Body "  ps1source from:me $ps1fname   " 
}

#>
  
#net stop MSSQLSERVER
#sleep 10
#net start MSSQLSERVER
  
#(1) 50 before start : check SQLPS
#(2) 100  sQL Modules and snap-ins:
#(3) 150  Import-Module “sqlps” -DisableNameChecking
#(4) 150  naming parament rules  Development environment
#(5) 200  SQL Server Management Objects (SMO)  p20
#(6) 270  discover SQL-related cmdlets  p22
# (7)   service cmdlet
# (8) 300 SQL server configuration settings         with SQLPath
# (9) 350  Get / Set  configuration settings        with smo
# (10) 400 remote query timeout (s)
# (11) Searching for all database objects save to file  p60
# (12)  500  Creating /Drop /Set a database         with SMO  p67
# (13)  550  Creating /Drop /Set a table            with SMO  p75
# (14)  600  Creating /Drop /Set a VIEW             with SMO  p81
# (15)  650  Creating /Drop /Set a stored procedure with SMO  p85
# (16)  700  Creating /Drop /Set a Trigger          with SMO  p90
# (17)  750  Creating /Drop /Set INDEX              with SMO  p95
# (18)  850  Executing a query / SQL script with SMO  p99
# (19)  900 uninstall SQL feature SSRS
#  889  cliconfg
#  896  Install SQL Server PowerShell Module (SQLPS)
#  912  using ConfigurationFile install SQL 
#  986   catch error invoke-sqlcmd 







$PSVersionTable.PSVersion



#----------------------------------------------------------------
#   (1) 50 before start : check SQLPS
#---------------------------------------------------------------
Get-PSProvider #PSProvider is similar to an adapter, which allows these data stores to be seen as drives.
Get-Psdrive
Set-ExecutionPolicy RemoteSigned
Add-PSSnapin SqlServerCmdletSnapin100
PS C:\> Get-PSProvider 
Name                 Capabilities                  Drives                      
----                 ------------                  ------                      
Alias                ShouldProcess                 {Alias}                     
Environment          ShouldProcess                 {Env}                       
FileSystem           Filter, ShouldProcess, Cre... {C, H, G}                   
Function             ShouldProcess                 {Function}                  
Registry             ShouldProcess, Transactions   {HKLM, HKCU}                
Variable             ShouldProcess                 {Variable}                  
SqlServer            Credentials                   {SQLSERVER}                 
Certificate          ShouldProcess                 {Cert}                      
WSMan                Credentials                   {WSMan} 
#----------------------------------------------------------------
#   (2) 100  sQL Modules and snap-ins:
#---------------------------------------------------------------
  Modules and snap-ins are ways to extend PowerShell. 
  Both modules and snap-ins can add cmdlets and providers to your current session.
  
Import-Module  'C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules\SQLPS' -DisableNameChecking



# 1)Snap-ins are Dynamically Linked Libraries (DLL), and need to be registered before they can be used. Snap-ins are available in V1, V2, and V3.:
# 2)Modules can additionally load functions, variables, aliases, and other tools to your session

##
Get-PSSnapin

Name        : Microsoft.PowerShell.Core
PSVersion   : 3.0
Description : This Windows PowerShell snap-in contains cmdlets used to manage components of Windows PowerShell.

Name        : Microsoft.SharePoint.PowerShell
PSVersion   : 1.0
Description : Register all administration Cmdlets for Microsoft SharePoint Server

##
  Add-PSSnapin SqlServerCmdletSnapin100


  
#----------------------------------------------------------------
#  (3) 150  Import-Module “sqlps” -DisableNameChecking
#---------------------------------------------------------------
Get-Module
Import-Module “sqlps” -DisableNameChecking

if ((Get-Module -Name sqlps) -eq $null)
{
   Import-Module “sqlps” -DisableNameChecking
}

'
ModuleType Name                                ExportedCommands                
---------- ----                                ----------------                
Script     ISE                                 {Get-IseSnippet, Import-IseSn...
Manifest   Microsoft.PowerShell.Management     {Add-Computer, Add-Content, C...
Manifest   Microsoft.PowerShell.Security       {ConvertFrom-SecureString, Co...
Manifest   Microsoft.PowerShell.Utility        {Add-Member, Add-Type, Clear-...
Manifest   Microsoft.WSMan.Management          {Connect-WSMan, Disable-WSMan...
Manifest   SQLASCMDLETS                        {Add-RoleMember, Backup-ASDat...
Script     Sqlps                                                               
Manifest   SQLPS                               {Add-SqlAvailabilityDatabase,...
'
#----------------------------------------------------------------
#  (4) 150  naming parameter rules  Development environment
#---------------------------------------------------------------- 
0)  set values(Sv)  $SvivSql , $SVivDatabase
    foreach  (FE) $FENodes , $FESQLservices/   each -> $FESQLservice
    GetValue (GV)  ex : GVIPAddr   ,$GVSQLinstances
    Function UpdateXXX :  update + insert ,  :     Function GetXXX : insert only 
    $sql_select   ,$sql_insert  ,$sql_update
1)
$AGDatabase="SQL_Inventory"
$Databases="SQL_Inventory"
2)
$Node1='SP2013'
$Node2='SQL2012X'
3)
$SQLInstance1='Default'
$SQLInstance2='SQLS2'

4)
$SQLCluster1='SQL-B-2012'
$SQLCluster2='SQL-Y-2012\PR'
$SQLCluster ='DGPAP2\SQL2008R2'
5)
$AGName1='SPMAG'

6)
$SQLPathInstance1="SQLSERVER:\sql\"+$Node1+"\"+$SQLInstance1 ; $SQLPathInstance1
cd  $SQLPathInstance1 ;ls

$objectInstance1=gi . ; $objectInstance1 |select *

7)
$SQLPathAG1=$SQLPathInstance1+"\AvailabilityGroups\"+$AGName1; $SQLPathAG1
cd $SQLPathAG1
$objectAGName1=gi . ; $objectAG1 |select *


7-1)
$SQLPathDatabases1=$SQLPathInstance1+"\Databases\"+$Databases; $SQLPathDatabases1
cd $SQLPathDatabases1 ; ls
$SQLPathDatabases1=gi . ; $SQLPathDatabases1 |select *

8-1)

AvailabilityDatabases
AvailabilityGroupListeners
AvailabilityReplicas
DatabaseReplicaStates

$SQLPathAGDatabases1=$SQLPathAG1+"\AvailabilityDatabases\"+$AGDatabase

cd $SQLPathAGDatabases1
$objectAGDatabases1=gi . ; $objectAGDatabases1 |select *


8-2)

AvailabilityDatabases
AvailabilityGroupListeners
AvailabilityReplicas
DatabaseReplicaStates

$SQLPathAGReplicas1=$SQLPathAG1+"\AvailabilityReplicas\"+$Node1

cd $SQLPathAGReplicas1
$objectAGReplicas1=gi . ; $objectAGReplicas1 |select *


$SQLPathAGReplicas2=$SQLPathAG1+"\AvailabilityReplicas\"+$Node2

cd $SQLPathAGReplicas2
$SQLPathAGReplicas2=gi . ; $SQLPathAGReplicas2 |select *

#----------------------------------------------------------------
#  (5) 200  SQL Server Management Objects (SMO)  p20
#----------------------------------------------------------------

SMO is comprised of two distinct classes: instance classes and utility classes

Instance classes are the SQL Server objects. Properties of objects such as the server, the databases, and tables can be accessed and set using the instance classes.
Utility classes are helper or utility classes that accomplish common SQL Server tasks. These classes belong to one of three groups: Transfer class, Backup and Restore classes, or Scripter class.

## install SMO
 
 1. If you are installing SQL Server 2012, or already have SQL Server 2012, SMO can be installed by installing "Client Tools SDK". Get your install disk or image ready.
 2. If you want just SMO installed without installing SQL Server, download the SQS Server Feature 2012 pack

   2.1. Open your web browser, go to your favorite search engine, and search forSQL Server 2012 Feature Pack.
   2.2 Download the package.
   2.3. Double-click on SharedManagementObjects.msi to install

   SMO assemblies will be installed in <SQL Server Install Directory>\110\  SDK\Assemblies.

## loading SMO
   Import-Module SQLPS
   Get-Module

## usage
  powershell V1:  [void][Reflection.Assembly]::Load("Microsoft.SqlServer.Smo, Version=9.0.242.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91")
  PowerShell V2:  Add-Type -AssemblyName "Microsoft.SqlServer.Smo"
  PowerShell V3:  Import-Module SQLPS


#----------------------------------------------------------------
#  (6) 270  discover SQL-related cmdlets  p22
#----------------------------------------------------------------
## how may commands for mo
Get-Command -Module "*SQL*" | Measure-Object   41

#list all the SQL-related commands
Get-Command -Module "*SQL*" | Select CommandType, Name, ModuleName |Sort -Property ModuleName, CommandType, Name | ft -AutoSize

CommandType Name                                     ModuleName  
----------- ----                                     ----------  
     Cmdlet Add-RoleMember                           SQLASCMDLETS
     Cmdlet Backup-ASDatabase                        SQLASCMDLETS
     Cmdlet Invoke-ASCmd                             SQLASCMDLETS
     Cmdlet Invoke-ProcessCube                       SQLASCMDLETS
     Cmdlet Invoke-ProcessDimension                  SQLASCMDLETS
     Cmdlet Invoke-ProcessPartition                  SQLASCMDLETS
     Cmdlet Merge-Partition                          SQLASCMDLETS
     Cmdlet New-RestoreFolder                        SQLASCMDLETS
     Cmdlet New-RestoreLocation                      SQLASCMDLETS
     Cmdlet Remove-RoleMember                        SQLASCMDLETS
     Cmdlet Restore-ASDatabase                       SQLASCMDLETS
   Function SQLSERVER:                               SQLPS       
     Cmdlet Add-SqlAvailabilityDatabase              SQLPS       
     Cmdlet Add-SqlAvailabilityGroupListenerStaticIp SQLPS       
     Cmdlet Backup-SqlDatabase                       SQLPS       
     Cmdlet Convert-UrnToPath                        SQLPS       
     Cmdlet Decode-SqlName                           SQLPS       
     Cmdlet Disable-SqlAlwaysOn                      SQLPS       
     Cmdlet Enable-SqlAlwaysOn                       SQLPS       
     Cmdlet Encode-SqlName                           SQLPS       
     Cmdlet Invoke-PolicyEvaluation                  SQLPS       
     Cmdlet Invoke-Sqlcmd                            SQLPS       
     Cmdlet Join-SqlAvailabilityGroup                SQLPS       
     Cmdlet New-SqlAvailabilityGroup                 SQLPS       
     Cmdlet New-SqlAvailabilityGroupListener         SQLPS       
     Cmdlet New-SqlAvailabilityReplica               SQLPS       
     Cmdlet New-SqlHADREndpoint                      SQLPS       
     Cmdlet Remove-SqlAvailabilityDatabase           SQLPS       
     Cmdlet Remove-SqlAvailabilityGroup              SQLPS       
     Cmdlet Remove-SqlAvailabilityReplica            SQLPS       
     Cmdlet Restore-SqlDatabase                      SQLPS       
     Cmdlet Resume-SqlAvailabilityDatabase           SQLPS       
     Cmdlet Set-SqlAvailabilityGroup                 SQLPS       
     Cmdlet Set-SqlAvailabilityGroupListener         SQLPS       
     Cmdlet Set-SqlAvailabilityReplica               SQLPS       
     Cmdlet Set-SqlHADREndpoint                      SQLPS       
     Cmdlet Suspend-SqlAvailabilityDatabase          SQLPS       
     Cmdlet Switch-SqlAvailabilityGroup              SQLPS       
     Cmdlet Test-SqlAvailabilityGroup                SQLPS       
     Cmdlet Test-SqlAvailabilityReplica              SQLPS       
     Cmdlet Test-SqlDatabaseReplicaState             SQLPs

## 
Get-Module -Name '*SQL*'

ModuleType Name                                ExportedCommands                                                                                                                       
---------- ----                                ----------------                                                                                                                       
Manifest   SQLASCMDLETS                        {Add-RoleMember, Backup-ASDatabase, Invoke-ASCmd, Invoke-ProcessCube...}                                                               
Script     Sqlps                                                                                                                                                                      
Manifest   SQLPS                               {Add-SqlAvailabilityDatabase, Add-SqlAvailabilityGroupListenerStaticIp, Backup-SqlDatabase, Convert-UrnToPath...}                      


#----------------------------------------------------------------
# (7)   service cmdlet
#----------------------------------------------------------------   
Get-Command -Name *Service* -CommandType Cmdlet -ModuleName

gsv *SQLBrowser*
gsv -DisplayName '*sQL Server*'


$services = @("SQLBrowser","ReportServer")

#----------------------------------------------------------------
# (8) 300 SQL server configuration settings with SQLPath
#----------------------------------------------------------------


##Path
SQLSERVER:\SQL #The default database for the login ID in the default instance on the local computer.
SQLSERVER:\SQL\ComputerName
SQLSERVER:\SQL\ComputerName\InstanceName
SQLSERVER:\SQL\ComputerName\InstanceName\Databases
SQLSERVER:\SQL\ComputerName\InstanceName\Databases\DatabaseName


$Node1='SP2013'
$SQLInstance1='Default'
$SQLPathInstance1="SQLSERVER:\sql\"+$Node1+"\"+$SQLInstance1 ; $SQLPathInstance1
cd  $SQLPathInstance1 ;ls

$objectInstance1=gi . ; $objectInstance1 |select * | sort name 

$objectInstance1|gm

'Includes non-configurable instance settings, such as BuildNumber, Edition, OSVersion, and ProductLevel
It also includes settings specified during install,for example Collation, MasterDBPath, and MasterDBLogPath
'
$objectInstance1.Information.Properties  |select name, value |ft -AutoSize

'Lists some instance-level configurable settings, such as LoginMode and BackupDirectory'
$objectInstance1.Settings.Properties |select name, value

'Contain options that can be set for user connections, such as AnsiWarnings, AnsiNulls, AnsiPadding, and NoCount'
$objectInstance1.UserOptions.Properties |select name, value |ft -AutoSize

'Instance-specific settings, such as AgentXPs, remote access, clr enabled, and xp_cmdshell, 
which you will normally see and set when you use the sp_configure system storedprocedure'

$objectInstance1.Configuration.Properties |select DisplayName, Description, RunValue, ConfigValue |ft -AutoSize

$objectInstance1.Configuration.Properties | ? 

#----------------------------------------------------------------
# (9) 350 get /set  SQL server configuration settings with smo
#----------------------------------------------------------------

##Get
$instanceName = "sp2013"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$server |gm | ? MemberType -eq "Property"

$server.Information.Properties | select Name, Value | Format-Table –AutoSize
$server.UserOptions.Properties |Select Name, Value |Format-Table -AutoSize
$server.Configuration.Properties |Select DisplayName, RunValue,Description | sort Displayname |Format-Table -AutoSize


## set 


#Change FillFactor to 60 percent
$server.Configuration.Properties |? Displayname -eq 'fill factor (%)' 
$server.Configuration.FillFactor.ConfigValue=60
$server.Configuration.Alter()

#Enable SQL Server Agent
$server.Configuration.Properties |? Displayname -eq 'Agent XPs' 
$server.Configuration.AgentXPsEnabled.ConfigValue = 0
$server.Configuration.Alter()

#Set minimum server memory to 500 MB
$server.Configuration.Properties |? Displayname -eq 'min server memory (MB)'  # 1024
$server.Configuration.MinServerMemory.ConfigValue= 0

$server.Configuration.Alter()

#Change authentication method to Mixed
$server.Settings |gm | ?  Name -eq  'LoginMode' |fl #Definition : Microsoft.SqlServer.Management.Smo.ServerLoginMode LoginMode 
             {get;set;}
'
Type: Microsoft.SqlServer.Management.Smo.ServerLoginMode LoginMode  
Enumeration:
    Integrated - Windows Authentication
    Mixed - Mixed Mode
    Normal - SQL Server Only Authentication
    Unknown - Undefined (and no, I haven't tried it.)'
'
$server.Settings.LoginMode = [Microsoft.SqlServer.Management.Smo.ServerLoginMode]::Mixed
$server.Alter()

#----------------------------------------------------------------
# (10) 400 remote query timeout (s)
#----------------------------------------------------------------

##TSQL
SP_configure

run_value and config_value. 
    config_value is what value the setting is set to. 
    run_value is what SQL Server is currently using.

## Get
$objectInstance1.Configuration.Properties  |Select DisplayName  |sort DisplayName
$server.Configuration.Properties|? DisplayName -eq   'remote query timeout (s)' 


$server.Configuration.RemoteLoginTimeout=300  #   
$server.Alter()

'RemoteLoginTimeout' is a ReadOnly property.
At line:1 char:1
+ $server.Configuration.RemoteLoginTimeout=300  #
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (:) [], RuntimeException
    + FullyQualifiedErrorId : PropertyAssignmentException


#----------------------------------------------------------------
# (11) Searching for all database objects save to file  p60
#----------------------------------------------------------------
$instanceName = "sp2013"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$instanceName1 = "sp2013\sqls2"
$server1 = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName1

$server.Databases 
$server1.Databases 

#
$databaseName = "AdventureWorks2008R2"
$db = $server.Databases[$databaseName]

#what keyword are we looking for?
$searchString = "Product"

#create empty array, we will store results here
$results = @()


#now we will loop through all database SMO
#properties and look of objects that match
#the search string
#note we are explicitly excluding Federations, because
#this throws an error
$db |
Get-Member -MemberType Property |
Where Definition -Like "*Smo*" |
Where Definition -NotLike "*Federation*" |
ForEach-Object {
$type = $_.Name ;
$db.$type |
Where Name -Like "*$searchstring*" |
ForEach-Object {
$result = New-Object -Type PSObject -Prop @{"ObjectType"=$type.Replace("Microsoft.SqlServer.Management.Smo.", "")
"ObjectName"=$_.Name
}
$results += $result
}
}

#display results
$results
#export results to csv file
$file = "C:\Temp\SearchResults.csv"
$results | Export-Csv -Path $file -NoTypeInformation
#display file contents
notepad $file

#----------------------------------------------------------------
# (12)  500  Creating /Drop /Set a database with SMO  p67
#----------------------------------------------------------------
$instanceName1 = "sp2013\sqls2"
$server1 = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName1
##Get 
#to confirm, list databases in your instance
$server1.Databases |Select Name, Status, Owner, CreateDate

##Creating
#database TestDB with default settings
#assumption is that this database does not yet exist
$dbName = "TestMDB"
$db1 = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($server1, $dbName)
$db1.Create()

#to confirm, list databases in your instance
$server1.Databases |Select Name, Status, Owner, CreateDate


##set
$dbName = "TestMDB"
$db = $server.Databases[$dbName]

'Change ANSI NULLS Enabled to False
Change ANSI PADDING Enabled to False
Restrict user access to RESTRICTED_USER
Set the database to Read Only
'
#DatabaseOptions

    #change ANSI NULLS and ANSI PADDING
    $db.DatabaseOptions.AnsiNullsEnabled = $false
    $db.DatabaseOptions.AnsiPaddingEnabled = $false

    #Change database access
    #DatabaseUserAccess enum values: multiple, restricted, single
    $db.DatabaseOptions.UserAccess = [Microsoft.SqlServer.Management.Smo.DatabaseUserAccess]::Restricted
    $db.Alter()


    #some options are not available through the
    #DatabaseOptions property
    #so we will need to access the database object directly
    #change compatiblity level to SQL Server 2005
    #available CompatibilityLevel values are from
    #Version 6.5 ('Version65') all the way to SQL
    #Server 2012 ('Version110')
    #however Version80 is not a valid compatibility option
    #for SQL Server 2012
    $db.AutoUpdateStatisticsEnabled = $true
    $db.CompatibilityLevel = [Microsoft.SqlServer.Management.Smo.CompatibilityLevel]::Version90 #CompatibilityLevel Enumeration
    $db.Alter()


    #set to readonly
    $db.DatabaseOptions.ReadOnly = $true
    $db.Alter()

##drop 
    $dbName1 = "TestMDB"
    #need to check if database exists, and if it does, drop it
    $db = $server1.Databases[$dbName1]
    if ($db)
    {
    #we will use KillDatabase instead of Drop
    #Kill database will drop active connections before
    #dropping the database
    $server1.KillDatabase($dbName1)
    }


#----------------------------------------------------------------
# (13)  550  Creating /Drop /Set a table with SMO  p75
#----------------------------------------------------------------
$instanceName1 = "sp2013\sqls2"
$server1 = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName1

$dbName = "TestMDB"

$dbName = "AdventureWorks2008R2"
$tableName = "Student"
$db1 = $server1.Databases[$dbName] # 
$table1 = $db1.Tables[$tableName]
##


$table = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Table -ArgumentList $db, $tableName
#column class on MSDN
#http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.column.aspx

#column 1
$col1Name = "StudentID"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::Int;
$col1 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col1Name, $type
$col1.Nullable = $false
$col1.Identity = $true
$col1.IdentitySeed = 1
$col1.IdentityIncrement = 1
$table.Columns.Add($col1)

#column 2 - nullable
$col2Name = "FName"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::VarChar(50)
$col2 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col2Name, $type
$col2.Nullable = $true
$table.Columns.Add($col2)
#column 3 - not nullable, with default value
$col3Name = "LName"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::VarChar(50)
$col3 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col3Name, $type
$col3.Nullable = $false
$col3.AddDefaultConstraint("DF_Student_LName").Text = "'Doe'"
#column 4 - nullable, with default value
$col4Name = "DateOfBirth"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::DateTime;
$col4 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col4Name, $type
$col4.Nullable = $true
$col4.AddDefaultConstraint("DF_Student_DateOfBirth").Text =
"'1800-00-00'"
$table.Columns.Add($col4)
#column 5
$col5Name = "Age"
$type = [Microsoft.SqlServer.Management.SMO.DataType]::Int;
$col5 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Column -ArgumentList $table, $col5Name, $type
$col5.Nullable = $false
$col5.Computed = $true
$col5.ComputedText = "YEAR(GETDATE()) - YEAR(DateOfBirth)";
$table.Columns.Add($col5)
$table.Create()

#note this is just a "placeholder" right now for PK
#no columns are added in this step
$PK=New-Object-TypeNameMicrosoft.SqlServer.Management.SMO.Index -ArgumentList$table,"PK_Student_StudentID"
$PK.IsClustered =$true
$PK.IndexKeyType =[Microsoft.SqlServer.Management.SMO.IndexKeyType]::DriPrimaryKey
#identify columns part of the PK
$PKcol=New-Object-TypeNameMicrosoft.SqlServer.Management.SMO.IndexedColumn-ArgumentList$PK,$col1Name
$PK.IndexedColumns.Add($PKcol)
$PK.Create()

##

#if table exists drop
if($table)
{
$table1.Drop()
}

#----------------------------------------------------------------
# (14)  600  Creating /Drop /Set a VIEW with SMO  p81
#----------------------------------------------------------------
CREATE VIEW dbo.vwVCPerson
AS
SELECT
TOP 100
BusinessEntityID,
LastName,
FirstName
FROM
Person.Person
WHERE
PersonType = 'IN'
ORDER BY
LastName
GO
##
$dbName = "AdventureWorks2008R2"
$db = $server.Databases[$dbName]
$viewName = "vwVCPerson"
$view = $db.Views[$viewName]
#if view exists, drop it
if ($view)
{
$view.Drop()
}
$view = New-Object -TypeName Microsoft.SqlServer.Management.SMO.
View -ArgumentList $db, $viewName, "dbo"
#TextMode = false meaning we are not
#going to explicitly write the CREATE VIEW header
$view.TextMode = $false
$view.TextBody = @"
SELECT
TOP 100
BusinessEntityID,
LastName,
FirstName
FROM
Person.Person
WHERE
PersonType = 'IN'
ORDER BY
LastName
"@
$view.Create()


$result = Invoke-Sqlcmd -Query "SELECT * FROM vwVCPerson" -ServerInstance "$instanceName" -Database $dbName




#----------------------------------------------------------------
# (15)  650  Creating /Drop /Set a stored procedure with SMO  p85
#----------------------------------------------------------------
'
CREATE PROCEDURE [dbo].[uspGetPersonByLastName] @LastName [varchar]
(50)
WITH ENCRYPTION
AS
SELECT
TOP 10
BusinessEntityID,
LastName
FROM
Person.Person
WHERE
LastName = @LastName'
##
$dbName = "AdventureWorks2008R2"
$db = $server.Databases[$dbName]
#storedProcedure class on MSDN:
#http://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.storedprocedure.aspx
$sprocName = "uspGetPersonByLastName"
$sproc = $db.StoredProcedures[$sprocName]
#if stored procedure exists, drop it
if ($sproc)
{
$sproc.Drop()
}
$sproc = New-Object -TypeName Microsoft.SqlServer.Management.SMO.StoredProcedure -ArgumentList $db, $sprocName
#TextMode = false means stored procedure header
#is not editable as text
#otherwise our text will contain the CREATE PROC block
$sproc.TextMode = $false
$sproc.IsEncrypted = $true
$paramtype = [Microsoft.SqlServer.Management.SMO.Datatype]::VarChar(50);
$param = New-Object -TypeName Microsoft.SqlServer.Management.SMO.StoredProcedureParameter`
 -ArgumentList $sproc,"@LastName",$paramtype

$sproc.Parameters.Add($param)
#Set the TextBody property to define the stored procedure.
$sproc.TextBody = @"
SELECT
TOP 10
BusinessEntityID,
LastName
FROM
Person.Person
WHERE
LastName = @LastName
"@
# Create the stored procedure on the instance of SQL Server.
$sproc.Create()
#if later on you need to change properties, can use the Alter method

#----------------------------------------------------------------
# (16)  700  Creating /Drop /Set a Trigger with SMO  p90
#----------------------------------------------------------------
'CREATE TRIGGER [Person].[tr_u_Person]
ON [Person].[Person]
AFTER UPDATE
AS
SELECT
GETDATE() AS UpdatedOn,
SYSTEM_USER AS UpdatedBy,
i.LastName AS NewLastName,
i.FirstName AS NewFirstName,
d.LastName AS OldLastName,
d.FirstName AS OldFirstName
FROM
inserted i
INNER JOIN deleted d
ON i.BusinessEntityID = d.BusinessEntityID
'
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$dbName = "AdventureWorks2008R2"
$db = $server.Databases[$dbName]
$tableName = "Person"
$schemaName = "Person"
#get a handle to the Person.Person table
$table = $db.Tables |
? Schema -Like "$schemaName" |
? Name -Like "$tableName"
$triggerName = "tr_u_Person";
#note here we need to check triggers attached to table
$trigger = $table.Triggers[$triggerName]
#if trigger exists, drop it
if ($trigger)
{
$trigger.Drop()
}
$trigger = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Trigger -ArgumentList $table, $triggerName
$trigger.TextMode = $false
#this is just an update trigger
$trigger.Insert = $false
$trigger.Update = $true
$trigger.Delete = $false
#3 options for ActivationOrder: First, Last, None
$trigger.InsertOrder = [Microsoft.SqlServer.Management.SMO.Agent.ActivationOrder]::None
$trigger.ImplementationType = [Microsoft.SqlServer.Management.SMO.ImplementationType]::TransactSql
#simple example
$trigger.TextBody = @"
SELECT
GETDATE() AS UpdatedOn,
SYSTEM_USER AS UpdatedBy,
i.LastName AS NewLastName,
i.FirstName AS NewFirstName,
d.LastName AS OldLastName,
d.FirstName AS OldFirstName
FROM
inserted i
INNER JOIN deleted d
ON i.BusinessEntityID = d.BusinessEntityID
"@
$trigger.Create()



##  Test the stored procedure using PowerShell:
$firstName = "Frankk"
$result = Invoke-Sqlcmd `
-Query "UPDATE Person.Person SET FirstName = `'$firstName`' WHEREBusinessEntityID = 2081 " `
-ServerInstance "$instanceName" `
-Database $dbName

$result | Format-Table –AutoSize
#----------------------------------------------------------------
# (17)  750  Creating /Drop /Set INDEX with SMO  p95
#----------------------------------------------------------------
CREATE NONCLUSTERED INDEX [idxLastNameFirstName]
ON [Person].[Person]
(
[LastName] ASC,
[FirstName] ASC
)
INCLUDE ( [MiddleName])
GO
##
#replace this with your instance name
$instanceName = "KERRIGAN"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$dbName = "AdventureWorks2008R2"
$db = $server.Databases[$dbName]
$tableName = "Person"
$schemaName = "Person"
$table = $db.Tables |
Where Schema -Like "$schemaName" |
Where Name -Like "$tableName"
$indexName = "idxLastNameFirstName"
$index = $table.Indexes[$indexName]
#if stored procedure exists, drop it
if ($index)
{
$index.Drop()
}
$index = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Index -ArgumentList $table, $indexName
#first index column, by default sorted ascending
$idxCol1 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -ArgumentList $index, "LastName", $false
$index.IndexedColumns.Add($idxCol1)
#second index column, by default sorted ascending
$idxCol2 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -ArgumentList $index, "FirstName", $false
$index.IndexedColumns.Add($idxCol2)
#included column
$inclCol1 = New-Object -TypeName Microsoft.SqlServer.Management.SMO.IndexedColumn -ArgumentList $index, "MiddleName"
$inclCol1.IsIncluded = $true
$index.IndexedColumns.Add($inclCol1)
#Set the index properties.
<#
None - no constraint
DriPrimaryKey - primary key
DriUniqueKey - unique constraint
#>
$index.IndexKeyType = [Microsoft.SqlServer.Management.SMO.IndexKeyType]::None
$index.IsClustered = $false
$index.FillFactor = 70
#Create the index on the instance of SQL Server.
$index.Create()

## There's More
Index Type           What to set
Filtered             HasFilter
Filter               Definition
FullText             IsFullTextKey = $true
XML                  IsXMLIndex = $true
Spatial              IsSpatialIndex = $true

#----------------------------------------------------------------
# (18)  850  Executing a query / SQL script with SMO  p99
#----------------------------------------------------------------
#import SQL Server module
Import-Module SQLPS -DisableNameChecking
#replace this with your instance name
$instanceName = "KERRIGAN"
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

$dbName = "AdventureWorks2008R2"
$db = $server.Databases[$dbName]
#execute a passthrough query, and export to a CSV file
Invoke-Sqlcmd `
-Query "SELECT * FROM Person.Person" `
-ServerInstance "$instanceName" `
-Database $dbName | Export-Csv -LiteralPath "C:\Temp\ResultsFromPassThrough.csv" `
-NoTypeInformation

#execute the SampleScript.sql, and display results to screen
Invoke-SqlCmd `
-InputFile "C:\Temp\SampleScript.sql" `
-ServerInstance "$instanceName" `
-Database $dbName |
Select FirstName, LastName, ModifiedDate |
Format-Table
#----------------------------------------------------------------
#(19) 900 uninstall SQL feature SSRS
#----------------------------------------------------------------
#http://msdn.microsoft.com/en-us/library/ms144259.aspx
'Install SQL Server 2014 from the Command Prompt'
.\Setup.exe /Action=Uninstall /FEATURES=SQL,AS,RS,IS,Tools /INSTANCENAME=MSSQLSERVER

onenote:///C:\Users\Administrator\SkyDrive\onMicrosoft\SQL\Database%20Administration\configurationServer.one#Uninstall%20SSRS&section-id={696DF7AD-57BA-4D67-B649-11A50378A10C}&page-id={1D60CA51-EBC1-41F2-85D1-4D2B1C72F8E3}&end


#----------------------------------------------------------------
#889  cliconfg
#----------------------------------------------------------------


1. Start “C:\windows\system32\cliconfg.exe”
2. Start “C:\windows\syswow64\cliconfg.exe”

#----------------------------------------------------------------
#  896  Install SQL Server PowerShell Module (SQLPS) Aug.18.2015
#----------------------------------------------------------------
# download 
http://www.microsoft.com/zh-TW/download/confirmation.aspx?id=29065


# 安裝有順序
All you need to do is to download the following three packages from:
http://www.microsoft.com/en-us/download/details.aspx?id=29065
◾Microsoft® System CLR Types for Microsoft® SQL Server® 2012 (SQLSysClrTypes.msi)
◾Microsoft® SQL Server® 2012 Shared Management Objects (SharedManagementObjects.msi)
◾Microsoft® Windows PowerShell Extensions for Microsoft® SQL Server® 2012 (PowerShellTools.msi)

# 可以 appwiz.cpl 中看到三個安裝,加起來約 3.19M + 28.9M + 1.29M = 31M


#----------------------------------------------------------------
#  912  using ConfigurationFile install SQL 
#----------------------------------------------------------------
https://technet.microsoft.com/en-us/library/ms144259(v=sql.110).aspx

https://technet.microsoft.com/en-us/library/dd239405(v=sql.110).aspx


Setup.exe /SQLSVCPASSWORD="************" /AGTSVCPASSWORD="************" /ASSVCPASSWORD="************" /ISSVCPASSWORD="************" /RSSVCPASSWORD="************" /ConfigurationFile=MyConfigurationFile.INI

Setup.exe 
/SQLSVC PASSWORD="************" 
/AGTSVC PASSWORD="************" 
/ASSVCPASSWORD="************" 
/ISSVC PASSWORD="************" 
/RSSVC PASSWORD="************" /ConfigurationFile=MyConfigurationFile.INI


$Drives = Get-WmiObject win32_logicaldisk | ?{$_.drivetype -eq 5} | foreach-object {$_.name}

if SQLSource at E:

cmd /c ("E:\Setup") '/ConfigurationFile=C:\Demos\SQLServer2012\Scripts\MSSQL.ConfigurationFile.ini'

cmd /c ($Drives + "\Setup") '/ConfigurationFile=C:\Demos\SQLServer2012\Scripts\MSSQL.ConfigurationFile.ini'
write-progress -percentcomplete 35 -Activity "Installing MSSQL" -Status Installing

cmd /c ($Drives + "\Setup") '/ConfigurationFile=C:\Demos\SQLServer2012\Scripts\MULTIDIMENSIONAL.ConfigurationFile.ini'
write-progress -percentcomplete 55 -Activity "Installing MULTIDIMENSION" -Status Installing

cmd /c ($Drives + "\Setup") '/ConfigurationFile=C:\Demos\SQLServer2012\Scripts\PowerPivot.ConfigurationFile.ini'
write-progress -percentcomplete 75 -Activity "Installing POWERPIVOT" -Status Installing

cmd /c ($Drives + "\Setup") '/ConfigurationFile=C:\Demos\SQLServer2012\Scripts\RSIntegrated.ConfigurationFile.ini'
write-progress -percentcomplete 95 -Activity "Installing Reporting Service" -Status Installing


;作業系統上安裝英文版的 SQL Server : ENU="False" or "True"
; 安裝程式不會顯示任何使用者介面。     QUIET="False"
; 安裝程式只會顯示進度，沒有任何使用者互動。  QUIETSIMPLE="False"
; 指定 SQL Server 安裝程式應否探索並包含產品更新。有效值是 True 和 False 或 1 和 0。根據預設，SQL Server 安裝程式會包含發現的更新。   UpdateEnabled="False"

FEATURES=SQLENGINE,CONN,BC,SDK,SSMS,ADV_SSMS

; 指定共用元件的根安裝目錄。這個目錄在共用元件安裝後會保持不變。  INSTALLSHAREDDIR="C:\Program Files\Microsoft SQL Server"
; 指定 WOW64 共用元件的根安裝目錄.                        INSTALLSHAREDWOWDIR="C:\Program Files (x86)\Microsoft SQL Server"

; 指定預設或具名執行個體。MSSQLSERVER 是非 Express 版的預設執行個體，而 SQLExpress 則是 Express 版的預設執行個體。
安裝 SQL Server Database Engine (SQL)、Analysis Services (AS) 或 Reporting Services (RS) 時需要這個參數。 
INSTANCENAME="MSSQLSERVER"

; 指定您為 SQL Server 功能指定的執行個體識別碼。SQL Server 目錄結構、登錄結構和服務名稱都會納入 SQL Server 執行個體的執行個體識別碼。
INSTANCEID="MSSQLSERVER"

; 指定安裝目錄。  INSTANCEDIR="C:\Program Files\Microsoft SQL Server"
; Agent 帳戶名稱   AGTSVCACCOUNT="administrator"
; 安裝後自動啟動服務。 AGTSVCSTARTUPTYPE="Manual"

; 指定要使用於 Database Engine 的 Windows 定序或 SQL 定序。  SQLCOLLATION="Chinese_Taiwan_Stroke_CI_AS"

; SQL Server 服務的帳戶: 網域\使用者或系統帳戶。   SQLSVCACCOUNT="administrator"

; 要提供為 SQL Server 系統管理員的 Windows 帳戶。 SQLSYSADMINACCOUNTS="WIN-2S026UBRQFO\Administrator"

; 預設為 Windows 驗證。請使用混合模式驗證的 "SQL"。  SECURITYMODE="SQL"


ref : C:\Users\administrator.CSD\OneDrive\download\PS1\SQLINI



#----------------------------------------------------------------
#  986   catch error invoke-sqlcmd 
#----------------------------------------------------------------
$error.Clear()
try
{
    Invoke-Sqlcmd -ServerInstance  $TServerInstance -Database $Tdatabase -Query $TSQL_insert -ErrorAction 'Stop'
}
catch 
{
    $FileName  |out-file  D:\temp\err.txt
    $TSQL_insert
    Write-Host($error) 
}



#----------------------------------------------------------------
#     SQLSERVER:\SQL
#----------------------------------------------------------------   
PS SQLSERVER:\> dir

Name            Root                           Description                             
#----            ----                           -----------                             
SQL             SQLSERVER:\SQL                 SQL Server Database Engine              
SQLPolicy       SQLSERVER:\SQLPolicy           SQL Server Policy Management            
SQLRegistration SQLSERVER:\SQLRegistration     SQL Server Registrations                
DataCollection  SQLSERVER:\DataCollection      SQL Server Data Collection              
XEvent          SQLSERVER:\XEvent              SQL Server Extended Events              
Utility         SQLSERVER:\Utility             SQL Server Utility                      
DAC             SQLSERVER:\DAC                 SQL Server Data-Tier Application Compone
                                               nt                                      
SSIS            SQLSERVER:\SSIS                SQL Server Integration Services         
SQLAS           SQLSERVER:\SQLAS               SQL Server Analysis Services            

cd sql  #SQLSERVER:\sqlserver\sql
cd sql  ; dir

#----------------------------------------------------------------
#     SQLSERVER:\SQL
#---------------------------------------------------------------- 
Set-Location SQLSERVER:\SQL\SP2013\DEFAULT\Databases\MingDB
ls; cd Databases ; cd SQL_Inventory 
Invoke-Sqlcmd "SELECT DB_NAME() AS DatabaseName;"

Set-Location SQLSERVER:\SQL\spm\DEFAULT\Databases\SQL_Inventory
Invoke-Sqlcmd "SELECT DB_NAME() AS DatabaseName;"


#----------------------------------------------------------------
#      table = 變數
#---------------------------------------------------------------- 

DECLARE @SQL varchar(2000),@PathFileName varchar(100)
SET @PathFileName = 'TmpStList'
SET @SQL = ' Select * FROM  ' + @PathFileName  
EXEC (@SQL)

DECLARE @SQL varchar(2000),@PathFileName varchar(100), @dbname varchar(100)
SET @dbname ='WSS_Content_PMD'
SET @PathFileName = 'TmpStList'
SET @SQL = ' sp_helpdb ' + @dbname  
--SET @SQL = "BULK INSERT TmpStList FROM '"+@PathFileName+"' WITH (FIELDTERMINATOR = '"",""') " 
EXEC (@SQL)




gc c:\Servers.txt | % { Invoke-SQLCmd -Server $_ -Query "select @@servername as 'Server', count(*) as 'Blocked' from master.dbo.sysprocesses where blocked <> 0" } | Out-File -filePath "C:\Blocked.txt

#----------------------------------------------------------------
#      Ch05_整合 Windows PowerShell.sql
#----------------------------------------------------------------

-------------------------------------------------------------------
--範例程式碼5-1：自行撰寫 PowerShell 腳本檔案 test.ps1
-------------------------------------------------------------------
Add-PSSnapin SqlServerCmdletSnapin100
Add-PSSnapin SqlServerProviderSnapin100
gc c:\Servers.txt | % { Invoke-SQLCmd -Server $_ -Query "select @@servername as 'Server', count(*) as 'Blocked' from master.dbo.sysprocesses where blocked <> 0" } | Out-File -filePath "C:\Blocked.txt

-------------------------------------------------------------------
--範例程式碼5-2：載入與 SQL Server 2008 所提供與 PowerShell 相關的 Add-in，以及 .NET 組件
-------------------------------------------------------------------
# LoadProvider.ps1
# 載入 SQL Server provider extensions
# 使用方式：Powershell -NoExit -Command "& '.\ LoadProvider.ps1'"

# 設定發生錯誤後，要如何進行，可以設定：ontinue(預設)、silentlycontinue 以及 stop $ErrorActionPreference = "Stop"

# 若機器上沒有安裝 SQL Server Powershell Snap-in 就直接跳離載入的動作
$sqlpsreg="HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.SqlServer.Management.PowerShell.sqlps"

if (Get-Item $sqlpsreg -ErrorAction "SilentlyContinue")
{
    $item = Get-ItemProperty $sqlpsreg
    $sqlpsPath = [System.IO.Path]::GetDirectoryName($item.Path)
}
else
{ throw "未安裝 SQL Server Powershell "} #丟出例外，停止執行

# 要預先載入的組件列表，注意，在 provider 未用到之前，大部分的組件已經被載入
# 如果只需要 SQL Server Provider，則不需要以下的步驟
# 以節省 shell 所使用的資源
$assemblylist = 
"Microsoft.SqlServer.Smo",
"Microsoft.SqlServer.Dmf ",
"Microsoft.SqlServer.SqlWmiManagement ",
"Microsoft.SqlServer.ConnectionInfo ",
"Microsoft.SqlServer.SmoExtended ",
"Microsoft.SqlServer.Management.RegisteredServers ",
"Microsoft.SqlServer.Management.Sdk.Sfc ",
"Microsoft.SqlServer.SqlEnum ",
"Microsoft.SqlServer.RegSvrEnum ",
"Microsoft.SqlServer.WmiEnum ",
"Microsoft.SqlServer.ServiceBrokerEnum ",
"Microsoft.SqlServer.ConnectionInfoExtended ",
"Microsoft.SqlServer.Management.Collector ",
"Microsoft.SqlServer.Management.CollectorEnum"
# 載入組件
foreach ($asm in $assemblylist)
{ $asm = [Reflection.Assembly]::LoadWithPartialName($asm)}

# 設定 SQL Provider 所需要變數
Set-Variable -scope Global -name SqlServerMaximumChildItems -Value 0
Set-Variable -scope Global -name SqlServerConnectionTimeout -Value 30
Set-Variable -scope Global -name SqlServerIncludeSystemObjects -Value $false
Set-Variable -scope Global -name SqlServerMaximumTabCompletion -Value 1000

# 載入 snapins, type data, format data
Push-Location
cd $sqlpsPath

Add-PSSnapin SqlServerCmdletSnapin100
Add-PSSnapin SqlServerProviderSnapin100

Update-TypeData -PrependPath SQLProvider.Types.ps1xml 
update-FormatData -prependpath SQLProvider.Format.ps1xml 
Pop-Location

# 清空畫面
# cls

Write-Host -ForegroundColor Yellow 'SQL Server Powershell extensions 已被載入'
Write-Host
Write-Host -ForegroundColor Yellow '鍵入 "cd SQLSERVER:\" 已進到 provider'
Write-Host
Write-Host -ForegroundColor Yellow '若需要更多資訊，鍵入 "help SQLServer"'

#顯示所有可用的 Windows PowerShell 提供者清單
get-psprovider #

-------------------------------------------------------------------
--範例程式碼5-3：宣告與設定通用的變數
-------------------------------------------------------------------
# 設定 - 通用的變數
Set-Variable -scope Global -name machineName -Value "$env:ComputerName"; #透過 $env: 命名空間，取得系統環境變數 ComputerName 的值，也就是本機電腦名稱
# 預設的執行個體名稱可用 Default
Set-Variable -scope Global -name instanceName -Value "Default";
Set-Variable -scope Global -name scriptPath -Value "C:\PowerShellScript\"

# 先前定義要載入的SQL2K8 Provider
.\LoadProvider.ps1

-------------------------------------------------------------------
--範例程式碼5-4：從設定檔讀出定義
-------------------------------------------------------------------
.\01SetupEnv.ps1

# Text Driver
# databases.txt 檔案內容如下：
# AdventureWorks
# Northwind
Push-Location
# 呈現檔案內每一行的內容
get-Content ($scriptPath + "databases.txt") | foreach {write-Host "操作資料庫 " $_ }
# 例如，使用 SQL 2008 提供的 Provider，表列資料庫內的資料表
get-Content ($scriptPath + "databases.txt") | foreach `
{CD sqlserver:\sql\$machineName\$instanceName\databases\$_\tables; `
write-Host "資料庫內的資料表： " $_ ; DIR | MORE;}
Pop-Location

#  透過 XML Driver 讀取 XML 文檔內容
$doc = [xml]( get-Content ($scriptPath + "Objects.xml") )
# 透過 XML DOM 取得節點內容：
($doc).SelectNodes('//servers/server[@servername="SQL2K8"]/databases')
# 透過 XML DOM 取得節點內容：
($doc).SelectNodes('//servers/server[@servername="SQL2K8"]/databases/database[@databasename="AdventureWorks"]/table')
# 遞迴表列節點...
foreach ($database in $doc.SelectNodes("//servers/server/databases/database")) {$database.databasename}

-------------------------------------------------------------------
--範例程式碼5-5：宣告自訂函數
-------------------------------------------------------------------
# 函數搭配參數
Function objectPath {"路徑為" + $args[0]  + "`\" +  $args[1] }
# 呼叫函數，因為如同一般命令，所以參數間不以逗號分隔
objectPath a b

Function objectPath2 ($x, $y)
{
    $ObjectPath = $x + "`\" + $y
    write-Host "路徑為 $ObjectPath"
}
objectPath a b

# 函數使用 "param"
# param 的宣告必須在第一行，在它之前只能有空白或註解
Function objectPath3
{
    param ($x, $y)
    $ObjectPath = $x + "`\" + $y
     write-Host "路徑為 $ObjectPath"   
}
objectPath3 a b

-------------------------------------------------------------------
--範例程式碼5-6：透過 System.Diagnostics.EventLog 物件執行個體將訊息寫到 Windows 事件紀錄
-------------------------------------------------------------------
# 回報紀錄機制
# 事件紀錄(Event Log)
Function log_This 
{
	$log = New-Object System.Diagnostics.EventLog('Application') 
	$log.set_source($log_ApplicationName)
	$log.WriteEntry($log_Message)
}
# 範例 - 呼叫函數傳遞內容時，不用參數只用變數
$log_ApplicationName = "自訂的應用程式名稱"
$log_Message = "輸入需要記錄的資訊"
# 呼叫函數，你可以用系統的事件檢視器檢視結果
log_This

# 讀取事件紀錄：
get-Eventlog application | where-Object {$_.Message -eq "輸入需要記錄的資訊"}
get-Eventlog application | where-Object {$_.source -eq "自訂的應用程式名稱"}

# 清除所有的事件紀錄 - 要小心使用!
# get-EventLog -list | % {$_.Clear()}

-------------------------------------------------------------------
--範例程式碼5-7：將 PowerShell 的執行結果以各種方式輸出
-------------------------------------------------------------------
# 錯誤處理
Function handle_This ($appName)
 {
	# 建立錯誤訊息字串
	$log_Message = "Error Category: " + $error[0].CategoryInfo.Category 
	$log_Message = $log_Message + ". 執行的物件：" + $error[0].TargetObject 
	$log_Message = $log_Message + " 錯誤訊息：" + $error[0].Exception.Message 
	$log_Message = $log_Message + " 錯誤訊息： " + $error[0].FullyQualifiedErrorId 
	write-Host "錯誤發生於 " $appName "`! 檢查事件紀錄，以取得更多資訊"
	
	# 自動傳送訊息給先前撰寫的 Logging 函數：
	$log_ApplicationName = $appName
	log_This
}

# 錯誤處理範例，執行某項工作
Function ErrorHappensHere
{ 
	SomeFun #沒有這個指令或函數，所以發生錯誤
	Trap {
			# 進入錯誤處理
			handle_This "SomeFun"
			# 若發生錯誤後，就停下來，可以使用 break
			# break;
			# 或是繼續進行
			continue;
			}
}

# 呼叫上述會發生錯誤的函數
ErrorHappensHere

write-Host "檢查事件紀錄"
# Check the error
get-Eventlog application | where-Object {$_.Message -like "Error*"} 
write-Host "完成錯誤輸出"

# 透過電子郵件寄發訊息
Function mail_This ($mail_From, $mail_To, $mail_Subject, $mail_Body, $mail_Attachment)
{
	# 簡易的電子郵件設定
	# $smtp = new-object Net.Mail.SmtpClient("localhost") 
	# $smtp.Send($mail_From, $mail_To, $mail_Subject, $mail_Body)

	$smtpServer = "localhost" 
	$msg = new-object Net.Mail.MailMessage
	$att = new-object Net.Mail.Attachment([string]$mail_Attachment)
	$smtp = new-object Net.Mail.SmtpClient $smtpServer 
	$msg.From =$mail_From
	$msg.To.Add($mail_To)
	$msg.Subject = $mail_Subject
	$msg.Body = $mail_Body
	$msg.Attachments.Add($att) 
	$smtp.Send($msg)
} 
mail_This "PowerShell@localhost" "Someone@localhost" "來自 PowerShell 的通知" "測試從 PowerShell 發送電子郵件" "C:\PowerShellScript\myLog.log" 

# System Tray "Balloons"
Function balloon_This ($balloon_Title, $balloon_Text)
{
	[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
	$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
	$objNotifyIcon.Icon =  "C:\PowerShellScript\myLogIcon.ICO"
	$objNotifyIcon.BalloonTipIcon = "Info"
	# Info, Warning, Error 
	$objNotifyIcon.BalloonTipTitle = $balloon_Title
	$objNotifyIcon.BalloonTipText = $balloon_Text 
	$objNotifyIcon.Visible = $True 
	$objNotifyIcon.ShowBalloonTip(10000)
 }
 balloon_This "注意！！" "要開始做些事情。事情進行時，可以透過此傳送些訊息，酷吧！"
 
# 轉成 HTML 檔案輸出
Function web_This ($web_Title)
{
		# 以一些 CSS styles 當作 HTML Header
		$formatHTML = "<style>"
		$formatHTML = $formatHTML + "BODY{background-color:white;color:black}"
		$formatHTML = $formatHTML + "TABLE{border-width: 1px;border-style: solid;border-color: blue;border-collapse: collapse;}"
		$formatHTML = $formatHTML + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:white}"
		$formatHTML = $formatHTML + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:white}"
		$formatHTML = $formatHTML + "</style>"
		# 將系統當下執行的 Process 狀態以 HTML 格式輸出 
		Get-Process | ConvertTo-Html -head $formatHTML –title $web_Title | Out-File ("c:\PowerShellScript\" + $web_Title + ".htm")
}
web_This "ProcessDetail"


Function WriteFile($Msg)
{
	$sw = New-Object System.IO.StreamWriter "C:\PowerShellScript\myLog.log",True 
	$sw.WriteLine($Msg)
	$sw.Close()
}

WriteFile("Hello Msg")


-------------------------------------------------------------------
--範例程式碼5-8：整合 SQL 2008 提供 PowerShell 的 Add-in 執行結果以各種方式輸出
-------------------------------------------------------------------
# 你可以結合前一段範例，將下述的結果轉成網頁，或是透過電子郵件寄送...
write-Host "
==================================================================
使用  SQL 2008 的 Provider，執行 T-SQL 查詢語法"
CD sqlserver:\sql\$machineName\$instanceName\databases\master\
invoke-SQLCMD -Query "SELECT @@VERSION"

write-Host "
==================================================================
呈現使用者定義大過某個紀錄數量的資料表列表"
CD sqlserver:\sql\$machineName\$instanceName\databases\AdventureWorks\tables
DIR | where-Object {$_.RowCount -gt 10000} | sort-Object -property RowCount | select-Object Name, RowCount

write-Host "
==================================================================
檢查備份的時間"
CD SQLSERVER:\SQL\$machineName\$instanceName\Databases
DIR | WHERE {((get-date)-($_.LastBackupDate)).days -gt 1} | sort-Object -property LastBackupDate | select-Object LastBackupDate, Name

write-Host "
==================================================================
備份資料庫"
CD sqlserver:\sql\$machineName\$instanceName\databases\
DIR | %{[string]$_.Name + ' 最後備份日期：' + $_.LastBackupDate}
DIR | where{ (((get-date)-($_.LastBackupdate)).days -gt 1) -and $_.name -eq "Northwind"} | `
%{$dbname= $_.Name;write-host "$dbname"; $_.Refresh(); 
invoke-sqlcmd -Server "$machineName\$instanceName"  -query "BACKUP DATABASE [$dbname] TO  DISK = N'C:\PowerShellScript\temp\$dbname.bak' WITH INIT";}

write-Host "
==================================================================
檢查 SQL Error Logs，轉成 HTML"
# 可以參照 03Feedback.ps1 內容：
# web_This "SQLErrors"
(get-item SQLSERVER:\SQL\$machineName\$instanceName).ReadErrorLog() | `
where {$_.Text -like "Start*"} | ConvertTo-Html -property LogDate, ProcessInfo, Text `
-body "執行個體： $machineName\$instanceName" -title "SQL Server Error Logs" | `
Out-File C:\PowerShellScript\temp\SQLErrors.htm -Append

write-Host "
==================================================================
比較資料庫物件的 Scripts" 
CD SQLSERVER:\SQL\$machineName\$instanceName\Databases\AdventureWorks\Tables
# 將資料表的定義寫入檔案中
(get-item HumanResources.Employee).Script() | out-File C:\PowerShellScript\temp\before.sql
# Time passes, table changes
# 可能會需要更新一下物件定義
# (get-item HumanResources.Employee).Refresh()
invoke-SQLCMD -InputFile C:\PowerShellScript\temp\DropCreateHumanResourcesEmployee.sql
# 建立資料表的 T-SQL Script 到檔案中
(get-item HumanResources.Employee2).Script() | out-File C:\PowerShellScript\temp\after.sql
# 比較兩個檔案內容的異同
compare-object (get-content C:\PowerShellScript\temp\before.sql) (get-content C:\PowerShellScript\temp\after.sql) | out-File C:\PowerShellScript\temp\CompareResult.txt

-------------------------------------------------------------------
--範例程式碼5-9：經由ADO.NET、SMO、WMI 等物件，存取SQL Server資料或操控服務
-------------------------------------------------------------------
write-Host "
==================================================================
透過 .NET SQL Native Client 連接到 SQL Server 並取得記錄"
$sqlConnection = new-object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = "Data Source=$machineName;Initial Catalog=AdventureWorks;Integrated Security=True"
$sqlConnection.Open()
$sqlCommand = new-object System.Data.SqlClient.SqlCommand
$sqlCommand.CommandText="select top 5 ContactID, FirstName, LastName, EmailAddress, Phone from Person.Contact"
$sqlCommand.Connection=$sqlConnection
$sqlreader = $sqlCommand.ExecuteReader() 
while ($sqlReader.Read()) { $sqlReader["FirstName"] + " " + $sqlReader["LastName"]}
$sqlreader.Close()

write-Host "
==================================================================
繼續將資料放入 ADO.NET 的 DataSet"
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $sqlCommand
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$SqlConnection.Close()
$DataSet.Tables[0]
# 將資料直接轉成字串輸出
$DataSet.Tables[0] | Foreach-Object { [string]$_.ContactID + ": " + $_.FirstName + ", " + $_.LastName + ", " + $_.EmailAddress }

write-Host "
==================================================================
利用 SMO 執行命令 - 以紀錄筆數排名，取前十名的資料表"
#[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
$sqlServer = new-object ("Microsoft.SqlServer.Management.Smo.Server") "$machineName"
# 表列所有的資料庫
foreach($sqlDatabase in $sqlServer.databases) {$sqlDatabase.name}
# 檢視可以操作的物件屬性方法
$sqlServer | get-member | ConvertTo-Html -property Name, MemberType, Definition -body "Microsoft.SqlServer.Management.Smo.Server 類別" -title "Smo.Server 類別的屬性方法" | Out-File C:\PowerShellScript\temp\SmoServer.htm
# 將前十名的資料表名稱輸出到檔案
$sqlServer.Databases["AdventureWorks"].Tables | sort -property rowcount -desc | Select-Object -First 10 | Format-Table schema, name, rowcount -AutoSize | out-File C:\PowerShellScript\temp\TopTenTables.txt

write-Host "
==================================================================
利用 WMI - 設定或取得 Windows 服務"
get-content C:\PowerShellScript\servers.txt | foreach {
$class = Get-WmiObject -computername $_ -namespace root\Microsoft\SqlServer\ComputerManagement10 -class SqlService
   foreach ($classname in $class)
   {write-host "SQL Server 相關服務：" $_ " : "$classname.DisplayName}
}
# 可以做的範例語法：
# 停掉服務
# stop-service -displayName $classname.DisplayName
# 設定服務帳號
# $classname.SetServiceAccount(“Account Name", “New Password")
# 啟動服務
# start-service -displayName $classname.DisplayName

-------------------------------------------------------------------
--範例程式碼5-10：透過指令碼呼叫 SQL Server SMO 物件，備份執行個體內的資料庫
-------------------------------------------------------------------
# 05backup.ps1
# 對指定的伺服器執行個體內，所有使用者資料庫先做完整備份，
# 再進行交易紀錄備份

[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SmoExtended') | out-null

Function Backup($ServerInstance)
{
$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') "$ServerInstance"
$bkdir = $s.Settings.BackupDirectory
$dbs = $s.Databases
$dbs | foreach-object {
	$db = $_
	if ($db.IsSystemObject -eq $False -and $db.IsMirroringEnabled -eq $False) {
		$dbname = $db.Name
		Write-Host "備份資料庫 $dbname"
		$dt = get-date -format yyyyMMddHHmmss
		$dbbk = new-object ("Microsoft.SqlServer.Management.Smo.Backup")
		$dbbk.Action = "Database"
		$dbbk.BackupSetDescription = $dbname + " 的完整備份"
		$dbbk.BackupSetName = $dbname + " Backup"
		$dbbk.Database = $dbname
		$dbbk.MediaDescription = "Disk"
		$FileName=$bkdir + "\" + $dbname + "_db_" + $dt + ".bak" 
		$dbbk.Devices.AddDevice($FileName, "File")
		$dbbk.SqlBackup($s)
		# 若 Recovery Model 是 Simple ，則 Value 屬性值是 3
		if ($db.recoverymodel.value__ -ne 3) {
			$dt = get-date -format yyyyMMddHHmmss
			$dbtrn = new-object ("Microsoft.SqlServer.Management.Smo.Backup")
			$dbtrn.Action = "Log"
			$dbtrn.BackupSetDescription = $dbname + " 的交易紀錄備份"
			$dbtrn.BackupSetName = $dbname + " Backup"
			$dbtrn.Database = $dbname
			$dbtrn.MediaDescription = "Disk"
			$dbtrn.Devices.AddDevice($bkdir + "\" + $dbname + "_tlog_" + $dt + ".trn", "File")
			$dbtrn.SqlBackup($s)
			}
		}
	}
}

# 以互動的方式詢問需要備份的SQL Server 執行個體
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | out-null
$Instance=[Microsoft.VisualBasic.Interaction]::InputBox("請輸入需要備份的 SQL Server 執行個體","執行個體名稱","localhost")
Backup $Instance

