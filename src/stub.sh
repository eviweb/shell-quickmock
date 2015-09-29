#! /bin/bash
# quickmock stubbing library
# provides some global variables:
#   - QUICKMOCK_STUBS: list of all existing stubs (should not be updated directly)

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

    QuickMock.trackStub "${name}"
}

# track a new stub
# @param string $1 name of the stub to track
QuickMock.trackStub()
{
    QUICKMOCK_STUBS="${QUICKMOCK_STUBS} $1"
    QUICKMOCK_STUBS="$(QuickMock.support.normalizeSpaces ${QUICKMOCK_STUBS})"
}

# release one or many stubs
# @param string[] $@ list of stub names to release
QuickMock.releaseStubs()
{
    local stubs="$@"

    if [ -z "${stubs}" ]; then
        stubs="${QUICKMOCK_STUBS}"
    fi

    for stub in ${stubs[@]}; do
        QUICKMOCK_STUBS="${QUICKMOCK_STUBS/${stub}/}"
        unset "${stub}"
        QuickMock.support.revertFunction "${stub}"
    done

    QUICKMOCK_STUBS="$(QuickMock.support.normalizeSpaces ${QUICKMOCK_STUBS})"
}