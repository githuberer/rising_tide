#!/usr/bin/env bash

. /usr/local/rvm/scripts/rvm

param=$1

case $param in
    start)
        echo -n "Start Rising_tide ... "
        nohup /usr/bin/env ruby /home/wyy/rising_tide/app.rb &> /var/log/rising_tide.log &
        echo $! > /run/rising_tide.pid
        echo "pid: $(cat /run/rising_tide.pid)"
        ;;
    stop)
        kill -9 $(ps -ef |grep app.rb |grep -v "vim" |grep -v "grep" |awk '{print $2}' |paste -s -d " ")
        ;;
    status)
        ps -ef |grep app.rb|grep -v "grep" |grep -v "vim"
        ;;
    *)
    echo -e "\n PARAMS: start | stop | status \n"
    ;;
esac


