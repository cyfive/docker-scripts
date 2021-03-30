#!/bin/bash

#
# Script for run command in container namespace
# Based on StackOverflow hint
# Stanislav V. Emens <stas@emets.su>
#

# if not set environment variable DEBUG
DEBUG=${DEBUG:-0}

if [ $DEBUG -gt 1 ]; then
    set -xe
else
    set -e
fi

cmd=""
only_container=""

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -c|--container)
        shift
        only_container="$1"
        ;;
        -h|--help)
        usage
        exit 0
        ;;
        *)
        cmd="$cmd $1"
        ;;
    esac
    shift
done

function usage() {
    echo
    echo "Usage:"
    echo "  $0 -c|--container <container name or id> <command>"
    echo
    echo " -c | --container run command in container namespace with name or id, if empty in all namespaces."
    echo " command to run in namespace. default is empty."
    echo " -h | --help show this help"
    echo
}

if [ -z "$cmd" ]; then
    usage
    exit 1
fi

if [ -z "$only_container" ]; then
    containers=$(docker ps --format {{.ID}})
else
    containers=$only_container
fi

pids=$(docker inspect -f '{{.State.Pid}}' $containers)
for pid in $pids; do
    nsenter -t $pid -n $cmd
done