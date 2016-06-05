#!/usr/bin/env bash
#
# We print this script on screen to keep users updated

LOG_ROUTE='/usr/local/rea_richmond/log/info.log'

echo -e "\n\e[35mNotice: \e[1;32mRea Richmond - Preinterview test!\e[0m\n"
sleep 5
tail -f $LOG_ROUTE
