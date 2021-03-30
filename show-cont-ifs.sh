#!/bin/bash

#
# Show associated network interfaces with docker containers
# Based on script stealed from StackOverflow
# Stanislav V. Emets <stas@emets.su>
#

# if not set environment variable DEBUG
DEBUG=${DEBUG:-0}

if [ $DEBUG -gt 1 ]; then
    set -xe
else
    set -e
fi

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
    esac
    shift
done

function usage() {
    echo
    echo "Usage:"
    echo "  $0 -c|--container <container name or id>"
    echo
    echo " -c | --container show interface for container with name or id. Default value is empty."
    echo " -h | --help show this help."
    echo
}

if [ -z "$only_container" ]; then
    containers=$(docker ps --format "{{.ID}}|{{.Names}}")
else
    containers=$(docker ps --format "{{.ID}}|{{.Names}}" | grep "$only_container")
fi

interfaces=$(ip ad);

for x in $containers; do
    name=$(echo "$x" | cut -d '|' -f 2);
    id=$(echo "$x" | cut -d '|' -f 1)
    ifaceNum="$(echo $(docker exec -it "$id" cat /sys/class/net/eth0/iflink) | sed s/[^0-9]*//g):"
    ifaceStr=$(echo "$interfaces" | grep $ifaceNum | cut -d ':' -f 2 | cut -d '@' -f 1);
    echo -e "$name: $ifaceStr";
done
