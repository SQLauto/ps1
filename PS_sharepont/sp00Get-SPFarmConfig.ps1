
<#00Get-SPFarmConfig
#>
#----------------------------
#  PowerShell Remoting for SharePoint
#----------------------------
##On the SharePoint server:
Enable-PSRemoting -Force 
Enable-WSManCredSSP -Role Server -Force

##On the client machine (the management server):
Enable-WSManCredSSP -Role Client -DelegateComputer * -Force
Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Credssp\PolicyDefaults\AllowFreshCredentials -Name WSMan -Value WSMAN/*
Set-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Credssp\PolicyDefaults\AllowFreshCredentialsDomain -Name WSMan -Value WSMAN/*

## run 
Enter-PSSession SPServer -Authentication CredSSP -Credential DOMAIN\username  #sample

Enter-PSSession sp2013wfe -Authentication CredSSP -Credential csd\administrator
Add-PSSnapIn Microsoft.SharePoint.PowerShell


Get-spserver
exit

Get-PSSession

$SessionX = New-PSSession -ComputerName sp2013wfe -Credential csd\administrator -Authentication CredSSP
Invoke-Command -Session $SessionX -ScriptBlock {Add-PSSnapIn Microsoft.SharePoint.PowerShell}
icm -session $SessionX {Get-spserver}
icm -session $SessionX {Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 2 -MaxSamples 3}


#-------------------------------------------
# Manage services on server  Oct.14.2013 
#-------------------------------------------
whoami
Get-SPServiceInstance |select typename,id,Status

Get-SPServiceInstance |? {$_.Status -eq 'online' } |select id,typename,Status


Start-SPServiceInstance  -Identity d1a6d504-418d-4833-b67d-3dfd3045665d  #Central Administration
Start-SPServiceInstance  -Identity e9e83095-2af0-4ad8-8874-433d147cad32  #Microsoft SharePoint Foundation Web Application

Stop-SPServiceInstance -Identity e9e83095-2af0-4ad8-8874-433d147cad32  -Confirm:$false      #Microsoft SharePoint Foundation Web Application
Stop-SPServiceInstance -Identity d1a6d504-418d-4833-b67d-3dfd3045665d  -Confirm:$false      #Central Administration
Stop-SPServiceInstance -Identity e058340e-d7a8-42d4-9501-2c236824085b  -Confirm:$false      #Microsoft SharePoint Foundation Incoming E-Mail
Stop-SPServiceInstance -Identity 03002d00-f6d0-4f80-9a19-4c073666e3a6  -Confirm:$false      #Distributed Cache
Stop-SPServiceInstance -Identity  67920e93-c8d9-48ec-809f-41560c9d042f -Confirm:$false      #Microsoft SharePoint Foundation Workflow Timer Service

#-------------------------------------------
#  檢查是否Sharepoint 需要 upgrade
#-------------------------------------------
(get-spserver $env:computername).NeedsUpgrade


#-------------------------------------------
#具有 SharePoint_Shell_Access 角色之所有使用者的名稱
#-------------------------------------------
  gh Get-SPShellAdmin  -full

#http://technet.microsoft.com/en-us/library/ff793362.aspx

## import-module ADRMS, AppLocker, BestPractices, BitsTransfer,PSDiagnostices,Servermanager,TroubleshootingPack,WebAdministration
##  Import-Module “sqlps” -DisableNameChecking
#----------------------------
#  Get-Module
#----------------------------
Get-Module

import-module webadministration
Import-Module ServerManager

write-host "Snap-In $SnapInName already loaded"
Get-pssnapin |select name
Get-webbinding |  select item,bindingInformation   cmdlet
Get-Website |select Name ,"PhysicalPath" ,Bindings   |fl 

#----------------------------
## Import the SQL Server Module.
#----------------------------

Get-Help Invoke-Sqlcmd
get-help Invoke-SqlCmd -full

#----------------------------
## Get-SPFarmConfig
#----------------------------
Get-SPFarmConfig

#----------------------------
## 伺服器陣列的所有伺服器   gh Get-SPServer  -full
#----------------------------
Get-SPServer |gm ; Get-SPServer | Where{ $_.NeedsUpgrade -eq $TRUE}
Get-SPServer | select Name ,role,status      | ft -auto                    
Rename
#------------------------------------------
#Retrieve the System Accounts
#------------------------------------------
Get-SPProcessAccount


# Get-Help
get-help Set-SPPassPhrase -full

Set-SPFarmConfig -InstalledProductsRefresh

#------------------------------------------
#Change the Port of Central Admin
#------------------------------------------
set-SPCentralAdministration –Port 20222
Import all modules


#------------------------------------------
#Change the Port of Central Admin
#------------------------------------------

add-pssnapin WebAdministration
Get-Website

#------------------------------------------
#   Get-SPManagedPath 
#------------------------------------------
Get-SPManagedPath   -WebApplication  "SP"
New-SPManagedPath "Teams" -WebApplication "http://somesite"

#-----------------------------------
##新增受管理帳戶至伺服器陣列
#-----------------------------------
# Service accounts
$DOMAIN = "CSD.SYSCOM"$accounts = @{}$accounts.Add("SPFarm", @{"username" = "sp2013-farm"; "password" = "Password123"})$accounts.Add("SPWebApp", @{"username" = "sp2013-ap-webapp"; "password" = "Password123"})$accounts.Add("SPSvcApp", @{"username" = "sp2013-ap-service"; "password" = "Password123"})
# Add managed accounts
Write-Output "Creating managed accounts ..."
New-SPManagedAccount -credential $accounts.SPWebApp.credential
New-SPManagedAccount -credential $accounts.SPSvcApp.credential
New-SPManagedAccount -credential $accounts.SPCrawl.credential


$ServiceApplicationUser = "CSD\SPfarmadmin" 
$ServiceApplicationUserPassword = (ConvertTo-SecureString "pass@word" -AsPlainText -force) 
$ServiceApplicationCredentials = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $ServiceApplicationUser, $ServiceApplicationUserPassword  
 #Managed Account 
      write-host -ForegroundColor Green "Managed account..."; 
      $ManagedAccount = Get-SPManagedAccount $ServiceApplicationUser 

      if ($ManagedAccount -eq $NULL)  
      {  
           write-host  -ForegroundColor Green "Create new managed account" 
           $ManagedAccount = New-SPManagedAccount -Credential $ServiceApplicationCredentials 
      } 
      