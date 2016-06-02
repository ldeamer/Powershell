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

$Monitor               = Get-WmiObject Win32_DesktopMonitor
$VideoCard             = Get-WmiObject Win32_VideoController
$DefaultPrinter        = Get-WmiObject -query " SELECT * FROM Win32_Printer WHERE Default=$true"
$IPAddress             = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -Match 'True'}
$BIOS                  = Get-WmiObject Win32_BIOS
$Processor             = Get-WmiObject Win32_Processor
$ComputerSystem        = Get-WmiObject Win32_ComputerSystem
$MaxMemory             = Get-WmiObject Win32_PhysicalMemoryArray
$OS                    = Get-WmiObject Win32_OperatingSystem
$Antivirus             = Get-WmiObject Win32_Product | Where-Object {$_.name -match 'Eset Endpoint'}
$HardDrive             = Get-WmiObject Win32_DiskDrive | Where-Object {$_.DeviceID -match 'PHYSICALDRIVE0'}
$Toolbars              = Get-WmiObject Win32_Product | Where-Object {$_.name -match 'Toolbar'}
$IEPath                = 'C:\Program Files\Internet Explorer\iexplore.exe'
$Computername          = $ComputerSystem.Name
$DeviceManager         = Get-WmiObject Win32_PNPEntity | Where-Object {$_.Status -like 'error'} 
$License               = Get-WmiObject SoftwareLicensingProduct -ComputerName $env:computername -Filter "ApplicationID = '55c92734-d682-4d71-983e-d6ec3f16059f'" | Where-Object partialproductkey
$Applications          = Get-WmiObject Win32_Product 
$LicenseStatus         = switch ($license.LicenseStatus){
                         0       {'Unlicensed'}
                         1       {'Licensed'}
                         2       {'OOBGrace'}
                         3       {'OOTGrace'}
                         4       {'NonGenuineGrace'}
                         5       {'Notification'}
                         6       {'ExtendedGrace'}
                         Default {'Undetected'}

                                                        }
    

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
   'MAC Address'       = $IPAddress.MACAddress -as [string]
   'Monitor'           = $Monitor.Name -as [string]
   'Video Card'        = $VideoCard.Name -as [string]
   'Default Printer'   = $DefaultPrinter.Name 
                                    }

$ResultsSoftware       = [PSCustomObject]@{
   'Operating System'  = $OS.Caption
   'Service Pack'      = $OS.ServicePackMajorVersion
   'License Status'    = $licensestatus
   'PowerShell Version'= $PSVersionTable.PSVersion
   'Antivirus Name'    = $Antivirus.name
   'Antivirus Version' = $Antivirus.version
   'Internet Explorer' = (Get-item $IEPath).Versioninfo.ProductVersion
   'Toolbars Loaded'   = $Toolbars.Name -as [string]
                                          }

 
$ResultsDevices        = ForEach ($Devs in $DeviceManager){
  $Devicestatus        = switch ($Devs.configmanagererrorcode){
  

                         1  {'This device is not configured correctly.'}
                         2  {'Windows cannot load the driver for this device.'}
                         3  {'The driver for this device might be corrupted, or your system may be running low on memory or other resources.'}
                         4  {'This device is not working properly. One of its drivers or your registry might be corrupted.'}
                         5  {'The driver for this device needs a resource that Windows cannot manage. '}
                         6  {'The boot configuration for this device conflicts with other devices.'}
                         7  {'Cannot filter.'}
                         8  {'The driver loader for the device is missing.'}
                         9  {'This device is not working properly because the controlling firmware is reporting the resources for the device incorrectly.'}
                         10 {'This device cannot start.'}
                         11 {'This device failed.'}
                         12 {'This device cannot find enough free resources that it can use.'}
                         13 {"Windows cannot verify this device's resources."}
                         14 {'This device cannot work properly until you restart your computer.'}
                         15 {'This device is not working properly because there is probably a re-enumeration problem.'}
                         16 {'Windows cannot identify all the resources this device uses.'}
                         17 {'This device is asking for an unknown resource type. '}
                         18 {'Reinstall the drivers for this device.'}
                         19 {'Failure using the VxD loader.'}
                         20 {'Your registry might be corrupted.'}
                         21 {'System failure: Try changing the driver for this device. If that does not work, see your hardware documentation. Windows is removing this device.'}
                         22 {'This device is disabled.'}
                         23 {"System failure: Try changing the driver for this device. If that doesn't work, see your hardware documentation."}
                         24 {'This device is not present, is not working properly, or does not have all its drivers installed. '}
                         25 {'Windows is still setting up this device.'}
                         26 {'Windows is still setting up this device.'}
                         27 {'This device does not have valid log configuration.'}
                         28 {'The drivers for this device are not installed. '}
                         29 {'This device is disabled because the firmware of the device did not give it the required resources.'}
                         30 {'This device is using an Interrupt Request (IRQ) resource that another device is using.'}
                         31 {'This device is not working properly because Windows cannot load the drivers required for this device. '}
                         Default {'Undetected'}

                                                             }                         
                         [PSCustomObject]@{                           
    'Name'             = $Devs.name
    'Description'      = $Devs.Description
    'Status'           = $Devs.Status
    'Error Description'= $devicestatus
                                          }
                                                          } 

 
$ResultsApplications   = ForEach ($Apps in $Applications){
                         [PSCustomObject]@{
    'Name'             = $apps.name
    'Vendor'           = $apps.vendor
    'Version'          = $apps.version

                                          }


                                                         }

$Hardware              = $ResultsHardware     | ConvertTo-Html -As LIST -Fragment -PreContent ‘<h2>Hardware</h2>’ | Out-String

$Software              = $ResultsSoftware     | ConvertTo-Html -As LIST -Fragment -PreContent ‘<h2>Software</h2>’ | Out-String

$Devices               = $ResultsDevices      | ConvertTo-Html -As TABLE -Fragment -PreContent ‘<h2>Devices Not Installed</h2>’ | Out-String

$App                   = $ResultsApplications | sort-object vendor,name | ConvertTO-Html -as TABLE -Fragment -PreContent '<h2>Applications</h2>' | Out-String


ConvertTo-HTML           -head $head -PostContent $hardware,$software,$Devices,$App -PreContent “<h1>Report for $Computername</h1>” | set-content "C:\afe-pc\$Computername.html"

Invoke-Item              C:\afe-pc\$Computername.html

$Body = Get-Content      "C:\afe-pc\$computername.html" -Raw

$To                    = "afe-it@americanfire.com"
$From                  = "IT@americanfire.com"
$Subject               = "$Computername"
$SMTPServer            = "smtp.gmail.com"
$Port                  = "587"
$login                 = "afeitmail@gmail.com"
$password              = "Afegmail12345" | Convertto-SecureString -AsPlainText -Force
$credentials           = New-Object System.Management.Automation.Pscredential -Argumentlist $login,$password

Send-MailMessage         -to $To -From $From -subject $Subject -BodyAsHtml (Get-Content "C:\afe-pc\$computername.html" -Raw) -Attachments "C:\afe-pc\$computername.html" -SmtpServer $SMTPServer -Port $Port -credential $credentials -usessl