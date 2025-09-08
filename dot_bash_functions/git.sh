#!/bin/bash

alias main="git rev-parse --abbrev-ref origin/HEAD | sed 's/origin\///'"
gbranch() {
    git branch | grep $1 | head -1 | xargs | sed 's/\** //'
}
alias gmine="git branch | grep annalisem"
alias gitst="git st"
gadd() {
    current_dir=`pwd`
    cd `git top`
    if [ -z $1 ]; then
        to_add="."
    else
        to_add=$1
    fi
    echo "git add $to_add"
    git add $to_add
    cd $current_dir
}
gcommit() {
    if [ $# -eq 0 ]; then
        echo "should supply a message"
        return
    fi
    branch_name=`git branch --show-current`
    jira=`echo $branch_name| ggrep -oP '[A-Z]+-[0-9]+'`
    if [ -z $jira ]; then
        commit_m="$1"
    else
        commit_m="$jira $1"
    fi
    shift
    echo "git commit -m \"$commit_m\" $@"
    git commit -m "$commit_m" $@
}
gpush() {
    branch_name=`git branch --show-current`
    if [ -z $1 ]; then
        echo "git push origin $branch_name"
        git push origin "$branch_name"
    else
        echo "git push $1 origin $branch_name"
        git push $1 origin "$branch_name"
    fi
}
gpull() {
    if [ -z $1 ]; then
        branch_name=`git branch --show-current`
    else
        branch_name=`gbranch $1`
    fi
    echo "git pull origin $branch_name"
    git pull origin "$branch_name"
}
grebase() {
    branch_name=`gbranch $1`
    echo "git rebase $branch_name"
    git rebase $branch_name
}
gbranchcleanup() {
    git fetch -p
    if [[ $1 == "--all" || $1 == "-a" ]]; then
        toprune=$(git branch)
        if [ -z "$toprune" ]; then
            echo "No branches to prune"
        fi
        for branch in $(git branch); do
            branch=$(echo "$branch" | xargs)
            if [[ $branch == "*" ]]; then
                continue
            fi
            if [[ $branch == "`main`" ]]; then
                continue
            fi
            echo "Delete branch? (y/n) $branch"
            read -r -q "answer?"
            echo ""
            if [[ $answer == "y" || $answer == "Y" ]]; then
                git branch -D $branch
            fi
        done
    else
        toprune=$(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}')
        if [ -z "$toprune" ]; then
            echo "No branches to prune"
        fi
        for branch in $(git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'); do
            branch=$(echo "$branch" | xargs)
            echo "Delete branch? (y/n) $branch"
            read -r -q "answer?"
            echo ""
            if [[ $answer == "y" || $answer == "Y" ]]; then
                git branch -D $branch
            fi
        done
    fi
}
gconflicts() {
    current_dir=`pwd`
    cd `git top`
    start=$(grep -r "<<<<<<<" .)
    mid=$(grep -r "=======" .)
    finish=$(grep -r ">>>>>>>" .)
    echo $start
    echo $mid
    echo $finish
    cd $current_dir
}
grestore() {
    git restore --staged $1
    git restore $1
}