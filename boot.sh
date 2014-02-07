#!/usr/bin/env bash
param=$1

case $param in
    start)
        nohup ./app.rb &> /dev/null &
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



