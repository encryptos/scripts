#!/bin/bash

#date=`date +%d_%m_%Y`

main_domains=/home/www/html/maindomains/
subdomains=/home/www/html/subdomains/

#Email out messsage, body, subject, recipient.
#echo "Backup: Dailywebsite backup starting...." | mail -s "Daily Websitebackup starting" cubell@adobe.com

main_array=($(ls $main_domains))

#tar -cvzf /home/backups/daily/$(date +%a)liam.illusive-hosting.com_$(date +%d_%m_%Y).tar.gz /home/www/html/subdomains/liam.illusive-hosting.com

for item in ${main_array[*]}
	do
		#tar -cvzf /home/backups/daily/$(date +%a)/$item\_$(date +%d_%m_%Y).tar.gz $main_domains$item

		echo /home/backups/daily/$(date +%a)/$item\_$(date +%d_%m_%Y).tar.gz $main_domains$item
		#echo $item
	done

#for item in ${main_array[*]}
#do
#    emailitem="   %s\n" $item "wooo"
#done

#email_item= ${main_array[*]}

echo $main_array "overhere"

echo "Websites backup ended "$main_array 

echo "Array items and indexes:"

for index in ${!main_array[*]}
do
    printf "%4d: %s\n" $index ${main_array[$index]}
done

 mail -s "Daily Websitebackup complete" cubell@adobe.com



