#!/bin/ash
# Set the port number.
port=4000
if [ "$1" != "" ]; then
    port="$1"
fi

# Change to area directory.
cd ./area

# Set limits.
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
nohup    ../src/merc "$port" > "$logfile" 2>&1

    # Restart, giving old connections a chance to die.
    if [ -e shutdown.txt ]; then
        rm -f shutdown.txt
        exit 0
    fi
    sleep 15
done

