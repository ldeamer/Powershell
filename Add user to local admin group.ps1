#########
### Script for adding a domain user account to remote local admin group.
###
### *** Script requires that user executing script has Admin rights on destination machine.
###
### http://poshdepo.codeplex.com/
#########

### Domain (edit with your domain)
$Domain = 'americanfire.local'

### Get machine hostname
$Computer = Read-Host 'Enter machinename to add user to local admins'

### Get User account in samaccountname format
$UserName = Read-Host "Enter username to add to local admin group of $Computer"

# Bind to the local Administrators group on the computer.
$Group = [ADSI]"WinNT://$Computer/Administrators,group"

# Bind to the domain user.
$User = [ADSI]"WinNT://$Domain/$UserName,user"

# Add the domain user to the group.
$Group.Add($User.Path)

### *** ###