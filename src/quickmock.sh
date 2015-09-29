#! /bin/bash
# quick mocking library
# 

SQM_Init()
{
    local src="$(dirname $(readlink -f $BASH_SOURCE))"

    . ${src}/support.sh
    . ${src}/common.sh
    . ${src}/expectation.sh
    . ${src}/stub.sh
    . ${src}/mock.sh
}

SQM_Init