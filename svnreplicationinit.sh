#!/bin/bash
#init replication for repos in remote server
svnrepos=/home/svn/repo
hookfilename=hooks/pre-revprop-change
remoteserver=http://192.168.1.222/repos
configfile=/home/svn/config


reponames=($(cat $configfile|grep -v ^#|grep -v ^$))

for reponame in ${reponames[@]};
do
    echo "working on $reponame"
    repodir=$svnrepos/$reponame
    hookfile=$repodir/$hookfilename
    svnadmin create $repodir
    chown -hR svn:svn $repodir
    cp $repodir/$hookfilename.tmpl $repodir/$hookfilename
    chmod 755 $repodir/$hookfilename
    #remove last lines
    sed -i 63,66d $hookfile
    #get and set uuid
    uuid=`svn info $remoteserver/$reponame|grep UUID|sed 's/^.*UUID: //g'`
    svnadmin setuuid $svnrepos/$reponame $uuid

    svnsync init file:///$repodir $remoteserver/$reponame --username=username --password=password
    echo "init [$reponame] finished"
done
echo "all done"
