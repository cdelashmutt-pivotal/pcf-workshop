#!/bin/sh

#cf create-security-group development-security-group ./development-security-group.json

for email in `cat class-participant-emails.txt` ; do

	org=`echo $email | sed 's/\([^@]*\).*/\1-org/'`
	echo "INFO: Setting up $org: for $email"

	cf bind-security-group $1 $org development

done