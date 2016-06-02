$array = @()            
foreach($i in (Get-content c:\users\ldeamer\desktop\computers.txt)) {            
 $svc = Get-Service remoteregistry -ComputerName $i -ea 0           
 $obj = New-Object psobject -Property @{            
  Name = $svc.name            
  Status = $svc.status            
  Computer = $i            
  }            
 $array += $obj            
}                      
$array | Select Computer,Name,Status | sort-object | Out-GridView