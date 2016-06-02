$outfile = C:\services.html

get-service | ConvertTo-Html -Title "Services" -Body "<H2>The result of get-service</H2> " -Property Name,DisplayName,Status | `

foreach 
    {if($_ -like "*<td>Running</td>*"){$_ -replace "<tr>", "<tr bgcolor=green>"}
        
        elseif($_ -like "*<td>Stopped</td>*"){$_ -replace "<tr>", "<tr bgcolor=red>"}
            
            else{$_}} > $outfile

out-file $outfile