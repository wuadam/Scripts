<#

Created by:  Adam Wu
Created Date:  5/4/2020

Get Computer Information

Usage: 
Example 1:  Get-SumSysInfo -ComputerName it29254hh

Example 2:  $UserLoggedOn = Get-SumSysInfo -ComputerName it29254hh

#>

function Get-NetStatus(){
    # check Network status 
    # Get NetAdatper
   [CmdletBinding()]
   Param(
       [Parameter(Mandatory=$true,
                 ValueFromPipeline=$true,
                 ValueFromPipelineByPropertyName=$true)]
       [string] $computername
   )
   Process {

        $IPAddress = ([System.Net.Dns]::GetHostByName($computername).AddressList).IpAddressToString 
        $IPMAC = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $computername
        $MACAddress = ($IPMAC | where { $_.IpAddress -eq $IPAddress}).MACAddress 
        $obj = new-object psobject
        $obj | add-member noteproperty MAC ($MACAddress)
        $obj | add-member noteproperty IP ($IPAddress)
        $obj
}
}

    function Get-Priviledge(){
# check Network status 
try {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity
    return $principal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )
} 
catch {
    throw "Failed to determine if the current user has elevated privileges. The error was: '{0}'." -f $_
}
}

function Get-AdComputersObject(){
write-host "Retrieving an array of computer objects"
# Collection of computers
# Set model = hostprefix
}

function Get-AdComputerStatus(){
write-host "Checkcing AD Computer Information"
# Query Computer in AD if exist.
}

function Get-ComputerInstalledApps(){
write-host "Retrieving Apps installed."
# Query Computer in AD if exist.
}

function Get-AdUserStatus(){
# write-host "If UserLoggedOn, retrieve AD Basic Property"
# bool Get-AdComputerStatus is true then execute funtion
if (!([string]::IsNullOrEmpty($user))) {
$Id = Get-ADUser -Identity $user.UserLoggedOn -Properties * 
                $obj = new-object psobject
                $obj | add-member noteproperty ID ($Id.SamAccountName)
                $obj | add-member noteproperty FirstName ($Id.GivenName)
                $obj | add-member noteproperty LastName ($Id.Surname)
                $obj | add-member noteproperty LastLogonDate ($Id.LastLogonDate)
                $obj | add-member noteproperty Department ($Id.Department)
                $obj | add-member noteproperty UPN ($Id.UserPrincipalName)
                $obj | add-member noteproperty Mail ($Id.mail)
                $obj | add-member noteproperty Mobile ($Id.MobilePhone)
                $obj | add-member noteproperty Office ($Id.telephoneNumber)
                $obj | add-member noteproperty PasswordLastSet ($Id.PasswordLastSet)
                $obj | add-member noteproperty AccountlockTime ($id.AccountLockoutTime)
                $obj | add-member noteproperty AccountExpirationDate ($id.AccountExpirationDate)
                $obj
}
<#
$user = Get-ADUser -Identity user -Properties * 
$Groupmembership = ($user.MemberOf | % {(Get-ADGroup $_).name;}) 
#>

}

function Get-Model(){
write-host "Checcking Manfacturer Model Information"
# Some manufactor exe to retrieve BIOS settings
# Switch Models from @{}
}

function Set-Bios(){
write-host "Setting BIOS for {0}, model"
# Remote exe on target host.
# This is separat module.
# Switch Models from @{}
}

function Export-log(){
write-host "Export to CSV and HTML"
}

# Check TPM of Remote Machine
function Get-RemoteTPM()
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [string] $ComputerName
    )
    Process {
            if (!($isAdmin)){write-host "TPM failed to execute, please run with Admin priviledge." -ForegroundColor Red}
            if ($isAdmin){            
                $tpm = Get-WmiObject -class Win32_Tpm -namespace root\CIMV2\Security\MicrosoftTpm -ComputerName $computername
                $obj = new-object psobject
                $obj | add-member noteproperty TPMVersion ($tpm.SpecVersion)
                $obj | add-member noteproperty TPM_Manufacturer_Version ($tpm.ManufacturerVersion)
                $obj | add-member noteproperty TPM_ISActivated ($tpm.IsActivated_InitialValue) 
                $obj | add-member noteproperty TPM_IsEnabled ($tpm.IsEnabled_InitialValue)
                $obj 
}
                }     
}

# Get Computer Operating System
function Get-ComputerOS
{
   [CmdletBinding()]
   Param(
       [Parameter(Mandatory=$true,
                 ValueFromPipeline=$true,
                 ValueFromPipelineByPropertyName=$true)]
       [string] $computername
   )
   Process {
            $computerOS = get-wmiobject -computername $computername Win32_OperatingSystem

              $obj = new-object psobject
              $obj | add-member noteproperty OperatingSystem ($computerOS.caption)
              $obj | add-member noteproperty BuildNumber ($computerOS.BuildNumber)
              $obj | add-member noteproperty WindowsVersion ($computerOS.Version)
              $obj | add-member noteproperty OSArchitecture ($computerOS.OSArchitecture)
              $obj | add-member noteproperty LastBootUp ($computerOS.ConverttoDateTime($computerOS.LastBootUpTime))
              $obj 
              }     
}

#Check User Logged On
function Get-LoggedOnUser
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
         [string] $ComputerName
    )
    Process {
            $Win32Process = Get-WmiObject -Class win32_process -ComputerName $ComputerName
            $Process = $Win32Process | ?{$_.Name -like 'explorer.exe'} 

                $obj = new-object psobject
                $obj | add-member noteproperty UserLoggedOn ($process.GetOwner().user)
                $obj 
                }     
}

# Get-Computer System Information
function Get-ComputerSystemInfo()
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [string] $ComputerName
    )
    Process {
            $computerinfo = get-wmiobject -computername $ComputerName Win32_ComputerSystem
            # Get Computer Info
            # User_Logged_In is null, need alternative, .net class method of sysinternal tool or invoke command to $env:UserName

                $obj = new-object psobject
                $obj | add-member noteproperty ComputerName ($computerinfo.Name)
                $obj | add-member noteproperty Manufacturer ($computerinfo.Manufacturer)
                $obj | add-member noteproperty Model ($computerinfo.Model)
                $obj | add-member noteproperty Total_Memory_GB ([math]::Round(($computerinfo.TotalPhysicalMemory/1gb),2))
                # $obj | add-member noteproperty User_Logged_In ($computerinfo.UserName)

                $obj 
                }     
}

#Get BIOS
function Get-ComputerBios()
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [string] $ComputerName
    )
    Process {
            $computerBIOS = get-wmiobject -computername $ComputerName Win32_BIOS

                $obj = new-object psobject
                $obj | add-member noteproperty SerialNumber (($computerBIOS).SerialNumber)
                $obj | add-member noteproperty SMBIOSBIOSVersion (($computerBIOS).SMBIOSBIOSVersion)
                $obj | add-member noteproperty BIOSVersion (($computerBIOS).Version)
                $obj 
                }     
}


# Get Local Disks and DiskSize
# Get UserLoggnedonNetworkDrive if method exist
function Get-DiskInfo()
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [string] $computername
    )
    Process {
            $Drives = get-wmiobject win32_logicaldisk -ComputerName $computername 
            foreach ($Drive in $Drives){
                if ($Drive.DriveType -eq 3){
                    $obj = new-object psobject
                    $obj | add-member noteproperty Drive_Letter ($Drive.DeviceId)
                    $obj | add-member noteproperty Disk_Type ($Drive.MediaType)
                    $obj | add-member noteproperty Disk_FreeSpace_GB ([math]::Round(($Drive.FreeSpace/1gb),2))
                    $obj | add-member noteproperty Disk_Size_GB ([math]::Round(($Drive.Size/1gb),2))
                    $obj
                    
            }}}     
}

function Get-SumSysInfo(){


    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
         [string] $ComputerName
    )
    Process {   
$isAdmin = Get-Priviledge
# move test-connection into a function call async
$isAlive = Test-Connection -ComputerName $ComputerName -Quiet -Count 1
    if ($isAlive){
        $Result = 
        # Get-SumSysInfo -ComputerName $ComputerName
        $OS = Get-ComputerOS -computername $ComputerName
        $TPM = Get-RemoteTPM -computername $ComputerName
        $SystemInfo = Get-ComputerSystemInfo  -computername $ComputerName
        $BIOS = Get-ComputerBios -computername $ComputerName
        $User = Get-LoggedOnUser -computername $ComputerName
        $DiskInfo = Get-DiskInfo -computername $ComputerName
        $Alive = Get-NetStatus -computername $ComputerName  # Extend to retrieve NetInfo IP, MAC...
        $ADUser = Get-AdUserStatus
        $NetIPMACGet = NetStatus -computername $ComputerName
        Write-Output $OS $TPM $SystemInfo $NetIPMACGet $BIOS $Alive $DiskInfo $User $ADUser 
    }
    if (!$isAlive){
        Write-Output "($ComputerName) is not alive."
        Exit
    }
# export to CSV
}
}

#main
# script start
