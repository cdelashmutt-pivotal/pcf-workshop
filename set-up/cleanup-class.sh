#!/bin/sh

for email in `cat class-participant-emails.txt` ; do

	org=`echo $email | sed 's/\([^@]*\).*/\1-org/'`
	echo "INFO: Cleaning up $org: for $email"

	cf delete-org $org -f 

done
