#!/bin/bash

set -uex -o pipefail

usage_exit() {
    echo "Usage: $0 [OPTION...]
    [-J JMETER_PROPERTY] [-f SCENARIO_FILE_NAME]" >&2
    exit 1
}

jmeter_properties=()
AWS_REGION=${AWS_REGION:-ap-northeast-1}
SCENARIO_FILE_NAME=${SCENARIO_STARTPOINT_FILE_NAME:-example.jmx}

while getopts J:s:f:h OPT
do
    case $OPT in
        J)
            jmeter_properties+=( "$OPTARG" )
            ;;
        f)
            SCENARIO_FILE_NAME="$OPTARG"
            ;;
        h)
            usage_exit
            ;;
        :)
            usage_exit
            ;;
        \?)
            usage_exit
            ;;
    esac
done

logfile_name=result.jtl
jmeter_options=(-n -t "senarios/${SCENARIO_FILE_NAME}" -l "$logfile_name")
jmeter_options+=( $(printf -- '-J \"%s\" ' "${jmeter_properties[@]}") )

jmeter "${jmeter_options[@]}"
cat 'result.jtl'
