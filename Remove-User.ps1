. 'C:\Program Files\Microsoft\Exchange Server\V14\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto

Function Remove-User {
[cmdletbinding()]
Param (
[String]$Username
)

#Setting variables for later use.
$QnapPath = '\\192.168.2.212\Public\Terminated Employees'
$Mailbox = Get-mailbox -identity $Username
$Database = $mailbox.database.name

#Makes sure the username is valid.
    Try {
        $ADUser = Get-ADUser $UserName
        } 
        Catch {
            Throw "$Username is not a valid user name, terminating"
              }
$fullname = $aduser.name


#This creates folders to be used for copying to later on.
New-item -Path $QnapPath\$fullname -ItemType Directory
New-item -Path $QnapPath\$fullname\E-mail -ItemType Directory
New-item -Path "$QnapPath\$fullname\My Documents" -ItemType Directory

#This copies the user's documents from their user share to the network share for archiving purposes.
copy-item "\\afedc1\users\$username\Documents\*" "Qnap:\$fullname\My Documents" -Recurse
copy-item "\\afedc1\users\$username\My Documents\*" "Qnap:\$fullname\My Documents" -Recurse

#If you made sure there was a valid username used earlier, this will delete just the user's folder.  
Remove-item "\\afedc1\users\$username\" -Recurse -Force

#This archives the user's mailbox to a .PST file.
New-MailboxExportRequest -mailbox $username -Filepath "\\192.168.2.212\public\terminated employees\$fullname\E-Mail\$username.PST"

Do {
    Start-Sleep 5
   } 
    While ((Get-MailboxExportRequest -mailbox $username).Status -ne 'Completed')

#This will mark the mailbox as disabled for removal later on.
Disable-Mailbox -Identity "$fullname"

#This will remove the mailbox from the mailbox database.
Remove-Storemailbox -database "$Database" -Identity "$Fullname" -Mailboxstate Disabled

#This clears all export requests that are marked as completed.
Get-MailboxExportRequest | Where-Object {$_.status -eq 'Completed'} | Remove-MailboxExportRequest

}