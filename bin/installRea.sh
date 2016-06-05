#!/usr/bin/env bash

#
# Nestor Rafael Bolivar
# REA pre interview test
# Installs a base for our deployment and clones our apps from a git repo
#

BASE_SW='tmux git'
APPS_REP='http://github.com/bigjojoto/REA'
TARG_DIR='/usr/local/rea_richmond'
LAUN_APP='/usr/local/rea_richmond/bin/reaRichmond.sh'
SCRE_INF='/usr/local/rea_richmond/bin/reaScreen.sh'

# What OS are we using today?! Only a guess!
os_type() {
        if [ `which yum > /dev/null; echo $?` -eq 0 ]; then
                OS='RedHat'
                yum install -y $BASE_SW
        elif [ `which apt-get > /dev/null; echo $?` -eq 0 ]; then
                OS='Debian'
		apt-get update; apt-get install $BASE_SW
        else
                MSG="1 Base Operating System not supported."; log
                exit 1
        fi
}

# Let's clone and launch the scripts locally
clone_launch () {
	git clone $APPS_REP $TARG_DIR
	tmux new-session -d $LAUN_APP \; split-window -d $SCRE_INF \; attach
}

# Main function, where it all begins.
___main___() {
os_type; clone_launch
}

___main___
