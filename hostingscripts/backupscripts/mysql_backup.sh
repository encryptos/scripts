#mysqldump -u bolan91 -p --databases jobs_illusiveh > jobs_illusiveh.sql | 

#mainarray=($(echo "show databases;" | mysql -u bolan91 -p))

mainarray=("8000bodo_no" "blaamann_co" "blog_pq_no" "illusived" "jobs_illusiveh" "liamwordpress" "mail" "shopsextasy_com" "shopsextasy_no" "testingjobs" "ultrakravmaga" "vsftpd")

for item in ${mainarray[*]}
	
do
	mysqldump -u backupadmin --databases $item > $item\_$(date +%d_%m_%Y).sql
	tar -cvzf $item\_$(date +%d_%m_%Y).gz *.sql
#	tar -cvzf mysql\_$(date +d_%m_%Y).gz *.gz
done

#tar -cvzf $item\_$(date +%d_%m_%Y).gz *.sql
rm -f *.sql
tar -cvzf mysql\_$(date +%d_%m_%Y).gz *.gz
mv mysql\_$(date +%d_%m_%Y).gz /home/backups/daily/$(date +%a)
rm -f *.gz
