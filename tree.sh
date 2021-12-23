#!/bin/bash
trap "tput reset; tput cnorm; exit" 2 # when signal 2 (SIGINT, caused by pressing Ctrl+C) is received, reset the
                                      # terminal (tput reset), make the cursor visible (tput cnorm), and exit
clear # clear the screen
tput civis # make the cursor invisible
lin=2 # start tree on line 2
col=$(($(tput cols) / 2)) # used to center the tree
c=$((col-1)) # used to place the trunk
est=$((c-2)) # not used?
color=0 # used for the lights, starts at color 0 (black)
tput setaf 2; tput bold # set the foreground (text) color to 2, i.e green (tput setaf 2) and make the text bold (tput bold)

# Tree
for ((i=1; i<20; i+=2)) # add one additional character on the left and one on the right each line; 10 (20 / 2) lines total, from line 2 to line 11
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
let c++ # increment c so that it points at the center column of the tree
k=1 # set light stage to "turn on short"

# Lights and decorations
while true; do # loop forever
    for ((i=1; i<=35; i++)) { # 35 lights
        # Turn off the lights
        [ $k -gt 1 ] && { # if we are in a phase greater than 1 (only phase 2 in this case), turn off the previous phase's lights
                          # This means phase 2's lights never get turned off unless they happen to get overwritten by another light
            tput setaf 2; tput bold # set color to green and make text bold (same setting as when drawing the tree)
            tput cup ${line[$[k-1]$i]} ${column[$[k-1]$i]}; echo \* # turn off the light for the current index $i (move to the corresponding location and output '*')
            unset line[$[k-1]$i]; unset column[$[k-1]$i]  # Array cleanup
        }

        li=$((RANDOM % 9 + 3)) # choose a random line number between 3 (just below the top of the tree) and 11 (the bottom of the tree)
        start=$((c-li+2)) # make first ligh possible light position be 1 character into the tree on this line
        co=$((RANDOM % (li-2) * 2 + 1 + start)) # choose random column within the tree for this line, excluding edges (only every other column is valid, though)
        tput setaf $color; tput bold   # Switch colors
        tput cup $li $co # move to the location of the light
        echo o # turn the light on
        line[$k$i]=$li # store the line number of the light
        column[$k$i]=$co # store the column number of the light
        color=$(((color+1)%8)) # cycle colors (black -> red -> green -> yellow -> blue -> magenta -> cyan -> white -> black -> ...)
        # Flashing text
        sh=1 # sets $sh to the offset between $c and location of the word "CODE" on the screen
        for l in C O D E
        do
            tput cup $((lin+1)) $((c+sh)) # move to the location of the letter
            echo $l # output the letter
            let sh++ # go to next letter
            sleep 0.01 # wait for a hundredth of a second before continuing
        done
    }
    k=$((k % 2 + 1)) # switch between phase 1 and phase 2
done
