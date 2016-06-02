

Add-PSSnapin Microsoft.Sharepoint.Powershell

$SITEURL = "http://afesp1"

$site = new-object Microsoft.SharePoint.SPSite ( $SITEURL )
$web = $site.OpenWeb()

$oList = $web.Lists["Employee Database"];

$collListItems = $oList.Items;
$count = $collListItems.Count - 1

for($intIndex = $count; $intIndex -gt -1; $intIndex--)
{
        $collListItems.Delete($intIndex);
} 