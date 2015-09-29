#! /bin/bash

################ Utilities #################
# get the full name of this script
me()
{
    echo "$(readlink -f $BASH_SOURCE)"
}

# get the path of parent directory of this script
mydir()
{
    echo "$(dirname $(me))"
}

# get the path of the project main directory
maindir()
{
    local curdir="$(mydir)"

    while \
        [ ! -e "${curdir}/lib" ] && \
        [ ! -e "${curdir}/src" ] && \
        [ ! -e "${curdir}/tests" ] && \
        [ "${curdir}" != "/" ]; do

        curdir="$(dirname ${curdir})"
    done

    echo "${curdir}"
}

# get the path of the source directory
srcdir()
{
    echo "$(maindir)/src"
}

# get the path of the test directory
qatestdir()
{
    echo "$(maindir)/tests"
}

# get the path of the main lib directory
libdir()
{
    echo "$(maindir)/lib"
}

############## End Utilities ###############
. $(libdir)/shell-testlib/bootstrap.sh

load $(srcdir)/quickmock.sh

############ Integration tests #############
testMockingWithShouldReceive()
{
    QuickMock.newMock "mock" "$(shouldReceive a b c)"

    assertTrue "Should pass" "mock a b c"
    assertFalse "Should not pass" "mock a b"
}

testMockingWithShouldNotReceive()
{
    QuickMock.newMock "mock" "$(shouldNotReceive a c)"

    assertTrue "Should pass" "mock b"
    assertTrue "Should pass" "mock"
    assertTrue "Should pass" "mock ana ccc"
    assertFalse "Should not pass" "mock a b"
    assertFalse "Should not pass" "mock c b"
}

testMockingWithAndReturn()
{
    local expected="val1 val2"

    QuickMock.newMock "mock" "$(andReturn ${expected})"

    assertEquals "expected values should be returned" "${expected}" "$(mock)"
}

testMockingWithSeveralExpectations()
{
    local expected="value for a"

    QuickMock.newMock "mock" "$(shouldReceive a)" "$(shouldNotReceive b)" "$(andReturn ${expected})"

    assertEquals "expected values should be returned" "${expected}" "$(mock a)"
    assertEquals "expected values should be returned" "${expected}" "$(mock a)"
    assertNotEquals "expected values should not be returned" "${expected}" "$(mock)"
    assertFalse "Should fail" "mock b"
}

###### Setup / Teardown #####
tearDown()
{
    QuickMock.releaseDoubles
}

################ RUN shunit2 ################
findShunit2()
{
    local curdir=$(dirname $(readlink -f "$1"))
    while [ ! -e "${curdir}/lib/shunit2" ] && [ "${curdir}" != "/" ]; do
        curdir=$(dirname ${curdir})
    done

    if [ "${curdir}" == "/" ]; then
        echo "Error Shunit2 not found !" >&2
        exit 1
    fi

    echo "${curdir}/lib/shunit2"
}

exitOnError()
{
    echo "$2" >&2
    exit $1
}
#
path=$(findShunit2 "$BASH_SOURCE")
code=$?
if [ ${code} -ne 0 ]; then
    exitOnError ${code} "${path}"
fi
. "${path}"/source/2.1/src/shunit2
#
# version: 0.2.2
