#!/usr/bin/env bash

. /etc/profile.d/rvm.sh

HOME=/root

param=$1
curdir=$(dirname $(realpath $0))

case $param in
    start)
        echo -n "Start Rising_tide ... "
        ( cd $curdir && nohup /usr/bin/env ruby ./app.rb &> /var/log/rising_tide.log &
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
    *)
    echo -e "\n PARAMS: start | stop | status \n"
    ;;
esac



