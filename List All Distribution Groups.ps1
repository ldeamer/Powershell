$saveto = 'C:\\listmembers.txt'

Get-DistributionGroup | Sort-Object name | ForEach-Object {

	"`r`n$($_.Name)`r`n=============" | Add-Content $saveto
	Get-DistributionGroupMember $_ | Sort-Object Name | ForEach-Object {
		If($_.RecipientType -eq 'UserMailbox')
			{
				$_.Name +  '(' + $_.PrimarySMTPAddress + ')' | Add-Content $saveto
			}
	}
}