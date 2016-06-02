Tried and tested it. I added a -Force parameter on the Add-Member cmdlet since the property is already there and needs to be replaced.

##################################
# Settings Variables
 
##################################
 
$computername = get-content "C:\computers.txt" 
 
$date = (Get-Date ).ToString('MM-dd-yyyy')
 
$Query="Select * FROM Win32_NTLogEvent WHERE LogFile=`"System`" AND EventCode=6008"
 
$ResultList = @()
 
 
 
##################################
 
# Getting Event Data
 
#################################
 
foreach ($computer in $computername) 
 
{
 
  write-host "Getting Eventid 6008 for " $computer
 
  $TempResult = Get-WmiObject -Query $query -computer $computer | Sort-Object TimeGenerated -Descending | select-Object -First 1
 
  If ($TempResult -ne $null) { 
 
     $TimeGeneratedParsed = (([datetime]::ParseExact(($TempResult.TimeGenerated).split('.')[0],'yyyyMMddHHmmss',$nul).addminutes(($TempResult.TimeGenerated).substring(6008)))) 
     $TimeWrittenParsed = (([datetime]::ParseExact(($TempResult.TimeWritten).split('.')[0],'yyyyMMddHHmmss',$nul).addminutes(($TempResult.TimeWritten).substring(6008))))
     $TimeGeneratedParsed = $TempResult.ConvertToDateTime($TempResult.TimeGenerated)
     $TimeWrittenParsed = $TempResult.ConvertToDateTime($TempResult.TimeWritten)
     $TempResult | Add-Member -MemberType NoteProperty -Name "TimeGenerated" -Value $TimeGeneratedParsed -Force
     $TempResult | Add-Member -MemberType NoteProperty -Name "TimeWritten" -Value $TimeWrittenParsed -Force

     $ResultList += $TempResult 
 
  }
 
}
 
 
##################################
# Exporting Event Data to Text File
##################################
 
$ResultList | Select-Object __SERVER,EventCode,InsertionStrings,Message,Logfile,TimeGenerated,TimeWritten | out-file -append "c:\event6008.txt"