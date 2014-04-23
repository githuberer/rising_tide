#!/usr/bin/env bash

. /etc/profile.d/rvm.sh

HOME=/root

param=$1
home_app=$(dirname $(realpath $0))
log=$home_app/log/app.log
pid=$home_app/app.pid

test -f $pid || touch $pid

case $param in
    start)
        if [[ -z $(ps -p $(cat $pid) -o comm=) ]]
        then
            echo -n "Start Rising_tide ... "
            {
                cd $home_app && \
                    ( 
                nohup /usr/bin/env ruby ./app.rb &> $log &
                echo $! > $pid
                )
            }
            echo "pid: $(cat $pid)"
        else
            echo "Rising_tide is already running, pid: $(cat $pid)"
            exit
        fi
        ;;
    stop)
        echo -n "Stop Rising_tide ... "
        kill -9 $(cat $pid)
        : > $pid
        #kill -9 $(ps -ef |grep app.rb |grep -v "vim" |grep -v "grep" |awk '{print $2}' |paste -s -d " ")
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


