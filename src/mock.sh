#! /bin/bash
# quickmock mocking library

QuickMock.newMock()
{
    OLDIFS=$IFS
    IFS=$'\n'
    local mock="$1"
    shift
    local id="$(date +%s%N)_"
    local expectations=( $@ )
    local body=""

    if [ $# -lt 1 ]; then
        echo "What did you expect ?" >&2
        exit 1
    fi

    for expectation in ${expectations[@]}; do
        local trimed="$(QuickMock.support.trim ${expectation})"
        local name="$(QuickMock.expectation.extractName ${trimed})"
        QuickMock.expectation.checkNamePattern "${name}"

        eval "${id}${trimed}"

        if QuickMock.expectation.shouldGetCallingArguments "${name}"; then
            body="${body} ${id}${name} \$@ && "
        else
            body="${body} ${id}${name} && "
        fi        
    done
    body="${body/% && /;}";
    IFS=$OLDIFS
    #
    eval "${mock}() { ${body} }"

    QuickMock.trackDouble "${mock}"
}
