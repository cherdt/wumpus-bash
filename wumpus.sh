#!/bin/bash

# Why even make this?
# I felt bad that my Javascript version uses a grid.
# Also, why not?

PLAYER=0
ADJACENT=''
PREVIOUS=1
WUMPUS=$(seq 1 19 | shuf -n 1)
BATS=$(seq 1 19 | shuf -n 1)
PIT=$(seq 1 19 | shuf -n 1)
ARROW=$(seq 1 19 | shuf -n 1)
ARROWS_REMAINING=3
GAMEOVER=0

is_adjacent () {
    return $(echo "$ADJACENT" | grep -q -w $1)
}

get_adjacent () {
    local ADJ1=$((($1+2)%20))
    local ADJ2=$((($1+18)%20))
    local ADJ3=$(($1+1-2*($1%2)))
    echo $ADJ1 $ADJ2 $ADJ3 | tr ' ' '\n' | sort -n | paste -d' ' -s
}

check_wumpus () {
    if [ $1 -eq $2 ]
    then
        return 0
    fi
    return 1
}

# takes 1 argument, the destination
move () {
    if is_adjacent $1
    then
        PREVIOUS=$PLAYER
        PLAYER=$1

        # check wumpus
        if [ $PLAYER -eq $WUMPUS ]; then echo "You've been eaten by a wumpus!"; exit 0; fi
        # check pit
        if [ $PLAYER -eq $PIT ]; then echo "You fell down a pit! You died!"; exit 0; fi
        # check bats
        if [ $PLAYER -eq $BATS ]; then PLAYER=$(seq 0 19 | shuf -n 1); echo "Bats carried you away!"; fi
    else
        echo "Invalid move: $1"
    fi
}

# takes 1 argument, the target
shoot () {
    if [ $ARROWS_REMAINING -gt 0 ]
    then
        if is_adjacent $1
        then
            if [ $1 -eq $WUMPUS ]
            then
                echo "You killed the wumpus! You WIN!"
                exit 0
            fi
            echo "Drats! Missed!"
            let "ARROWS_REMAINING = ARROWS_REMAINING - 1"
        else
            echo "Think you can shoot through rock walls?"
        fi
    else
        echo "No arrows left."
    fi
}

next_step () {
    echo next step    
}

process_command () {
    if [[ $1 =~ ^[0-9]+ ]]
    then
        move $1
    elif [[ $1 =~ ^[Mm] ]]
    then
        move $*
    elif [[ $1 =~ ^[Ss] ]]
    then
        shoot $2
    elif [[ $1 =~ ^[Bb] ]]
    then
        move $1
    elif [[ $1 =~ ^[Ff] ]]
    then
        move $1
    elif [[ $1 =~ ^[Ll] ]]
    then
        move $1
    elif [[ $1 =~ ^[Rr] ]]
    then
        move $1
    elif [[ $1 =~ ^[EeQq] ]]
    then
        GAMEOVER=1
    else
        print_help
    fi
}

print_help () {
    echo "Commands are:"
    echo "- (M|MOVE) (LEFT|RIGHT|BACK)"
    echo "- (S|SHOOT) (LEFT|RIGHT|BACK)"
    echo "- (Q|QUIT)"
}

echo "###################"
echo "#                 #"
echo "# HUNT THE WUMPUS #"
echo "#                 #"
echo "###################"
echo
echo "You are in a dark cavern."
echo "Like, really dark."
echo "You can barely see."
echo "You have 3 arrows."


while [ $GAMEOVER -eq 0 ]
do
    ADJACENT=$(get_adjacent $PLAYER)
    echo "Valid moves: $ADJACENT"
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
    if is_adjacent $ARROW
    then
        echo "You found an arrow!"
        let "ARROW = 999"
        let "ARROWS_REMAINING = ARROWS_REMAINING + 1"
    fi
    echo "Enter a command:"
    read COMMAND
    #echo "You entered: $COMMAND"
    process_command $COMMAND


done

exit 0
