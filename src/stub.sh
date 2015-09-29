#! /bin/bash
# quickmock stubbing library

# create a new stub
# @param string $1 name of the command to get a stub of
# @param string $2 what the stub should do
QuickMock.newStub()
{
    local name="$1"
    local body="$2"

    if [ -z "${body}" ]; then
        body="return 0"
    fi

    if QuickMock.support.functionExists "${name}"; then
        eval "QMS_old$(declare -f ${name})"
    fi

    eval "${name}() { ${body}; }"

    QuickMock.trackDouble "${name}"
}
