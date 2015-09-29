#! /bin/bash
# quickmock expectation library

# check if an expectation name respect the naming convention
# @param string $1 expectation name to check
QuickMock.expectation.checkNamePattern()
{
    if ! [[ "$1" =~ ^__ ]]; then
        echo "An expectation name must begin by __, get '$1', abort." >&2
        exit 1
    fi
}

# extract the name part of a given expectation
# @param string $1 expectation to extract name from
QuickMock.expectation.extractName()
{
    echo "${1%%\(\)*}"
}

# detect whether an expaction requires the mock calling arguments
# @param string $1 expectation name
QuickMock.expectation.shouldGetCallingArguments()
{
    [[ "$1" =~ ^__should ]] || return 1
}

##################################################################
##########################              ##########################
#########################  Expectations  #########################
##########################              ##########################
##################################################################

# check if the mock receive the expected arguments
# @param string[] $@ list of arguments to check
shouldReceive()
{
    echo "__shouldReceive() { [[ \"\$@\" == \"$@\" ]] || { echo \"Failed: expected to receive '$@', but got '\$@'\"; return 1; }; }"
}