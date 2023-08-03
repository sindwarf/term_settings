#!/bin/bash

main() {
name=$1

# launch desired program
# nemo &
# xdotool windowsize $PID 0 100
command=nemo
name=Home

windows_launched=$(( $(count_open_windows) + 1 ))
$command &

windows_open=0
while [ $windows_open -lt $windows_launched ]; do
    windows_open=$(count_open_windows) 
done

id="$(xdotool search --onlyvisible --name $name)"
echo $id
xdotool windowmove $id -10 600
}

function count_open_windows() {
    echo $(wmctrl -l | wc -l)
}

function count_open_windows_type() {
    echo $(wmctrl -l | wc -l)
}

function red_bold() {
    echo -e "\e[1m$(echo -e "\e[31m\e[0m")\e[0m"
}

main "$@"
