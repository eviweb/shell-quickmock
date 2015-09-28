#! /bin/bash
# Quick Mock Library Boostraper
# provides all base necessary features to work with this library

SQM_Boot()
{
    local src="$(dirname $(readlink -f $BASH_SOURCE))/src"

    . ${src}/quickmock.sh
}

######################################
SQM_Boot