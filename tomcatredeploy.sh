#!/bin/bash
#redeploy *.war for multi tomcat. To use this, config your tomcat parent dirs in config file first. 
tomcatversion=apache-tomcat-6.0.36
webappsdir=$tomcatversion/webapps
configfile=/tmp/config
array=($(cat $config|grep -v ^#|grep -v ^$))
for inputdir in ${array[@]};
do
    echo "dealing $inputdir"
    pidlist=`ps aux|grep $inputdir|grep -v grep|awk '{print $2}'`
    echo "pidlist: $pidlist"
    if [ ${#pidlist[*]} == 1 ]; then
        echo "killing $pidlist"
        kill -9 $pidlist
        rm -r $inputdir/$webappsdir/yourprojectname1 $inputdir/$webappsdir/yourprojectname2
        sh $inputdir/$tomcatversion/bin/startup.sh
    fi
done
