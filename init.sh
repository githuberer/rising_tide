#!/usr/bin/env bash

. /etc/profile.d/rvm.sh

HOME=/root
log=log/init.log

param=$1
home_app=$(dirname $(realpath $0))

case $param in
    start)
        echo -n "Start Rising_tide ... "
        ( cd $home_app && nohup /usr/bin/env ruby ./app.rb &> $home_app/$log &
        echo $! > /run/rising_tide.pid )
        echo "pid: $(cat /run/rising_tide.pid)"
        ;;
    stop)
        #kill -9 $(cat /run/rising_tide.pid) ||\
        kill -9 $(ps -ef |grep app.rb |grep -v "vim" |grep -v "grep" |awk '{print $2}' |paste -s -d " ")
        ;;
    status)
        ps -ef |grep app.rb|grep -v "grep" |grep -v "vim"
        ;;
    restart)
        $home_app/init.sh stop
        sleep 1
        $home_app/init.sh start
        ;;
    *)
    echo -e "\n PARAMS: start | stop | status \n"
    ;;
esac


