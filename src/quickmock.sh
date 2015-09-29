#! /bin/bash
# quick mocking library
# 

SQM_Init()
{
    local src="$(dirname $(readlink -f $BASH_SOURCE))"

    . ${src}/support.sh
    . ${src}/stub.sh
}

SQM_Init