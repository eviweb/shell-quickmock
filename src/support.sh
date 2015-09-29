#! /bin/bash
# quickmock support library

# normalize spaces
# @param string $1 string to normalize
QuickMock.support.normalizeSpaces()
{
    local subject=( $(QuickMock.support.trim "$@") )

    echo "${subject[@]}"
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
    local prefix="$(QuickMock.support.backupPrefix)"
    local backup="${prefix}$1"

    if QuickMock.support.functionExists "${backup}"; then
        local definition="$(declare -f ${backup})"
        local reverted="${definition/${prefix}/}"

        eval "${reverted}"
    fi
}

# return the prefix used to save overwritten commands
QuickMock.support.backupPrefix()
{
    echo "SQM_OLD_"
}


# remove leading and trailing spaces from a given expression
# @param string $1 expression
# @see taken from bashfu's answer http://stackoverflow.com/a/3352015
QuickMock.support.trim()
{
    local subject="$*"
    subject="${subject#${subject%%[![:space:]]*}}"   # remove leading whitespace characters
    subject="${subject%${subject##*[![:space:]]}}"   # remove trailing whitespace characters

    echo -n "$subject"
}
