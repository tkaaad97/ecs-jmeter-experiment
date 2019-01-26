#!/bin/bash

set -uex -o pipefail

usage_exit() {
    echo "Usage: $0 [-J JMETER_PROPERTY] [-f SCENARIO_FILE_NAME] [-R REMOTE_HOSTS]" >&2
    exit 1
}

jmeter_properties=()
AWS_REGION=${AWS_REGION:-ap-northeast-1}
SCENARIO_FILE_NAME=${SCENARIO_STARTPOINT_FILE_NAME:-example.jmx}
REMOTE_HOSTS=''

while getopts J:f:R:h OPT
do
    case $OPT in
        J)
            jmeter_properties+=( "$OPTARG" )
            ;;
        f)
            SCENARIO_FILE_NAME="$OPTARG"
            ;;
        R)
            REMOTE_HOSTS="$OPTARG"
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
jmeter_options=(-n -t "senarios/${SCENARIO_FILE_NAME}" -l "$logfile_name" '-Jserver.rmi.ssl.disable=true' )

for prop in "${jmeter_properties[@]}"; do
    jmeter_options+=( -J"$prop" )
done

if [ -n "$REMOTE_HOSTS" ]; then
    jmeter_options+=( -R "$REMOTE_HOSTS" )
fi

jmeter "${jmeter_options[@]}"
cat 'result.jtl'
