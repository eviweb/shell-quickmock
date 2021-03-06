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
testShouldReceive()
{
    local expected="__shouldReceive() { [[ \"\$@\" == \"a b c\" ]] || { echo \"Failed: expected to receive 'a b c', but got '\$@'\"; return 1; }; }"

    assertSame "shouldReceive is correctly formed" "${expected}" "$(shouldReceive a b c)"
}

testShouldNotReceive()
{
    local expected="a c"
    local code

    echo $(shouldNotReceive ${expected}) | grep -oe "for excl in ${expected};" &>/dev/null && code=$?
    assertTrue "expected args: ${expected} should be in exclusion loop" ${code}

    echo $(shouldNotReceive ${expected}) | grep -oe "any of .*${expected}" &>/dev/null && code=$?
    assertTrue "expected args: ${expected} should be in error message" ${code}
}

testAndReturn()
{
    local expected="val1 val2"

    echo $(andReturn ${expected}) | grep -oe "echo \"${expected}\";" &>/dev/null && code=$?
    assertTrue "expected args: ${expected} should be in echo statement" ${code}
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
