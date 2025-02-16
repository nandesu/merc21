#! /bin/csh -f
# Written by Furey.
# With additions from Tony.

# Set the port number.
set port = 4000
if ( "$1" != "" ) set port="$1"

# Change to area directory.
cd ./area

# Set limits.
nohup
nice
limit stack 1024k
if ( -e shutdown.txt ) rm -f shutdown.txt

while ( 1 )
    # If you want to have logs in a different directory,
    #   change the 'set logfile' line to reflect the directory name.
    set index = 1000
    while ( 1 )
	set logfile = ../log/$index.log
	if ( ! -e $logfile ) break
	@ index++
    end

    # Run merc.
    ../src/merc $port >&! $logfile

    # Delete this out if no adb.
#    if ( -e core ) then
#	    echo '$c' | adb ../src/merc
#    endif

    # Restart, giving old connections a chance to die.
    if ( -e shutdown.txt ) then
	rm -f shutdown.txt
	exit 0
    endif
    sleep 15
end
