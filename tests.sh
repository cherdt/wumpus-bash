#!/bin/bash

source includes.sh

test_equal () {
    if [ $1 -eq $2 ]
    then
        echo "PASS"
        return 0
    fi
    echo "FAIL"
    return 1
}

test_equal $(translate_computer_to_human 0) 1
test_equal $(translate_computer_to_human 2) 2
test_equal $(translate_computer_to_human 4) 3
test_equal $(translate_computer_to_human 6) 4
test_equal $(translate_computer_to_human 8) 5
test_equal $(translate_computer_to_human 10) 6
test_equal $(translate_computer_to_human 12) 7
test_equal $(translate_computer_to_human 14) 8
test_equal $(translate_computer_to_human 16) 9
test_equal $(translate_computer_to_human 18) 10
test_equal $(translate_computer_to_human 1) 11
test_equal $(translate_computer_to_human 3) 12
test_equal $(translate_computer_to_human 5) 13
test_equal $(translate_computer_to_human 7) 14
test_equal $(translate_computer_to_human 9) 15
test_equal $(translate_computer_to_human 11) 16
test_equal $(translate_computer_to_human 13) 17
test_equal $(translate_computer_to_human 15) 18
test_equal $(translate_computer_to_human 17) 19
test_equal $(translate_computer_to_human 19) 20


test_equal $(translate_human_to_computer 1) 0
test_equal $(translate_human_to_computer 2) 2
test_equal $(translate_human_to_computer 3) 4
test_equal $(translate_human_to_computer 4) 6
test_equal $(translate_human_to_computer 5) 8
test_equal $(translate_human_to_computer 6) 10
test_equal $(translate_human_to_computer 7) 12
test_equal $(translate_human_to_computer 8) 14
test_equal $(translate_human_to_computer 9) 16
test_equal $(translate_human_to_computer 10) 18
test_equal $(translate_human_to_computer 11) 1
test_equal $(translate_human_to_computer 12) 3
test_equal $(translate_human_to_computer 13) 5
test_equal $(translate_human_to_computer 14) 7
test_equal $(translate_human_to_computer 15) 9
test_equal $(translate_human_to_computer 16) 11
test_equal $(translate_human_to_computer 17) 13
test_equal $(translate_human_to_computer 18) 15
test_equal $(translate_human_to_computer 19) 17
test_equal $(translate_human_to_computer 20) 19
