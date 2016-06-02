#Checking to see if .NETFramwork 4.5 is installed

if (Get-Item -path 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\.NETFramework\v4.0.30319\SKUs\.NETFramework,Version=v4.5')

       {wusa /install '\\afedc1\departments\it\logon scripts\powershell 4.0\Windows6.1-KB2819745-x64-MultiPkg.msu' /quiet /norestart}
 

       
