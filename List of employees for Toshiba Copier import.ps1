get-aduser -filter * `
           -searchbase "OU=SBSUSERS,OU=USERS,OU=MYBUSINESS,DC=AMERICANFIRE,DC=LOCAL" `
           -properties * | select-object givenname,surname,mail | export-csv `
           -path c:\users\ldeamer\desktop\copier.csv
