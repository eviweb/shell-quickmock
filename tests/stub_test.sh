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
testQuickMockStubbing()
{
    local cmd="ls --version"
    local realvalue="$(${cmd})"
    local expected="something else"

    QuickMock.newStub "ls" "echo $expected"
    assertSame "expected value should be returned" "${expected}" "$(${cmd})"

    # release stub to prevent side effects
    unset ls
    assertSame "realvalue should be returned" "${realvalue}" "$(${cmd})"
}

testStubBodyCanBeOmitted()
{
    QuickMock.newStub "mycmd"

    assertTrue "mycmd should return 0" mycmd
    unset mycmd
}

testQuickMockStubsAreTracked()
{
    local expected="mycmd1 mycmd2 mycmd3"
    assertNull "QUICKMOCK_DOUBLES should not exists" "${QUICKMOCK_DOUBLES}"

    QuickMock.newStub "mycmd1"
    QuickMock.newStub "mycmd2"
    QuickMock.newStub "mycmd3"

    assertSame "QUICKMOCK_DOUBLES should list all stubs" "${expected}" "${QUICKMOCK_DOUBLES}"
    unset mycmd1 mycmd2 mycmd3
}

testQuickMockReleaseOneStub()
{
    QuickMock.newStub "mycmd1"
    QuickMock.releaseDoubles "mycmd1"

    assertNull "mycmd1 should no more exist" "$(type -t mycmd1)"
    assertNull "mycmd1 should no more be tracked" "${QUICKMOCK_DOUBLES}"
}

testQuickMockReleaseManyStubs()
{
    QuickMock.newStub "mycmd1"
    QuickMock.newStub "mycmd2"
    QuickMock.newStub "mycmd3"
    QuickMock.newStub "mycmd4"
    
    QuickMock.releaseDoubles "mycmd2" "mycmd4"

    assertEquals "mycmd1 should still exist" "function" "$(type -t mycmd1)"
    assertEquals "mycmd3 should still exist" "function" "$(type -t mycmd3)"
    assertNull "mycmd2 should no more exist" "$(type -t mycmd2)"
    assertNull "mycmd4 should no more exist" "$(type -t mycmd4)"
    assertSame "QUICKMOCK_DOUBLES should have been updated" "mycmd1 mycmd3" "${QUICKMOCK_DOUBLES}"

    unset mycmd1 mycmd3
}

testQuickMockReleaseAllStubs()
{
    QuickMock.newStub "mycmd1"
    QuickMock.newStub "mycmd2"
    QuickMock.newStub "mycmd3"
    
    QuickMock.releaseDoubles
    assertNull "mycmd1 should no more exist" "$(type -t mycmd1)"
    assertNull "mycmd2 should no more exist" "$(type -t mycmd2)"
    assertNull "mycmd3 should no more exist" "$(type -t mycmd3)"
    assertNull "no more stubs are tracked" "${QUICKMOCK_DOUBLES}"
}

testQuickMockRevertPreviousExistingCommandAfterRelease()
{
    local cmd="ls --version"
    local realvalue="$(${cmd})"

    QuickMock.newStub "ls"
    QuickMock.releaseDoubles

    assertSame "realvalue should be returned" "${realvalue}" "$(${cmd})"
}

testQuickMockRevertPreviousExistingFunctionAfterRelease()
{
    fake()
    {
        echo "fake"
    }

    local realvalue="fake"

    QuickMock.newStub "fake" "echo fake stub"
    QuickMock.releaseDoubles

    assertSame "realvalue should be returned" "${realvalue}" "$(fake)"
    unset fake
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
