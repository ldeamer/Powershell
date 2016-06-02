get-aduser -filter * -searchbase "OU=SBSUSERS,OU=USERS,OU=MYBUSINESS,DC=AMERICANFIRE,DC=LOCAL" `
                     -properties givenname,surname,birthday | select givenname,surname,birthday | export-csv `
                     -path c:\users\ldeamer\desktop\birthday.csv
