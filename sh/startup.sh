#!/bin/sh
# Written by Furey.
# With additions from Tony.

# Set the port number.
port=4000
if [ "$1" != "" ]; then
    port="$1"
fi

# Change to area directory.
cd ./area

# Set limits.
nohup
nice
ulimit -s 1024
if [ -e shutdown.txt ]; then
    rm -f shutdown.txt
fi

while true; do
    # If you want to have logs in a different directory,
    # change the 'logfile' line to reflect the directory name.
    index=1000
    while true; do
        logfile="../log/$index.log"
        if [ ! -e "$logfile" ]; then
            break
        fi
        index=$((index + 1))
    done

    # Run merc.
    ../src/merc "$port" > "$logfile" 2>&1

    # Delete this out if no adb.
    # if [ -e core ]; then
    #     echo '$c' | adb ../src/merc
    # fi

    # Restart, giving old connections a chance to die.
    if [ -e shutdown.txt ]; then
        rm -f shutdown.txt
        exit 0
    fi
    sleep 15
done

