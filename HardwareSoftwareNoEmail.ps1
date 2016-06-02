Set-ExecutionPolicy RemoteSigned


$head = @’

<style>

BODY { background-color:#dddddd;font-family:Tahoma;font-size:12pt; }
TD, TH { background-color:#ffffff; border:1px solid black; border-collapse:collapse; }
TH { color:white; background-color:black; }
TABLE, TR, TD, TH { padding: 2px; margin: 0px }
TABLE { margin-left:50px; }

</style>

‘@

$Monitor         = Get-WmiObject Win32_DesktopMonitor
$VideoCard       = Get-WmiObject Win32_VideoController
$DefaultPrinter  = Get-WmiObject -query " SELECT * FROM Win32_Printer WHERE Default=$true"
$IPAddress       = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -Match 'True'}
$BIOS            = Get-WmiObject Win32_BIOS
$Processor       = Get-WmiObject Win32_Processor
$ComputerSystem  = Get-WmiObject Win32_ComputerSystem
$MaxMemory       = Get-WmiObject Win32_PhysicalMemoryArray
$OS              = Get-WmiObject Win32_OperatingSystem
$Antivirus       = Get-WmiObject Win32_Product | Where-Object {$_.name -match 'Eset Endpoint'}
$HardDrive       = Get-WmiObject Win32_DiskDrive | Where-Object {$_.DeviceID -match 'PHYSICALDRIVE0'}
$Toolbars        = Get-WmiObject Win32_Product | Where-Object {$_.name -match 'Toolbar'}
$IEPath          = 'C:\Program Files\Internet Explorer\iexplore.exe'
$Computername    = $ComputerSystem.Name
$License         = Get-WmiObject SoftwareLicensingProduct -ComputerName $env:computername -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f'" | Where-Object partialproductkey
$LicenseStatus   = switch ($license.LicenseStatus)
        {
    0 {'Unlicensed'}
    1 {'Licensed'}
    2 {'OOBGrace'}
    3 {'OOTGrace'}
    4 {'NonGenuineGrace'}
    5 {'Notification'}
    6 {'ExtendedGrace'}
    Default {'Undetected'}

    }
$Applications    = Get-WmiObject Win32_Product 



$ResultsHardware = [PSCustomObject]@{
   'Computer Name'     = $ComputerSystem.Name
   'Domain'            = $ComputerSystem.Domain
   'Manufacturer'      = $ComputerSystem.Manufacturer
   'Model'             = $ComputerSystem.Model
   'BIOS Version'      = $Bios.SMBIOSBIOSVersion
   'Serial Number'     = $BIOS.SerialNumber
   'Processor'         = $Processor.name
   'Current Memory'    = [math]::Round($ComputerSystem.TotalPhysicalMemory/1gb) -as [string] | ForEach-Object {$_ + 'GB'}
   'Maximum Memory'    = [math]::Round($MaxMemory.MaxCapacity/1mb) -as [string] | ForEach-Object {$_ + 'GB'}
   'Hard Drive Model'  = $HardDrive.model 
   'Hard Drive Size'   = [math]::Round($HardDrive.Size/1Gb) -as [string] | ForEach-Object {$_ + 'GB'}
   'IP Address'        = $IPAddress.IPAddress -as [string]
   'MAC Address'       = $IPAddress.MACAddress
   'Monitor'           = $Monitor.Name
   'Video Card'        = $VideoCard.Name
   'Default Printer'   = $DefaultPrinter.Name
}

$ResultsSoftware = [PSCustomObject]@{
   'Operating System'   = $OS.Caption
   'Service Pack'       = $OS.ServicePackMajorVersion
   'License Status'     = $licensestatus
   'PowerShell Version' = $PSVersionTable.PSVersion
   'Antivirus Name'     = $Antivirus.name
   'Antivirus Version'  = $Antivirus.version
   'Internet Explorer'  = (Get-item $IEPath).Versioninfo.ProductVersion
   'Toolbars Loaded'    = $Toolbars.Name -as [string]
}

$ResultsApplications    = ForEach ($Apps in $Applications){
                            [PSCustomObject]@{
   'Name'               = $apps.name
   'Vendor'             = $apps.vendor
   'Version'            = $apps.version
  }
}



$Hardware = $ResultsHardware | ConvertTo-Html -As LIST -Fragment -PreContent ‘<h2>Hardware</h2>’ | Out-String


$Software = $ResultsSoftware | ConvertTo-Html -As LIST -Fragment -PreContent ‘<h2>Software</h2>’ | Out-String


$App      = $ResultsApplications | sort-object vendor,name | ConvertTO-Html -as TABLE -Fragment -PreContent '<h2>Applications</h2>' | Out-String


ConvertTo-HTML -head $head -PostContent $hardware,$software,$App -PreContent “<h1>Report for $Computername</h1>” | set-content "C:\afe-pc\$Computername.html"

Invoke-Item C:\afe-pc\$Computername.html