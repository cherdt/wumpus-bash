#!/bin/bash

translate_computer_to_human () {
    echo $(((($1/2)+1)+(($1%2)*10)))
}

translate_human_to_computer () {
    local SOLUTION=$((((($1-1)%10)*2)+($1/10)))
    # hack below because I haven't found a general solution
    if [ $(($1%10)) -eq 0 ]
    then
        let "SOLUTION = SOLUTION - 1"
    fi
    echo $SOLUTION
}

display_moves () {
    local MOVES=''
    for NODE in $*
    do
        MOVES="$(translate_computer_to_human $1) $MOVES"
        shift
    done
    echo "Possible moves: $(echo $MOVES | tr ' ' '\n' | sort -n | paste -d' ' -s)"
}
