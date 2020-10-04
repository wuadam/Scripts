# This script check .NET Framework Version 4.5 or above and updates on the local machine.
# the source code was taken from MS doc url with a little change.
# https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed#detect-net-framework-10-through-40

$releasekey = (Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release
$dotNetVersions = Get-ChildItem HKLM:\SOFTWARE\WOW6432Node\Microsoft\Updates | ? {$_.name -like "*.NET Framework*"}

function checknetversion(){

         if ($releasekey -ge 528040){
            return "4.8 or later";}

         if ($releasekey -ge 461808){
            return "4.7.2";}

         if ($releasekey -ge 461308){
         return "4.7.1";}
            
         if ($releasekey -ge 460798){
         return "4.7";}
            
         if ($releasekey -ge 394802){
         return "4.6.2";}
            
         if ($releasekey -ge 394254){
         return "4.6.1";}
            
         if ($releasekey -ge 393295){
         return "4.6";}
            
         if ($releasekey -ge 379893){
         return "4.5.2";}
            
         if ($releasekey -ge 378675){
         return "4.5.1";}
            
         if ($releasekey -ge 378389){
         return "4.5";}
            
         return "No 4.5 or later version detected";
}

cls
$netver = checknetversion
Write-host "Microsoft .NET Framework Version "
Write-host " .Net Framework Version:  "  $netver -ForegroundColor Green
ForEach($version in $dotNetVersions){

   $updates = Get-ChildItem $version.PSPath
    $Version.PSChildName
    ForEach ($update in $updates){
       Write-host " .Net Framework KB:  "  $update.PSChildName -ForegroundColor Green 
       }
}

Start-Sleep -s 30
