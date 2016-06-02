[void][system.reflection.assembly]::LoadWithPartialName('System.DirectoryServices.AccountManagement')
([adsisearcher]'(&(objectclass=user)(objectcategory=person))').FindAll() | ForEach-Object -Begin {
    $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain') 
    }  -Process {
    if ($DS.ValidateCredentials($_.properties.samaccountname, 'afe12345')) {
        New-Object -TypeName PSCustomObject -Property @{
            name = -join $_.properties.name 
             
         
        }
    }
} | Out-GridView
