#!/bin/bash
trap "tput reset; tput cnorm; exit" 2 # when signal 2 (SIGINT, caused by pressing Ctrl+C) is received, reset the
                                      # terminal (tput reset), make the cursor visible (tput cnorm), and exit
clear # clear the screen
tput civis # make the cursor invisible
lin=2
col=$(($(tput cols) / 2)) # used to center the tree
c=$((col-1)) # used to place the trunk
est=$((c-2)) # not used?
color=0 # used for the lights
tput setaf 2; tput bold # set the foreground (text) color to 2, i.e green (tput setaf 2) and make the text bold (tput bold)

# Tree
for ((i=1; i<20; i+=2)) # add one additional character on the left and one on the right each line; 10 (20 / 2) lines total
{
    tput cup $lin $col # move the cursor to the start of this line
    for ((j=1; j<=i; j++)) # for every character in the line...
    {
        echo -n \* # output an asterisk (the "-n" switch prevents a new line from being outputed)
    }
    let lin++ # go to next line
    let col-- # move start column one character to the left to keep text centered
}

tput sgr0; tput setaf 3 # reset text attributes, i.e. unbold (tput sgr0), then set text color to 3, i.e brownish, the trunk color (tput setaf 3)

# Trunk
for ((i=1; i<=2; i++)) # trunk is two lines tall
{
    tput cup $((lin++)) $c # move to start of this line of the trunk, then increment the line number for next time
    echo 'mWm' # print this line of the trunk
}
new_year=$(date +'%Y') # get current year, padded with zeroes on the left if necessary (it won't be)
let new_year++ # make it into next year
tput setaf 1; tput bold # make text red (foreground color 1) and bold
tput cup $lin $((c - 6)); echo MERRY CHRISTMAS # print "MERRY CHRISTMAS" centered on the next line below the trunk
tput cup $((lin + 1)) $((c - 10)); echo And lots of CODE in $new_year # print centered on line below "MERRY CHRISTMAS" (only
                                                                      # properly centers text for new years up to 9999)
let c++
k=1

# Lights and decorations
while true; do
    for ((i=1; i<=35; i++)) {
        # Turn off the lights
        [ $k -gt 1 ] && {
            tput setaf 2; tput bold
            tput cup ${line[$[k-1]$i]} ${column[$[k-1]$i]}; echo \*
            unset line[$[k-1]$i]; unset column[$[k-1]$i]  # Array cleanup
        }

        li=$((RANDOM % 9 + 3))
        start=$((c-li+2))
        co=$((RANDOM % (li-2) * 2 + 1 + start))
        tput setaf $color; tput bold   # Switch colors
        tput cup $li $co
        echo o
        line[$k$i]=$li
        column[$k$i]=$co
        color=$(((color+1)%8))
        # Flashing text
        sh=1
        for l in C O D E
        do
            tput cup $((lin+1)) $((c+sh))
            echo $l
            let sh++
            sleep 0.01
        done
    }
    k=$((k % 2 + 1))
done
