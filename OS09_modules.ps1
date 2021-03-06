<#  20 
從  get-module -listAvailable 開始 . Powershell module是可以 延伸Powershell cmdlet , 在網路上找到許多module  一來搞清楚
C:\Users\administrator.CSD\SkyDrive\download\PS1\OS09_modules.ps1



$ps1fS=gi C:\Users\administrator.CSD\OneDrive\download\ps1\OS09_modules.ps1

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


# 01 50  $env:PSModulePath  :查詢預設模組位置
# 02 55 Get-module -listAvailable  查詢出來可用地 
# 03 80  Get-module -查詢已匯入的模組  以及模組內的指令
# 04 80 import-module-匯入的模組  &移除模組時
# 05 100    尋找模組中的命令  
# 06 110     Get  remove -psdrive   gh get-psdrive -full
# 07 120     new -psdrive
#    166     sqlpsx
# 09   275  Remote Active Directory Administration  AD module RSAT-AD-PowerShell  RSAT-AD-AdminCenter
# 
































#--------------------------------------------
#  01 50  $env:PSModulePath  :查詢預設模組位置
#--------------------------------------------
$env:PSModulePath 
C:\Users\administrator.CSD\Documents\WindowsPowerShell\Modules
;C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
;C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules\SQLPS   #有時沒有查到此,或是位置有些不對.人工找到,再直接

Import-Module  'C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules\SQLPS' -DisableNameChecking


#--------------------------------------------
# 02 55 Get-module -listAvailable  查詢出來可用地 
#--------------------------------------------
PS C:\Users\administrator.CSD> Get-module -listAvailable

ModuleType Name                      ExportedCommands                                                           
---------- ----                      ----------------                                                           
Manifest   ADRMS                     {}      C:\Windows\System32\WindowsPowerShell\v1.0\Modules                                                                   
Manifest   AppLocker                 {}                                                                         
Manifest   BestPractices             {}                                                                         
Manifest   BitsTransfer              {}                                                                         
Manifest   PSDiagnostics             {}                                                                         
Manifest   ServerManager             {}                                                                         
Manifest   TroubleshootingPack       {}                                                                         
Manifest   WebAdministration         {}                                                                         

#Manifest   SQLASCMDLETS              {}     Find at C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules\                                                                     
#Manifest   SQLPS                     {}     Find at C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules\

#--------------------------------------------
# 03  80  Get-module -查詢已匯入的模組  以及模組內的指令
#--------------------------------------------
get-module

Get-Command -Module sqlpsx

#--------------------------------------------
# 04 80 import-module-匯入的模組  &移除模組時
#--------------------------------------------
import-module <模組名稱> ,通常是資料夾名稱  #
Import-Module “sqlps” -DisableNameChecking
Import-Module WebAdministration  #Web Server (IIS) Administration Cmdlets in Windows PowerShell
#匯入不在預設模組位置的模組，請在命令中使用該模組資料夾的完整路徑
 Import-Module  'C:\Program Files (x86)\Microsoft SQL Server\120\Tools\PowerShell\Modules\SQLPS' -DisableNameChecking

import-module c:\ps-test\TestCmdlets
import-module C:\Users\administrator.CSD\Documents\WindowsPowerShell\modules\membership
remove-Module “SQLASCMDLETS"　-DisableNameChecking
remove-Module "Membership" -DisableNameChecking



#--------------------------------------------
# 05 100    尋找模組中的命令  
#--------------------------------------------
get-command -module membership

Get-command <Cmdlet 名稱> | format-list -property verb, noun, pssnapin, module
Get-command get-date | format-list -property verb, noun, pssnapin, module


#--------------------------------------------
# 06 110     Get  remove -psdrive   gh get-psdrive -full
#--------------------------------------------
Get-Psdrive  

cd env:  
dir  # you can see env:
gh Remove-PSDrive -full
cd users:
ls

remove-psdrive -name users
#--------------------------------------------
# 07  120     new - psdrive
#--------------------------------------------

$connectionStringName="Data Source=DGPAP2;Initial Catalog=aspnetdb;integrated Security=SSPI; providerName=""System.Data.SqlClient"""

$connectionStringName="Server=DGPAP2 ;Database=aspnetdb;Persist Security Info=True ;User ID=sa;Password=p@ssw0rd ; providerName=""System.Data.SqlClient"""

<add name="FBA" 
$connectionStringName = "server=2013bi; Integrated Security=SSPI;Initial Catalog=aspnetdb; providerName=""System.Data.SqlClient""" 

new-psdrive -psprovider membership -root '' -name users `
-connectionString $connectionStringName -enablePasswordReset $true -enablePasswordRetrieval $false `
-requiresQuestionAndAnswer $false -requiresUniqueEmail $false `
-maxInvalidPasswordAttempts 5 -minRequiredNonalphanumericCharacters 0 -minRequiredPasswordLength 6 `
-passwordAttemptWindow 10   `
-passwordStrengthRegularExpression "" `
-applicationName "/" `
-passwordFormat "hashed"

new-psdrive `
-psprovider membership `
-root '' `
-name users `
-connectionString "Data Source=DGPAP2;Initial Catalog=aspnetdb;Persist Security Info=True;User ID=sa;Password=p@ssw0rd; providerName=System.Data.SqlClient"`
-enablePasswordReset $true `
-enablePasswordRetrieval $false `
-requiresQuestionAndAnswer $false `
-requiresUniqueEmail $false `
-maxInvalidPasswordAttempts 5 `
-minRequiredNonalphanumericCharacters 0  `
-minRequiredPasswordLength 6 `
-passwordAttemptWindow 10   `
-passwordStrengthRegularExpression "" `
-applicationName "/" `
-passwordFormat "hashed"

Get-Psdrive users

new-item users:/myNewUserName -email 'myNewUser@null.com' -password 'myNewUserPassword123'
get-item users:q1
dir

## remove-psdrive faillure;  
remove-psdrive to terminate the connection, you could try :  Net use * /delete /y

#--------------------------------------------
# 07  166     sqlpsx  sqlise
#--------------------------------------------

## download
http://sqlpsx.codeplex.com/

<Manual Installation>
Download SQLPSX_2.3.2.1 (SQLPSX)
Unblock and unzip SQLPSX_2.3.2.1 zip file
Copy the modules to My Documents\WindowsPowerShell\Modules\. For example adoLib should be copied to My Documents\WindowsPowerShell\Modules\adoLib
Verify modules are available bye typing 
   get-module -listAvailable
Import modules:
import-module adolib
import-module SQLServer
import-module Agent
import-module Repl
import-module SSIS
import-module SQLParser
import-module Showmbrs
import-module SQLMaint
import-module SQLProfiler
import-module PerfCounters
PBM module should be sourced in sqlps mini-shell:
. ./pbm.psm1
Add import-module commands to your Profile if desired

## import-module
import-module SQLPSX
import-module

copy to here SQL... Not work>
C:\Program Files (x86)\Microsoft SQL Server\120\Tools\PowerShell\Modules\sqlpsx\sqlpsx.psm1 檔案無法載入。
檔案 C:\Program Files (x86)\Microsoft SQL Server\120\Tools\PowerShell\Modules\sqlpsx\SQLPSX.psm1 未經數位簽署。您無法在目前的系統上執行此指令碼。如需有關執行指令碼及設定執行原則的詳細資訊
whoami

copy to here just workabout
C:\Users\Administrator\Documents\WindowsPowerShell\Modules\  #原先沒有此folder 在執行後新增之

$env:PSModulePath 

<#
ii C:\Users\Administrator\Documents\WindowsPowerShell\Modules
;C:\Program Files\WindowsPowerShell\Modules
;C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
;C:\Program Files (x86)\Microsoft SQL Server\120\Tools\PowerShell\Modules\
#>
$env:psmodulepath
<#

ii C:\Users\administrator.CSD\Documents\WindowsPowerShell\Modules
;C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
;C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules\SQLPS
#>
Get-Module -ListAvailable
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy AllSigned

Get-ExecutionPolicy
##
Get-Command -Module sqlpsx

Get-Command -Module sqlps


use  SQLPSX.msi use appwiz.cpl also exist

Get-Module
<#
ModuleType Version    Name                                ExportedCommands     
---------- -------    ----                                ----------------     
Script     0.0        adolib                              {Invoke-Bulkcopy, ...
Script     1.0        Agent                               {Get-AgentAlert, G...
Script     1.0.0.0    ISE                                 {Get-IseSnippet, I...
Manifest   3.1.0.0    Microsoft.PowerShell.Management     {Add-Computer, Add...
Manifest   3.0.0.0    Microsoft.PowerShell.Security       {ConvertFrom-Secur...
Manifest   3.1.0.0    Microsoft.PowerShell.Utility        {Add-Member, Add-T...
Script     1.0        Repl                                {Get-ReplArticle, ...
Script     1.0        Showmbrs                            {Get-GroupUser, Ge...
Script     1.0        SQLmaint                            {Add-SqlDatabase, ...
Script     0.0        SQLPSX                                                   
Script     0.0        SQLServer                           {Add-SqlDatabase, ...
Script     1.0        SSIS                                {Copy-ISItemFileTo...

#>

Get-Command -Module SQLServer

(Get-Command Invoke-Sqlcmd).ModuleName

gcm | ? name -like invoke-sqlcm*

get-sqlversion  $env:computername
get-help get-sqlversion  -Full

Get-SqlConnection -sqlserver $env:computername
Get-SqlServer $env:computername

Remove-Module SQLServer



#--------------------------------------------
# 09   275  Remote Active Directory Administration  AD module RSAT-AD-PowerShell  RSAT-AD-AdminCenter
#--------------------------------------------
 Active Directory Module for  :Active Directory Domain Services (AD DS) or Active Directory Lightweight Directory Services (AD LDS) role

 Get-module -listAvailable
#1
 Import-Module ServerManager #  can install individual features by name using the Add- Windowsfeature cmdlet.
#2
Get-WindowsFeature  RSAT-AD-PowerShell,RSAT-AD-AdminCenter
<#

Display Name                                            Name                       Install State
------------                                            ----                       -------------
            [ ] Active Directory 管理中心               RSAT-AD-AdminCenter            Available
            [ ] Windows PowerShell 的 Active Director... RSAT-AD-PowerShell             Available#>
#3
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter
<#
Success Restart Needed Exit Code      Feature Result                               
------- -------------- ---------      --------------                               
True    No             Success        {Active Directory 管理中心, Windows PowerShell...
警告: 未啟用 Windows 自動更新。為確保系統可自動更新您新安裝的角色或功能，請開啟 [Windows Update]。#>
#4 
$x=Get-Command 
$x.Count  # 1948   ; 220.216

Get-Command | ? name -Like get-ad*


#--------------------------------------------
# 321  sharepoint  add-in  
#--------------------------------------------

Get-PSSnapin
'
Name        : Microsoft.PowerShell.Core
PSVersion   : 4.0
Description : 
'
Add-PSSnapin "Microsoft.SharePoint.PowerShell" 


Get-PSSnapin  # add  Microsoft.SharePoint.PowerShell
'
Name        : Microsoft.PowerShell.Core
PSVersion   : 4.0
Description : 

Name        : Microsoft.SharePoint.PowerShell
PSVersion   : 1.0
Description : Register all administration Cmdlets for Microsoft SharePoint Server
'


#--------------------------------------------
#
#--------------------------------------------
get-help Get-SqlServer -Full
gcm | ? name -Like *sql*
gcm | ? name -eq Get-SqlServer
<#
CommandType     Name                                               ModuleName                                                                  
-----------     ----                                               ----------                                                                  
Function        Get-SqlServer                                      SQLServer                                                                   
Function        Get-SqlServer                                      SQLmaint
#>

gcm -Module sqlserver
<#
PS SQLSERVER:\> gcm -Module sqlserver

CommandType     Name                                               ModuleName                                                                  
-----------     ----                                               ----------                                                                  
Alias           Get-Information_Schema.Columns                     SQLServer                                                                   
Alias           Get-Information_Schema.Routines                    SQLServer                                                                   
Alias           Get-Information_Schema.Tables                      SQLServer                                                                   
Alias           Get-Information_Schema.Views                       SQLServer                                                                   
Alias           Get-InvalidLogins                                  SQLServer                                                                   
Alias           Get-SessionTimeStamp                               SQLServer                                                                   
Alias           Get-SysDatabases                                   SQLServer                                                                   
Function        Add-SqlDatabase                                    SQLServer                                                                   
Function        Add-SqlDatabaseRole                                SQLServer                                                                   
Function        Add-SqlDatabaseRoleMember                          SQLServer                                                                   
Function        Add-SqlDataFile                                    SQLServer                                                                   
Function        Add-SqlFileGroup                                   SQLServer                                                                   
Function        Add-SqlLogFile                                     SQLServer                                                                   
Function        Add-SqlLogin                                       SQLServer                                                                   
Function        Add-SqlServerRoleMember                            SQLServer                                                                   
Function        Add-SqlUser                                        SQLServer                                                                   
Function        ConvertTo-ExtendedPropertyXML                      SQLServer                                                                   
Function        ConvertTo-IndexedColumnXML                         SQLServer                                                                   
Function        ConvertTo-MemberXml                                SQLServer                                                                   
Function        ConvertTo-StatisticColumnXML                       SQLServer                                                                   
Function        Get-DatabaseRoleMember                             SQLServer                                                                   
Function        Get-LoginMember                                    SQLServer                                                                   
Function        Get-Permission80                                   SQLServer                                                                   
Function        Get-ServerPermission90                             SQLServer                                                                   
Function        Get-Sql                                            SQLServer                                                                   
Function        Get-SqlCheck                                       SQLServer                                                                   
Function        Get-SqlColumn                                      SQLServer                                                                   
Function        Get-SqlConnection                                  SQLServer                                                                   
Function        Get-SqlData                                        SQLServer                                                                   
Function        Get-SqlDatabase                                    SQLServer                                                                   
Function        Get-SqlDatabasePermission                          SQLServer                                                                   
Function        Get-SqlDatabaseRole                                SQLServer                                                                   
Function        Get-SqlDataFile                                    SQLServer                                                                   
Function        Get-SqlDefaultDir                                  SQLServer                                                                   
Function        Get-SqlEdition                                     SQLServer                                                                   
Function        Get-SqlErrorLog                                    SQLServer                                                                   
Function        Get-SqlForeignKey                                  SQLServer                                                                   
Function        Get-SqlIndex                                       SQLServer                                                                   
Function        Get-SqlIndexFragmentation                          SQLServer                                                                   
Function        Get-SqlInformation_Schema.Columns                  SQLServer                                                                   
Function        Get-SqlInformation_Schema.Routines                 SQLServer                                                                   
Function        Get-SqlInformation_Schema.Tables                   SQLServer                                                                   
Function        Get-SqlInformation_Schema.Views                    SQLServer                                                                   
Function        Get-SqlLinkedServerLogin                           SQLServer                                                                   
Function        Get-SqlLogFile                                     SQLServer                                                                   
Function        Get-SqlLogin                                       SQLServer                                                                   
Function        Get-SqlObjectPermission                            SQLServer                                                                   
Function        Get-SqlPort                                        SQLServer                                                                   
Function        Get-SqlProcess                                     SQLServer                                                                   
Function        Get-SqlSchema                                      SQLServer                                                                   
Function        Get-SqlScripter                                    SQLServer                                                                   
Function        Get-SqlServer                                      SQLServer                                                                   
Function        Get-SqlServerPermission                            SQLServer                                                                   
Function        Get-SqlServerRole                                  SQLServer                                                                   
Function        Get-SqlShowMbrs                                    SQLServer                                                                   
Function        Get-SqlStatistic                                   SQLServer                                                                   
Function        Get-SqlStoredProcedure                             SQLServer                                                                   
Function        Get-SqlSynonym                                     SQLServer                                                                   
Function        Get-SqlSysDatabases                                SQLServer                                                                   
Function        Get-SqlTable                                       SQLServer                                                                   
Function        Get-SqlTransaction                                 SQLServer                                                                   
Function        Get-SqlTrigger                                     SQLServer                                                                   
Function        Get-SqlUser                                        SQLServer                                                                   
Function        Get-SqlUserDefinedDataType                         SQLServer                                                                   
Function        Get-SqlUserDefinedFunction                         SQLServer                                                                   
Function        Get-SqlVersion                                     SQLServer                                                                   
Function        Get-SqlView                                        SQLServer                                                                   
Function        Get-UserMember                                     SQLServer                                                                   
Function        Invoke-SqlBackup                                   SQLServer                                                                   
Function        Invoke-SqlDatabaseCheck                            SQLServer                                                                   
Function        Invoke-SqlIndexDefrag                              SQLServer                                                                   
Function        Invoke-SqlIndexRebuild                             SQLServer                                                                   
Function        Invoke-SqlRestore                                  SQLServer                                                                   
Function        New-DatabaseRoleMember                             SQLServer                                                                   
Function        New-LoginMember                                    SQLServer                                                                   
Function        New-SqlScriptingOptions                            SQLServer                                                                   
Function        New-UserMember                                     SQLServer                                                                   
Function        Remove-SqlDatabase                                 SQLServer                                                                   
Function        Remove-SqlDatabaseRole                             SQLServer                                                                   
Function        Remove-SqlDatabaseRoleMember                       SQLServer                                                                   
Function        Remove-SqlLogin                                    SQLServer                                                                   
Function        Remove-SqlServerRoleMember                         SQLServer                                                                   
Function        Remove-SqlUser                                     SQLServer                                                                   
Function        Set-SqlData                                        SQLServer                                                                   
Function        Set-SqlDatabasePermission                          SQLServer                                                                   
Function        Set-SqlObjectPermission                            SQLServer                                                                   
Function        Set-SqlServerPermission                            SQLServer                                                                   
Function        Update-SqlStatistic                                SQLServer                                                                   


#>

get-help Get-SqlServer -Full
<#
輸出 Microsoft.SqlServer.Management.Smo.Server
        Get-SqlServer returns a Microsoft.SqlServer.Management.Smo.Server object.
#>

Get-SqlServer $env:computername

get-help Get-SqlDatabase -Full
Get-SqlDatabase -sqlserver $env:computername -dbname sql_inventory |select *