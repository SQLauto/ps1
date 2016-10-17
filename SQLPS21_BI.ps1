﻿<#

foreach ($ps1f in $ps1fS)
{
    start-sleep 1
    $ps1fname=$ps1f.name
    $ps1fFullname=$ps1f.FullName 
    $ps1flastwritetime=$ps1f.LastWriteTime
    $getdagte= get-date -format yyyyMMdd
    $ps1length=$ps1f.Length

    Send-MailMessage -SmtpServer  '172.16.200.27'  -To 'a0921887912@gmail.com' -from 'a0921887912@gmail.com' `
    -attachment $ps1fFullname  -Subject "ps1source  -- $getdagte      --        $ps1fname       --   $ps1flastwritetime -- $ps1length "  -Body "  ps1source from:me $ps1fname   " 
}
#  230  SQL Server Analysis Services 教學課程
#  309  Using powerPivot  in excel 2013
#  333  Using power view
#  385   Troubleshooting    SSAS startup failure
#  396    SSISDB 目錄
#  407    SSIS configuration  deploy package   Dtutil 
#  474    SSIS run  package   Dtexec  log
#  575    SSDT for VS2013



#---------------------------------------------------------------
#  27 Analysis Services PowerShell


get-module SQLPS

#啟用遠端管理
   (1)在裝載 Analysis Services 執行個體的遠端伺服器上，於 Windows 防火牆中開啟 TCP 通訊埠 2383。
   將 Analysis Services 安裝成具名執行個體或者正在使用自訂通訊埠，此通訊埠編號將會不同

   telnet pmd2016 2383
   
   (2)遠端伺服器上，確認下列服務已啟動：

   遠端程序呼叫 (RPC) 服務、
   TCP/IP NetBIOS Helper 服務、
   Windows Management Instrumentation (WMI) 服務、
   Windows 遠端管理 (WS-Management) 服務。

   在具有用戶端工具的本機電腦上，使用下列指令程式來確認遠端管理，並以實際的伺服器名稱取代 remote-server-name 預留位置。如果 Analysis Services 安裝成預設執行個體，請省略執行個體名稱。您先前必須匯入 SQLPS 模組，才能讓此命令運作
   
   
   PS SQLSERVER:\>    cd sqlas
   'PS SQLSERVER:\sqlas> ls

    Host Name                                                                       
    ---------                                                                       
    HTTP_DS                                                                         
    PMD2016  '
   

   cd pmd2016 ;ls
   'PS SQLSERVER:\sqlas\pmd2016> ls

    Instance Name                                                                   
    -------------                                                                   
    SSASMD                                                                          
    SSASTR'

    cd SSASMD
    ls
    PS SQLSERVER:\sqlas\pmd2016>  
    'PS SQLSERVER:\sqlas\pmd2016\SSASMD>     ls
    Collections                                                                     
    -----------                                                                     
    Assemblies                                                                      
    Databases                                                                       
    Roles                                                                           
    Traces     '
    
    cd sqlserver:\  ; ls
    
    Get-PSDrive

   (3)



#連接到 Analysis Services 物件

    Analysis Services 的原生連接
     Provide Root  = >  SQLSERVER:\
     SQLAS  (延伸模組)
     CONNECTION(連接): MACHINE\INSTANCE 
     CONTAINS(容器)  : databases
      


#管理服務

確認服務正在執行。傳回 SQL Server 服務的狀態、名稱和顯示名稱，包括 Analysis Services (MSSQLServerOLAPService) 和 Database Engine。

gsv |? DisplayName -like *sql*

gsv 'MSOLAP$SSASMD' |select *
'
Name                : MSOLAP$SSASMD
RequiredServices    : {}
CanPauseAndContinue : True
CanShutdown         : False
CanStop             : True
DisplayName         : SQL Server Analysis Services (SSASMD)
DependentServices   : {}
MachineName         : .
ServiceName         : MSOLAP$SSASMD
ServicesDependedOn  : {}
ServiceHandle       : SafeServiceHandle
Status              : Running
ServiceType         : Win32OwnProcess
Site                : 
Container           : '

Get-process msmdsrv


CommandType     Name                                               ModuleName                                                                                                        
-----------     ----                                               ----------                                                                                                        
Cmdlet          Add-RoleMember                                     SQLASCMDLETS                                                                                                      
Cmdlet          Backup-ASDatabase                                  SQLASCMDLETS                                                                                                      
Cmdlet          Invoke-ASCmd                                       SQLASCMDLETS                                                                                                      
Cmdlet          Invoke-ProcessCube                                 SQLASCMDLETS                                                                                                      
Cmdlet          Invoke-ProcessDimension                            SQLASCMDLETS                                                                                                      
Cmdlet          Invoke-ProcessPartition                            SQLASCMDLETS                                                                                                      
Cmdlet          Merge-Partition                                    SQLASCMDLETS                                                                                                      
Cmdlet          New-RestoreFolder                                  SQLASCMDLETS                                                                                                      
Cmdlet          New-RestoreLocation                                SQLASCMDLETS                                                                                                      
Cmdlet          Remove-RoleMember                                  SQLASCMDLETS                                                                                                      
Cmdlet          Restore-ASDatabase                                 SQLASCMDLETS                                                                                                      
'
#    187 invoke-ascmd
#---------------------------------------------------------------
讓資料庫管理員能夠針對 Microsoft SQL Server Analysis Services 執行個體執行 XMLA 指令碼、多維度運算式 (MDX) 查詢或資料採礦延伸 (DMX) 陳述式。

Invoke-ASCmd -Server:pmd2016\ssasmd `
-Query:"<Discover xmlns='urn:schemas-microsoft-com:xml-analysis'><RequestType>DBSCHEMA_CATALOGS</RequestType><Restrictions /><Properties /></Discover>" 

#---------------------------------------------------------------
#  204  Backup  & restore ASDatabase
#---------------------------------------------------------------
Import-Module  'C:\Program Files (x86)\Microsoft SQL Server\120\Tools\PowerShell\Modules\SQLPS' -DisableNameChecking
ls SQLSERVER:\SQLAS
ls SQLSERVER:\SQLAS\PMD2016\SSASMD\Databases
(ls SQLSERVER:\SQLAS\PMD2016\SSASMD\Databases).name

ls SQLSERVER:\SQLAS\PMD2016\SSASMD\Assemblies

    
Get-help backup-ASDatabase -Examples
#  230  SQL Server Analysis Services 教學課程
#---------------------------------------------------------------

Status   Name               DisplayName                           
------   ----               -----------                           
Running  MSOLAP$SSASMD      SQL Server Analysis Services (SSASMD) 
Running  MSOLAP$SSASTR      SQL Server Analysis Services (SSASTR) 
Running  MSSQL$SSDE         SQL Server (SSDE)                     
Stopped  MSSQL$SSDW         SQL Server (SSDW)                     
Stopped  SQLAgent$SSDE      SQL Server Agent (SSDE)               
Stopped  SQLBrowser         SQL Server Browser                    
Running  SQLWriter          SQL Server VSS Writer '
Lesson 3: Modifying Measures, Attributes and Hierarchies
Lesson 4: Defining Advanced Attribute and Dimension Properties
Lesson 5: Defining Relationships Between Dimensions and Measure Groups
Lesson 6: Defining Calculations
Lesson 7: Defining Key Performance Indicators (KPIs)
Lesson 8: Defining Actions
Lesson 9: Defining Perspectives and Translations
Lesson 10: Defining Administrative Roles



Lesson 1: Defining a Data Source View within an Analysis Services Project
DimCustomer (dbo)
DimDate (dbo)
DimGeography (dbo)
DimProduct (dbo)
FactInternetSales (dbo)
Defining a Dimension
Defining a Cube
Adding Attributes to Dimensions
Reviewing Cube and Dimension Properties
Deploying an Analysis Services Project
'
C:\Users\infra1\Documents\Visual Studio 2013\projects\Analysis Services Tutorial\Analysis Services Tutorial\bin
Analysis Services Tutorial.asdatabase
Analysis Services Tutorial.configsettings
Analysis Services Tutorial.deploymentoptions
Analysis Services Tutorial.deploymenttargets
'


Browsing the Cube
#>}
#  309 Using powerPivot 
#---------------------------------------------------------------
#  333 Using power view
#---------------------------------------------------------------
#  385 Troubleshooting    SSAS startup failure
#---------------------------------------------------------------
此帳戶的密碼已到期。

若要確保正確設定該服務，請使用 Microsoft Management Console (MMC) 中的 [服務] 嵌入式管理單元。
#  396    SSISDB 目錄
#---------------------------------------------------------------
select * from catalog.folders

SELECT * FROM catalog.projects;
SELECT * FROM catalog.packages;

SELECT * FROM catalog.environments;                 /*已設定的環境*/
SELECT * FROM catalog.environment_variables;        /*環境中的變數*/
SELECT * FROM catalog.environment_references;


SELECT * FROM catalog.operations; 
 select * from msdb.dbo.sysssispackagefolders
#  407    SSIS configuration  deploy package   Dtutil 
#---------------------------------------------------------------
<?xml version="1.0" encoding="utf-8"?>
<DtsServiceConfiguration xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <StopExecutingPackagesOnShutdown>true</StopExecutingPackagesOnShutdown>
  <TopLevelFolders>
    <Folder xsi:type="SqlServerFolder">
      <Name>MSDB</Name>
      <ServerName>.</ServerName>   #<-- 決定了 SSIS 存取位於本地上的那一個　instance 
    </Folder>
    <Folder xsi:type="FileSystemFolder">
      <Name>File System</Name>
      <StorePath>..\Packages</StorePath>  #<--FileSystem  path   C:\Program Files\Microsoft SQL Server\120\DTS\Packages
    </Folder>
  </TopLevelFolders>
</DtsServiceConfiguration>
Version 12.0.2000.8 for 64-bit
Copyright (C) Microsoft Corporation 2014. 著作權所有，並保留一切權利。


使用方式: DTUtil /option [value] [/option [value]] ...
選項不區分大小寫。
連字號 (-) 可以用來取代斜線 (/)。
分隔號 (|) 是 OR 運算子，用於列出可能的值。
如需擴充說明，請使用 /help 配合選項。例如: DTUtil /help Copy

/C[opy]             {SQL | FILE | DTS};路徑
/Dec[rypt]          密碼
/Del[ete]
/DestP[assword]     密碼
/DestS[erver]       伺服器
/DestU[ser]         使用者名稱
/DT[S]              PackagePath
/Dump               處理序識別碼
/En[crypt]          {SQL | FILE | DTS};路徑;ProtectionLevel[;密碼]
/Ex[ists]
/FC[reate]          {SQL | DTS};ParentFolderPath;NewFolderName
/FDe[lete]          {SQL | DTS};ParentFolderPath;FolderName
/FDi[rectory]       {SQL | DTS}[;FolderPath[;S]]
/FE[xists]          {SQL | DTS};FolderPath
/FR[ename]          {SQL | DTS};ParentFolderPath;OldFolderName;NewFolderName
/Fi[le]             Filespec
/H[elp]             [選項]
/I[DRegenerate]
/M[ove]             {SQL | FILE | DTS};路徑
/Q[uiet]
/R[emark]           [Text]
/Si[gn]             {SQL | FILE | DTS};路徑;雜湊
/SourceP[assword]   密碼
/SourceS[erver]     伺服器
/SourceU[ser]       使用者名稱
/SQ[L]              PackagePath'
SSIS 支援兩種部署模型：

專案部署模型（project deployment model）：透過「專案部署精靈」將 SSIS 專案部署到 SSISDB 目錄。
        (1) 由 SSDT 開發環境，直接叫用部署功能  有個叫 專案部署檔案 (副檔名 .ispac) 是在
        (2) 由 SSMS 中，在 SSISDB 目錄中，先建立Folder , then <Project>    執行部署功能 use <部署精靈>
封裝部署模型（package deployment model）：將封裝檔案安裝到 Integration Service 伺服器的檔案系統或 SQL Server 的執行個體。
#  474    SSIS run  package   Dtexec  log
#---------------------------------------------------------------
PS SQLSERVER:\> Dtexec /?
Microsoft (R) SQL Server 執行封裝公用程式
Version 12.0.2000.8 for 64-bit
Copyright (C) Microsoft Corporation. 著作權所有，並保留一切權利。

使用方式: DTExec /option [value] [/option [value]] ...
選項不區分大小寫。
連字號 (-) 可以用來取代斜線 (/)。
/Ca[llerInfo]
/CheckF[ile]        [Filespec]
/Checkp[ointing]    [{On | Off}] (On 是預設值)
/Com[mandFile]      Filespec
/Conf[igFile]       Filespec
/Conn[ection]       IDOrName;ConnectionString
/Cons[oleLog]       [[DispOpts];[{E | I};List]]
                    DispOpts = N、C、O、S、G、X、M 或 T 的其中一個或多個。
                    List = {EventName | SrcName | SrcGuid}[;List]
/De[crypt]          密碼
/DT[S]              PackagePath
/Dump               code[;code[;code[;...]]]
/DumpOnErr[or]
/Env[Reference]     SSIS 目錄中環境的識別碼
/F[ile]             Filespec
/H[elp]             [選項]
/IS[Server]         SSIS 目錄中封裝的完整路徑
/L[ogger]           ClassIDOrProgID;ConfigString
/M[axConcurrent]    ConcurrentExecutables
/Pack[age]          在專案內部執行的封裝
/Par[ameter]        [$Package::|$Project::|$ServerOption::]parameter_name[(data
_type)];literal_value
/P[assword]         密碼
/Proj[ect]          要使用的專案檔案
/Rem[ark]           [文字]
/Rep[orting]        Level[;EventGUIDOrName[;EventGUIDOrName[...]]
                    Level = N 或 V 或 E、W、I、C、D 或 P 的其中一個或多個。
/Res[tart]          [{Deny | Force | IfPossible}] (Force 是預設值)
/Set                PropertyPath;Value
/Ser[ver]           ServerInstance
/SQ[L]              PackagePath
/Su[m]
/U[ser]             使用者名稱
/Va[lidate]
/VerifyB[uild]      Major[;Minor[;Build]]
/VerifyP[ackageid]  PackageID
/VerifyS[igned]
/VerifyV[ersionid]  VersionID
/VLog               [Filespec]
/W[arnAsError]
/X86

PS SQLSERVER:\> 
'
$t1=get-date
dtexec.exe /f C:\SSIS\P2.dtsx
$t2=get-date; ($t2-$t1)
#  575    SSDT for VS2013
#---------------------------------------------------------------
onenote:https://d.docs.live.net/2135d796bd51c0fa/文件/SQL_W/SSIS.one#SSDT%20for%20VS2013&section-id={0376D714-B5D6-4331-9746-1CBED614BA7D}&page-id={F245D20E-50F2-4B07-AE60-7BAD21BC37E2}&end
# 1   Listing items in your SSRS Report Server  p386
#---------------------------------------------------------------
##Getting ready
Identify your SSRS 2012 Report Server URL. 
We will need to reference the ReportService2010 web service, and you can reference it using <ReportServer URL>/ReportService2010.asmx


##PS
1. Open the PowerShell console by going to Start | Accessories | Windows PowerShell | Windows PowerShell ISE.
2. Add the following script and run:
$ReportServerUri = "http://localhost/ReportServer/ReportService2010.asmx"
$proxy = New-WebServiceProxy -Uri $ReportServerUri -UseDefaultCredential
#list all children
$proxy.ListChildren("/", $true) |Select Name, TypeName, Path, CreationDate | Format-Table -AutoSize

#if you want to list only reports
#note this is using PowerShell V3 Where-Object syntax
$proxy.ListChildren("/", $true) | Where TypeName -eq "Report" | Select Name, TypeName, Path, CreationDate | Format-Table -AutoSize


#---------------------------------------------------------------
# 2   Listing SSRS report properties   p388
#---------------------------------------------------------------

##PS
(1).Open the PowerShell console by going to Start | Accessories | Windows
PowerShell | Windows PowerShell ISE.
(2). Add the following script and run:
$ReportServerUri = "http://localhost/ReportServer/
ReportService2010.asmx"
$proxy = New-WebServiceProxy -Uri $ReportServerUri -UseDefaultCredential
$reportPath = "/Customers/Customer Contact Numbers"
#using PowerShell V3 Where-Object syntax
$proxy.ListChildren("/", $true) | Where-Object Path -eq $reportPath


#---------------------------------------------------------------
# 3   Using ReportViewer to view your SSRS report   391
#---------------------------------------------------------------

##Getting Ready
'
First, you need to download ReportViewer redistributable and install it on your machine.
At the time of writing of this book, the download link is at:
'
http://www.microsoft.com/en-us/download/details.aspx?id=6442
'Identify your SSRS 2012 Report Server URL. We will need to reference the
ReportService2010 web service, and you can reference it using:
'
<ReportServer URL>/ReportService2010.asm
Pick a report you want to display using the ReportViewer control. Identify the full path, and
replace the value of the variable $reportViewer.ServerReport.ReportPath in the script.

##

(2). Load the assembly for ReportViewer as follows:
#load the ReportViewer WinForms assembly
Add-Type -AssemblyName "Microsoft.ReportViewer.WinForms,Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
#load the Windows.Forms assembly
Add-Type -AssemblyName "System.Windows.Forms"
(3). Add the following script and run:
$reportViewer = New-Object Microsoft.Reporting.WinForms.
ReportViewer
$reportViewer.ProcessingMode = "Remote"
$reportViewer.ServerReport.ReportServerUrl = "http://localhost/
ReportServer"
$reportViewer.ServerReport.ReportPath = "/Customers/Customer
Contact Numbers"
#if you need to provide basic credentials, use the following
#$reportViewer.ServerReport.ReportServerCredentials.
NetworkCredentials= New-Object System.Net.
NetworkCredential("sqladmin", "P@ssword");
$reportViewer.Height = 600
$reportViewer.Width = 800
$reportViewer.RefreshReport()
#create a new Windows form
$form = New-Object Windows.Forms.Form
#we're going to make the form just slightly bigger
#than the ReportViewer
$form.Height = 610
$form.Width= 810
#form is not resizable
$form.FormBorderStyle = "FixedSingle"
#do not allow user to maximize
$form.MaximizeBox = $false
$form.Controls.Add($reportViewer)
#show the report in the form
$reportViewer.Show()
#show the form
$form.ShowDialog()



#---------------------------------------------------------------
# 4  150  Downloading an SSRS report in Excel and PDF  p396
#---------------------------------------------------------------

2. Load the ReportViewer assembly:
Add-Type -AssemblyName "Microsoft.ReportViewer.WinForms,
Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080
cc91"
3. Add the following script and run:
$reportViewer = New-Object Microsoft.Reporting.WinForms.
ReportViewer
$reportViewer.ProcessingMode = "Remote"
$reportViewer.ServerReport.ReportServerUrl = "http://localhost/
ReportServer"
$reportViewer.ServerReport.ReportPath = "/Customers/Customer
Contact Numbers"
#required variables for rendering
$mimeType = $null
$encoding = $null
$extension = $null
$streamids = $null
$warnings = $null
#export to Excel
$excelFile = "C:\Temp\Customer Contact Numbers.xls"
$bytes = $reportViewer.ServerReport.Render("Excel", $null,
[ref] $mimeType,
[ref] $encoding,
[ref] $extension,
[ref] $streamids,
[ref] $warnings)
$fileStream = New-Object System.IO.FileStream($excelFile, [System.IO.FileMode]::OpenOrCreate)
$fileStream.Write($bytes, 0, $bytes.Length)
$fileStream.Close()
#let's open up our Excel document
$excel = New-Object -comObject Excel.Application
$excel.visible = $true
$excel.Workbooks.Open($excelFile) | Out-Null
#export to PDF
$pdfFile = "C:\Temp\Customer Contact Numbers.pdf"
$bytes = $reportViewer.ServerReport.Render("PDF", $null,
[ref] $mimeType,
[ref] $encoding,
[ref] $extension,
[ref] $streamids,
[ref] $warnings)
$fileStream = New-Object System.IO.FileStream($pdfFile, [System.
IO.FileMode]::OpenOrCreate)
$fileStream.Write($bytes, 0, $bytes.Length)
$fileStream.Close()
#let's open up up our PDF application
[System.Diagnostics.Process]::Start($pdfFile)


#---------------------------------------------------------------
# 5  200  Creating an SSRS folder  p400
#---------------------------------------------------------------


##
2. Add the following script and run:
$ReportServerUri = "http://localhost/ReportServer/
ReportService2010.asmx"
$proxy = New-WebServiceProxy -Uri $ReportServerUri
-UseDefaultCredential
#A workaround we have to do to ensure
#we don't get any namespace clashes is to
#capture the auto-generated namespace, and
#create our objects based on this namespace
#capture automatically generated namespace
#this is a workaround to avoid namespace clashes
#resulting in using –Class with New-WebServiceProxy
$type = $Proxy.GetType().Namespace
#formulate data type we need
$datatype = ($type + '.Property')
#display datatype, just for our reference
$datatype
#create new Property
#if we were using –Class SSRS, this would be similar to
#$property = New-Object SSRS.Property
$property = New-Object ($datatype)
$property.Name = "Description"
$property.Value = "SQLSaturdays Rock! Attendees are cool!"
$folderName = "SQLSat 114 " + (Get-Date -format "yyyy-MMM-ddhhmmtt")
#Report SSRS Properties
#http://msdn.microsoft.com/en-us/library/ms152826.aspx
$numProperties = 1
$properties = New-Object ($datatype + '[]')$numProperties
$properties[0] = $property
$proxy.CreateFolder($folderName, "/", $properties)
#display new folder in IE
Set-Alias ie "$env:programfiles\Internet Explorer\iexplore.exe"
ie "http://localhost/Reports"

#---------------------------------------------------------------
#  6 Creating an SSRS data source  p404
#---------------------------------------------------------------

##
Property Value
Data source name :Sample
Data source type :SQL
Connection string :Data Source=KERRIGAN;Initial Catalog=AdventureWorks2008R2 Credentials Integrated
Parent (that is, folder where this data source will be placed; must exist already)/Data Sources

##
Add the following script and run:
$ReportServerUri = "http://localhost/ReportServer/
ReportService2010.asmx"
$proxy = New-WebServiceProxy -Uri $ReportServerUri -UseDefaultCredential
$type = $Proxy.GetType().Namespace
#create a DataSourceDefinition
$dataSourceDefinitionType = ($type + '.DataSourceDefinition')
$dataSourceDefinition = New-Object($dataSourceDefinitionType)
$dataSourceDefinition.CredentialRetrieval = "Integrated"
$dataSourceDefinition.ConnectString = "Data
Source=KERRIGAN;Initial Catalog=AdventureWorks2008R2"
$dataSourceDefinition.extension = "SQL"
$dataSourceDefinition.enabled = $true
$dataSourceDefinition.Prompt = $null
$dataSourceDefinition.WindowsCredentials = $false
#NOTE this is SSRS native mode
#CreateDataSource method accepts the following parameters:
#datasource name
#parent (data folder) – must already exist
#overwrite
#data source definition
#properties
$dataSource = "Sample"
$parent = "/Data Sources"
$overwrite = $true
$newDataSource = $proxy.CreateDataSource($dataSource, $parent, $overwrite,$dataSourceDefinition, $null)


#---------------------------------------------------------------
#  7 
#---------------------------------------------------------------

gsv -displayname *sql*

ping FC2

ping 172.16.220.161


gsv -DisplayName '*sql*'