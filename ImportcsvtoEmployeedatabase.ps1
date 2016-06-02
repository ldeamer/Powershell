Add-PSSnapin Microsoft.Sharepoint.Powershell

# CSV path/File name
$contents = Import-Csv "\\afesp1\c$\SharepointFiles\Announcement.csv" 

# Web URL
$web = Get-SPWeb -Identity "http://afesp1" 

# SPList name
$list = $web.Lists["Employee Database"] 


# Iterate for each list column

foreach ($row in $contents) {
    $item = $list.Items.Add();
    $item["FirstName"] = $row."givenname";
    $item["LastName"] = $row."surname";
    $item["Mobile"] = $row."Mobile";
    $item["Ext #"] = $row."Extension";
    $item["Emp #"] = $row."employeenumber";
    $item["Initials"]= $row."Initial";
    $item["HireDate"]= $row."anniversary";
    $item["SPS-Birthday"]= $row."birthday";
    $item["PictureURL"]= $row."PictureURL";
    $item.Update();
}