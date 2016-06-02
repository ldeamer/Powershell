$SMTPProperties = @{
	To = "lend@americanfire.com"
	From = "IT@americanfire.com"
	Subject = "Testing"
	SMTPServer = "afeexch1.americanfire.local"
                   }

Send-MailMessage @SMTPProperties -Body "Testing!" 