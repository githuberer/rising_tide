#!/usr/bin/env bash

. /etc/profile.d/rvm.sh

HOME=/root

param=$1
__file__=$(realpath $0)
apphome=$(dirname $__file__)
log=$apphome/logs/app.log
pid=$apphome/rack.pid


test -d $(dirname $log) || mkdir $(dirname $log)
test -d $apphome/upload || mkdir $apphome/upload

case $param in
    start)
        echo -en "\nStart Rising_tide ... "
        if [[ ! -f $pid ]]
        then
            cd $apphome && (nohup rackup -o 0.0.0.0 -p 4444 -P $pid &> $log &)
            sleep 1 

            if [[ -f $pid ]]; then
                echo -e "[ \e[32mOK\e[0m ] \n"
                #echo -e "[ \e[32mOK\e[0m ]  pid: $(<$pid) \n"
            else
                echo -e "\e[31m start apps invoke error,check logs below:\e[0m \n"
                cat $apphome/logs/app.log
            fi
        else
            echo -e "\n \e[31m Rising_tide is already running, pid: $(<$pid). 
            Unless pleaase remove \"$apphome/pid\" file, and start it again.\e[0m \n"
            exit
        fi
        ;;
    stop)
        echo -en "\nStop  Rising_tide ... "
        if [[ -f $pid ]]; then
            kill -9 $(<$pid) && echo -e "[ \e[32mOK\e[0m ] \n"
            rm $pid
        else
            echo -e "\e[31mRising_tide not running, at least pid file is empty.\e[0m \n"
            exit
        fi
        ;;
    status)
        echo ""
        ps -ef |grep $apphome |grep -v "grep" |grep -v "vim"
        echo ""
        ;;
    restart)
        $__file__ stop
        sleep 1
        $__file__ start
        ;;
    *)
        echo -e "\n PARAMS: start | stop | status \n"
        ;;
esac


