#!/usr/bin/env bash

. /etc/profile.d/rvm.sh

HOME=/root

param=$1
home_app=$(dirname $(realpath $0))
log=$home_app/log/app.log
pid=$home_app/app.pid


test -d $home_app/log || mkdir $home_app/log
test -d $home_app/upload || mkdir $home_app/upload
test -f $log || touch $log
test -f $pid || touch $pid

case $param in
    start)
        if [[ -z $(<$pid) ]]
        then
            echo -en "\n Start Rising_tide ... "
            cd $home_app && \
            { 
                nohup /usr/bin/env ruby ./route.rb &> $log &
                echo $! > $pid
            }
            echo -e "pid: $(<$pid) \n"
        else
            echo -e "\n Rising_tide is already running, pid: $(<$pid) \n"
            exit
        fi
        ;;
    stop)
        if [[ -z $(<$pid) ]]
        then
            echo -e "\n Rising_tide not running, at least pid file is empty. \n"
            exit
        else
            echo -en "\n Stop Rising_tide ... "
            {
                kill -9 $(<$pid)
                : > $pid
            }
            echo -e "[ OK ] \n"
        fi
        #kill -9 $(ps -ef |grep route.rb |grep -v "vim" |grep -v "grep" |awk '{print $2}' |paste -s -d " ")
        ;;
    status)
        echo ""
        ps -ef |grep route.rb|grep -v "grep" |grep -v "vim"
        echo ""
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


