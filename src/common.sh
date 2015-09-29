#! /bin/bash
# quickmock common library
# provides some global variables:
#   - QUICKMOCK_DOUBLES: list of all existing doubles (should not be updated directly)

# track a new double
# @param string $1 name of the double to track
QuickMock.trackDouble()
{
    QUICKMOCK_DOUBLES="${QUICKMOCK_DOUBLES} $1"
    QUICKMOCK_DOUBLES="$(QuickMock.support.normalizeSpaces ${QUICKMOCK_DOUBLES})"
}

# release one or many doubles
# @param string[] $@ list of double names to release
QuickMock.releaseDoubles()
{
    local stubs="$@"

    if [ -z "${stubs}" ]; then
        stubs="${QUICKMOCK_DOUBLES}"
    fi

    for stub in ${stubs[@]}; do
        QUICKMOCK_DOUBLES="${QUICKMOCK_DOUBLES/${stub}/}"
        unset "${stub}"
        QuickMock.support.revertFunction "${stub}"
    done

    QUICKMOCK_DOUBLES="$(QuickMock.support.normalizeSpaces ${QUICKMOCK_DOUBLES})"
}