#!/bin/bash
#back up databases by dump, and upload *.sql files to remote server.
#before using this, you need to touch a dailyconfig and sundayconfig file with database names inside.
logfile=/tmp/backup/mysqlbackup.log

echo "-------------------------------" >> $logfile
echo "$(date) backupsql starts " >> $logfile
echo "-------------------------------" >> $logfile

#change config file when sunday
configfile=/tmp/backup/dailyconfig
weekday=$(date +%w)
if [ "$weekday" == 0 ]
then 
    configfile=/tmp/backup/sundayconfig
fi
array=($(cat $configfile|grep -v ^#|grep -v ^$))
for dbname in ${array[@]};
do
    echo "woking on $dbname" >> $logfile
    dbuser=root
    backuppath=/tmp/backup/datafiles/"$weekday"

    if [ ! -d "$backuppath" ]
    then
        mkdir $backuppath
    fi
    dumpfile="$backuppath"/"$dbname".sql

#    oldfile="$backuppath""$dbname"$(date +%y%m%d --date='5 days ago').sql

#delete old file
#    if [ -f $oldfile ]
#    then
#        rm -f $oldfile >> $logfile 2>$1
#        echo "delete old file success" >> $logfile
#    fi
    mysqldump -u $dbuser --opt $dbname > $dumpfile 2>>$logfile
done

#upload to remote server

rsync -axz /tmp/backup/datafiles/ demo@192.168.1.202:~/tmp/sqlbackups/ 2>>$logfile

echo "------------------------------" >>$logfile
echo "[$(date)] work finished" >>$logfile
