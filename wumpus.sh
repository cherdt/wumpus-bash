#!/bin/bash

# Why even make this?
# I felt bad that my Javascript version uses a grid.
# Also, why not?

source includes.sh

PLAYER=0
ADJACENT=''
PREVIOUS=1
WUMPUS=$(seq 1 19 | shuf -n 1)
BATS=$(seq 1 19 | shuf -n 1)
PIT=$(seq 1 19 | shuf -n 1)
ARROW=$(seq 1 19 | shuf -n 1)
ARROWS_REMAINING=3
GAMEOVER=0

is_debug_mode () {
    return 1
}

is_adjacent () {
    return $(echo "$ADJACENT" | grep -q -w $1)
}

get_adjacent () {
    local ADJ1=$((($1+2)%20))
    local ADJ2=$((($1+18)%20))
    local ADJ3=$(($1+1-2*($1%2)))
    echo $ADJ1 $ADJ2 $ADJ3 | tr ' ' '\n' | sort -n | paste -d' ' -s
}

disturb_wumpus () {
    WUMPUS=$(echo $ADJACENT | cut -d' ' -f $(seq 1 3 | shuf -n 1))
}

# takes 1 argument, the destination
move () {
    local MOVE=$(translate_human_to_computer $1)
    if is_adjacent $MOVE
    then
        PREVIOUS=$PLAYER
        PLAYER=$MOVE

        # check wumpus
        if [ $PLAYER -eq $WUMPUS ]; then echo "You've been eaten by a wumpus!"; GAMEOVER=1; fi

        # check pit
        if [ $PLAYER -eq $PIT ]; then echo "You fell down a pit! You died!"; GAMEOVER=1; fi

        # check bats
        if [ $PLAYER -eq $BATS ]; then PLAYER=$(seq 0 19 | shuf -n 1); echo "Bats carried you away!"; fi

        # check arrow
        if [ $PLAYER -eq $ARROW ] 
        then
           echo "You found an arrow!"
           let "ARROW = 999"
           let "ARROWS_REMAINING = ARROWS_REMAINING + 1"
        fi
    else
        echo "Invalid move: $1"
    fi
}

# takes 1 argument, the target
shoot () {
    local TARGET=$(translate_human_to_computer $1)
    if [ $ARROWS_REMAINING -gt 0 ]
    then
        if is_adjacent $TARGET
        then
            if [ $TARGET -eq $WUMPUS ]
            then
                echo "You killed the wumpus! You WIN!"
                exit 0
            fi
            echo "Drats! Missed!"
            let "ARROWS_REMAINING = ARROWS_REMAINING - 1"
            if is_adjacent $WUMPUS
            then
                disturb_wumpus
            fi
        else
            echo "Think you can shoot through rock walls?"
        fi
    else
        echo "No arrows left."
    fi
}

process_command () {
    if [[ $1 =~ ^[0-9]+ ]]
    then
        move $1
    elif [[ $1 =~ ^[Mm] && $# == 2 && $2 =~ ^[0-9]+$ ]]
    then
        move $2
    elif [[ $1 =~ ^[Ss] && $# == 2 && $2 =~ ^[0-9]+$ ]]
    then
        shoot $2
    elif [[ $1 =~ ^[EeQq] ]]
    then
        echo
        echo "You retire to a comfortable life of not hunting wumpuses."
        GAMEOVER=1
    else
        print_help
    fi
}

print_help () {
    echo "Commands are:"
    echo "- (m|move) #"
    echo "- s|shoot #"
    echo "- q|quit"
}

print_intro () {
    echo "###################"
    echo "#                 #"
    echo "# HUNT THE WUMPUS #"
    echo "#                 #"
    echo "###################"
    echo
    echo "You are in a series of dark caverns."
    echo "Like, really dark."
    echo "You can barely see."
    echo "But they are ADA compliant."
    echo "They are numbered in Braille."
    echo "Which, somehow, you can read. Cool!"
    echo
    echo "You are here to hunt the terrifying wumpus."
    echo "You'll know when he's near. You'll smell him."
    echo "Look out for the bottomless pit. And the bats!"
    echo "You have 3 arrows."
}

print_intro

while [ $GAMEOVER -eq 0 ]
do
    echo
    echo "You are in cavern #$(translate_computer_to_human $PLAYER)"
    if is_debug_mode; then echo "W: $WUMPUS, P: $PIT, B: $BATS, A: $ARROW"; fi
    ADJACENT=$(get_adjacent $PLAYER)

    random_event    
    if is_adjacent $WUMPUS
    then
        echo "You smell something awful."
    fi
    if is_adjacent $PIT
    then
        echo "You feel a breeze."
    fi
    if is_adjacent $BATS
    then
        echo "You hear flapping."
    fi


    display_moves $ADJACENT
    echo
    read -p "Enter a command: " COMMAND
    #echo "You entered: $COMMAND"
    process_command $COMMAND

done

exit 0
