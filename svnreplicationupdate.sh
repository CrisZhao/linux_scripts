#!/bin/bash
#keep replication of repos synchronized with source repos
svnrepos=/home/svn/repo
logfile=/home/svn/svnupdate.log
reponames=($(cat /home/svn/updateconfig|grep -v ^#|grep -v ^$))

for reponame in ${reponames[@]};
do
    echo "working on $reponame ">>$logfile
    repodir=$svnrepos/$reponame

    svnsync synchronize file:///$repodir --source-username=remoteusername --source-password=remotepassword --sync-username=destusername --sync-password=destpassword >>$logfile
    echo "update [$reponame] finished">>$logfile
done
echo "all done $(date)" >>$logfile
