
<#

Execute a process on remote computer

#>

$list = (Get-ADComputer -Filter 'Name -like "*computername"').name # List out all of the HJ computers in the domain and put in a []

$command = "notepad.exe" # command to be run on remote computers

foreach ($computer in $list){
                    
                    $TestConnect = $null
                    $TestConnect =  Get-WmiObject -Class Win32_PingStatus -Filter "Address='$Computer' AND Timeout=1000" #Check if computer is pingable
                                         
                    If ($TestConnect.StatusCode -eq 0) {
                                $IPMPLUS = $null
                                $IPMPLUS = ((Get-Service -Name "IPMPLUS" -ComputerName $computer -ErrorAction SilentlyContinue)) #if pingable, check service if exist on remote computer
                                
                                if (($IPMPLUS.name -eq "IPMPLUS") -and ($TestConnect.StatusCode -eq 0)){
                                                            
                                                                                                                                                                                          
                                                        $process = [WMICLASS]"\\$computer\ROOT\CIMV2:win32_process" #calls meta_class methods

                                                        $result = $process.Create($command)
                                                            if ($result.ReturnValue -eq 0){
                                                            
                                                            $computer + ",IPMPlus UnInstall, is started" >>c:\Logs\startprocess.txt
                                                            Write-host $computer ",IPMPlus UnInstall, is started" >>c:\Logs\startprocess.txt
                                                            }
                        
                                                            else {
                                                            $computer + ",IPMPlus UnInstall, not started" >>c:\Logs\startprocess.txt
                                                            Write-host $computer ",IPMPlus UnInstall, not started" >>c:\Logs\startprocess.txt
                                                            }
                                                        
                                }
                                                        
                                elseif ($IPMPLUS.name -ne "IPMPLUS"){
                                    $computer + ",No IPMPLUS"  >>c:\Logs\startprocess.txt
                                    Write-host $computer ",No IPMPLUS" 

                                    }
                     
                     
                                else {Write-host $computer "run with errors."}
                                }
                                                         

                    else {
                            $computer + ",,is not alive" >>c:\Logs\startprocess.txt
                            Write-host $computer ",,is not alive"
                             
                     }
                     }