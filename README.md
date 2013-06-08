linux_scripts
=============

some scripts for manage linux server
1. backupsql:
    在dell上用demo权限运行，remote server备份目录/home/demo/tmp/sqlbackups/,为了运行脚本时免输入密码，在ibm的/home/demo/.ssh目录下存有dell的demo用户的公钥
    目录：/tmp/backup
          --backsql.sh 备份要运行的脚本,注意需要有x的权限
          --datafiles dump的*.sql 文件存放目录，其下以0-6表示周几的备份
          --dailyconfig 配置文件，周一到周六每天要备份的数据库
          --sundayconfig 配置文件，周日要备份的数据库（通常数据量比较大，source_data，historical_data,raw_data）
          --mysqlbackup.log 日志文件
    设置定时任务：
    在demo用户下运行#crontab -e
    插入或修改一条：
    如要每天凌晨00点05分运行backsql.sh脚本
    05 00 * * * /tmp/backup/backsql.sh

2.svn 镜像服务器设置
        svn镜像服务器设置在ibm上。
        svn操作因为权限问题需要root运行，即使将demo加入svn组权限也不够
            用root用户手动运行一次mirror.sh，然后将update.sh加入每日任务即可。
        请注意脚本中包含svn用户信息！
    2.1初始化各资源库
        目录:/home/svn/
             --mirror.sh 初始化各repos脚本，需要手动运行一次
             --config 配置文件，需要初始化的资源库
             因为运行一次没有log文件，请检查屏幕输出来验证是否有错。
    2.2每日同步脚本
        目录：/home/svn
              --update.sh 需要每日运行的脚本，需要x权限
              --updateconfig 配置文件，需要每日更新的资源库
              --svnupdate.log 日志文件
        设置定时任务：
        在root用户下#crontab -e
        每天凌晨00点15分运行
        15 00 * * * /home/svn/update.sh
    
    2.3需要切换时，在eclipse资源库-需要修改的资源上-右键-重新定位（relocate）即可切换到镜像服务器

3.tomcat重新部署
    请用demo用户运行。
    注意，脚本会先删除DashBoard和RaiyunService目录，所以已运行的report数据会被清空。如只需重新部署dashboard，可参考/home/demo/startall.sh
    脚本目录:/home/demo/
             --redeploy.sh 重新部署需要运行的脚本
             --config 配置文件，需要重新部署的tomcat目录
    1.将需要部署的war包放到相应的tomcat webapps目录下
    2.#sh redeploy.sh即可
    3.#ps aux|grep tomcat|grep -v grep 可查看tomcat运行状况，目前应该有7个tomcat