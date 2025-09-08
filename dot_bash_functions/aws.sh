#!/bin/bash

source $(dirname $0)/color_echo.sh

awsprof() {
    aws configure list-profiles | head -n 1
}

awslogin() {
    if [[ -z "$1" ]]; then
        PROFILE="$(awsprof)"
    else
        PROFILE="$1"
    fi
    SUCCESS=0
    aws sts get-caller-identity --profile=$PROFILE > /dev/null 2>&1 || SUCCESS=$?
    if [[ $SUCCESS -ne 0 ]]; then
        SUCCESS=0
        aws sso login --profile=$PROFILE || SUCCESS=$?
    fi
    if [[ $SUCCESS -ne 0 ]]; then
        color_echo "$RED" "AWS login failed; try running:"
        echo "$ aws sso login --profile=$PROFILE"
        return 1
    fi
}

awscreds() {
    if [[ -z "$1" ]]; then
        PROFILE="$(awsprof)"
    else
        PROFILE="$1"
    fi
    awslogin $PROFILE
    aws configure export-credentials --format=env --profile=$PROFILE
}
