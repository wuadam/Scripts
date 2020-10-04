<#
Author: Adam Wu
Date:  1/17/2020
Summary:

This script loop through a list of AD computers and search for key words in the remote path and output the filename, path, line, linenumber and searchword key word

#>

# Change the search below
# $computers = (Get-ADComputer -Filter 'Name -like "computername*"').name
$computers = (Get-ADCOMPUTER -Filter {OperatingSystem -Like "*servername*"}).name

foreach ($computer in $computers) {

    $computer = "$computer"

    #Search multiple strings separated by commma between the single quotes
    $searchWords = 'connectionstring'

    #Enter fold path to search between the single quotes
    $folder = "\\$computer\c$\"

    #Search base on file extensions, multiple search separated with a comma between the single quotes
    $fileExt = "*.txt", "*.csv", "*.config"

    #Main
    forEach ($sw in $searchWords) {
        $list = Get-Childitem -Path $folder -Recurse -include $fileExt -ErrorAction SilentlyContinue
        forEach ($file in $list) {
            $lastwrite = $file.LastWriteTime
            $result = $file | Select-String -Pattern "$sw" |
            Select-Object Filename, 
            LineNumber, 
            @{n = 'SearchWord'; e = { $sw } }, 
            @{n = 'LastWriteTime'; e = { $lastwrite } }, 
            @{n = 'ComputerName'; e = { $env:COMPUTERNAME } },
            Path,
            Line
            $result
            # export to a csv file in the temp folder.            
            $result | export-csv -path $env:TEMP\$env:COMPUTERNAME.csv -Append -NoTypeInformation
            # $result | Out-File -Encoding Ascii -append c:\temp\$env:COMPUTERNAME.txt
        }
        if (Test-Path $env:TEMP\list.csv){start $env:TEMP\list.csv}
    }
}
