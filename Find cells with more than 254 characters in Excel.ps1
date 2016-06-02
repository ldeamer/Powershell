#Used for ConvertTo-HTML
$Header = @"
<style>
 BODY {height: 100%; width: 90%; padding: 0; background-color: #FFFFFF;}
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;} 
   TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #92B4F2;}
   TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
"@

#Set Path
$Path = 'C:\users\ldeamer\desktop\EXT LOG.xlsx'

#Import Excel file into an array.
$Data = Import-Excel -Path "$Path"

#Enter the row number of the first line of actual data, not including headers.
$RowNumber = 2

#Find out the names of all the fields
$Fields = $Data[0] | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name

#Loop through each Row and each field
$Results = ForEach ($Row in $Data)
{
    ForEach ($Cell in $Fields)
    {
        If ($Row.$Cell.Length -gt 254)
        {
            [PSCustomObject]@{
                Row = $RowNumber
                Column = $Cell
                Character_Count = $Row.$Cell.length
                What_Was_Entered = $Row.$Cell
                             }
        }
    }
    $RowNumber ++
}

 

$Results | Select-Object | convertto-html -title "Log Report" -body "<H2>Ext Log</H2>" -Head $Header| set-content C:\users\ldeamer\desktop\Character_Count.htm

