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

################ Unit tests ################
testQuickMockMocking()
{
    local mock="mymock"
    local expected="It works"
    local expectation="__doSomething() { echo \"${expected}\"; }"

    QuickMock.newMock "${mock}" "${expectation}"

    assertSame "${mock} should live up to our expectations" "${expected}" "$(${mock})"
    unset ${mock}
}

testAMockShouldAcceptManyExpectations()
{
    local mock="mymock"
    local expected="It works better !"
    local expectation1="__doSomething() { echo -n \"It works \"; }"
    local expectation2="__doAnotherSomething() { echo \"better !\"; }"

    QuickMock.newMock "${mock}" "${expectation1}" "${expectation2}"

    assertSame "${mock} should live up to our expectations" "${expected}" "$(${mock})"
    unset ${mock}
}

testAMockShouldCatchExpectationFailure()
{
    local mock="mymock"
    local expected=1
    local failure="__doSomethingWrong() { return ${expected}; }"

    QuickMock.newMock "${mock}" "${failure}"
    ${mock}

    assertEquals "Returned code should be: ${expected}" ${expected} $?
    unset ${mock}
}

testAMockShouldPassItsCallingArgumentsToCertainExpectations()
{
    local mock="mymock"
    local expected="ok"
    local expectation1="__doSomethingWithoutArguments() { [ -z \"\$@\" ] || return 1; }"
    local expectation2="__shouldGetArguments() { [[ \"\$@\" == \"${expected}\" ]] || return 1; }"

    QuickMock.newMock "${mock}" "${expectation1}" "${expectation2}"

    ${mock} "${expected}"

    assertTrue "${mock} should pass its calling arguments to the right expectation" $?
    unset ${mock}
}

testTwoMocksCanUseTheSameExpectationsWithDifferentValues()
{
    local mock1="mymock1"
    local mock2="mymock2"
    local expectation1="__doSomething() { echo ${mock1}; }"
    local expectation2="__doSomething() { echo ${mock2}; }"

    QuickMock.newMock "${mock1}" "${expectation1}"
    QuickMock.newMock "${mock2}" "${expectation2}"

    assertSame "${mock1} should print its name" "${mock1}" "$(${mock1})"
    assertSame "${mock2} should print its name" "${mock2}" "$(${mock2})"

    unset ${mock1} ${mock2}
}

testQuickMockShouldCheckAnExpectationMustBeginWithTwoUnderscores()
{
    local mock="mymock"
    local failure="wrongExpectationName() { echo should never be reached; }"
    local expected="An expectation name must begin by __, get 'wrongExpectationName', abort."
    local error=$(QuickMock.newMock "${mock}" "${failure}" 2>&1)

    assertSame "The expected error message should be printed" "${expected}" "${error}"

    unset ${mock}
}

testQuickMockRequiresAtLeastOneExpectation()
{
    local mock="mymock"
    local expected="What did you expect ?"
    local error=$(QuickMock.newMock "${mock}" 2>&1)

    assertSame "The expected error message should be printed" "${expected}" "${error}"

    unset ${mock}
}

testQuickMockStubsAreTracked()
{
    local expected="mymock1 mymock2"
    local expectation="__doSomething() { return 0; }"

    QuickMock.newMock "mymock1" "${expectation}"
    QuickMock.newMock "mymock2" "${expectation}"

    assertSame "QUICKMOCK_DOUBLES should list all stubs" "${expected}" "${QUICKMOCK_DOUBLES}"
    unset mymock1 mymock2
}

testQuickMockReleaseMocks()
{
    local expectation="__doSomething() { return 0; }"

    QuickMock.newMock "mymock1" "${expectation}"
    QuickMock.newMock "mymock2" "${expectation}"
    
    QuickMock.releaseDoubles
    
    assertNull "mymock1 should no more exist" "$(type -t mymock1)"
    assertNull "mymock2 should no more exist" "$(type -t mymock2)"
    assertNull "no more stubs are tracked" "${QUICKMOCK_DOUBLES}"
}


###### Setup / Teardown #####
setUp()
{
    unset QUICKMOCK_DOUBLES
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
