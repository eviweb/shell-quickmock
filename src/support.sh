#! /bin/bash
# quickmock support library

# normalize spaces
# @param string $1 string to normalize
QuickMock.support.normalizeSpaces()
{
    local subject="$@"

    echo "${subject}"
}

# check if a function exists
# @param string $1 function name to check
QuickMock.support.functionExists()
{
    local ret=1

    if [ "$(type -t $1)" == "function" ]; then
        ret=0
    fi

    return $ret
}

# revert a previous function overwritten by its double
# @param string $1 function name to revert
QuickMock.support.revertFunction()
{
    local backup="QMS_old$1"

    if QuickMock.support.functionExists "${backup}"; then
        local definition="$(declare -f ${backup})"
        local reverted="${definition/QMS_old/}"

        eval "${reverted}"
    fi
}

