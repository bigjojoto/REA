#!/usr/bin/env bash
# Install requirements for REA Richmond pre interview
# 
# This script will install wget, and chef-client on a minimal 
# Linux image

#set -x

WORK_DIR=/usr/local/rea_richmond
BIN_DIR=$WORK_DIR/bin
PKG_DIR=$WORK_DIR/pkgs
RCP_DIR=$WORK_DIR/cookbooks
LOG_DIR=$WORK_DIR/log
CON_DIR=$WORK_DIR/conf
SUP_FIL=$CON_DIR/version_support.conf
ERR_LOG=$LOG_DIR/error.log
INF_LOG=$LOG_DIR/info.log
COR_PKG='facter tmux wget'

# Let's clear the screen
cls(){
	if [ -f /usr/bin/clear ]; then
		/usr/bin/clear
	fi
}

# Let's write a Log File
log(){
	if [ `echo $MSG|awk '{print$1}'` -eq 0 ]; then
		echo $(date) $MSG >> $INF_LOG
	elif [ `echo $MSG|awk '{print$1}'` -eq 1 ]; then
		echo $(date) $MSG >> $ERR_LOG
	fi
}

# Shall we clean the old log files?!
clear_log(){
	if [  -f $INF_LOG ]; then
		mv $INF_LOG $INF_LOG.$(date +"%m-%d-%y-%T")
	elif [  -f $ERR_LOG ]; then
		mv $ERR_LOG $ERR_LOG.$(date +"%m-%d-%y-%T")
	fi
}

# What OS are we using today?! Only a guess!
os_type() {
	if [ `which yum > /dev/null; echo $?` -eq 0 ]; then
		OS='RedHat'
		MSG="0 $OS base Operating System found. Only a guess."; log
	elif [ `which apt-get > /dev/null; echo $?` -eq 0 ]; then
		OS='Debian'
		MSG="0 $OS base Operating System found. Only a guess."; log
	else
		MSG="1 Base Operating System not supported."; log
		exit 1
	fi
}

# Function install and upgrade pkgs based on the OS
install_core() {
	if [ $OS == 'Debian' ]; then
		MSG="0 Installing $OS core components and updating OS"; log
		export DEBIAN_FRONTEND=noninteractive
		dpkg --configure -a; /usr/bin/apt-get update -y && /usr/bin/apt-get upgrade -y; /usr/bin/apt-get install -y $COR_PKG
	elif [ $OS == 'RedHat' ]; then
		MSG="0 Installing $OS core components and updating OS"; log
		/usr/bin/yum install -y yum-utils; /usr/bin/yum-config-manager --enable *server*; /usr/bin/yum-config-manager --enable *extra*
		/usr/bin/yum install -y epel-release; /usr/bin/yum upgrade -y; /usr/bin/yum update -y; /usr/bin/yum install -y $COR_PKG
	fi
}

# This is the real OS! This is not a guess, we are not playing around!
os_family(){
	OS_FAMILY=`facter osfamily`
	OS_REALOS=`facter operatingsystem`
	OS_MAJORR=`facter operatingsystemrelease`
	MSG="0 Real OS family $OS_FAMILY detected by facter"; log
	MSG="0 Real OS $OS_REALOS $OS_MAJORR detected by facter"; log
}

# Let's install a Chef client
chef_install() {
        if [ $OS == 'Debian' ]; then
                MSG="0 Installing Chef client for $OS_REALOS $OS_MAJORR"; log
                export DEBIAN_FRONTEND=noninteractive
		CHEF_PKG=`cat $SUP_FIL|grep $OS_REALOS|grep $OS_MAJORR|awk '{print$NF}'`
		wget -P $PKG_DIR $CHEF_PKG; dpkg --install $PKG_DIR/*.deb
        elif [ $OS == 'RedHat' ]; then
                MSG="0 Installing Chef client for $OS_REALOS $OS_MAJORR"; log
		CHEF_PKG=`cat $SUP_FIL|grep $OS_REALOS|grep $OS_MAJORR|awk '{print$NF}'`
                /usr/bin/yum reinstall -y $CHEF_PKG || /usr/bin/yum install -y $CHEF_PKG
        fi

}

# Should we let Chef to take control?!
chef_control(){
	cd $RCP_DIR
        #echo -e "\n\e[35mNotice: \e[1;32mPlease validate the web server...!\e[0m\n"
	chef-client --local-mode --runlist recipe['docker_img']
}

# Main function, where it all begins.
___main___() {
clear_log && os_type && install_core && os_family && chef_install && chef_control
}

___main___
