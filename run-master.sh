#!/bin/bash

set -uex -o pipefail

usage_exit() {
    echo "Usage: $0 [-G JMETER_PROPERTY] [-J JMETER_PROPERTY] [-f SCENARIO_FILE_NAME] [-R REMOTE_HOSTS]" >&2
    exit 1
}

global_properties=()
jmeter_properties=()
AWS_REGION=${AWS_REGION:-ap-northeast-1}
SCENARIO_FILE_NAME=${SCENARIO_STARTPOINT_FILE_NAME:-example.jmx}
REMOTE_HOSTS=''

while getopts G:J:f:R:h OPT
do
    case $OPT in
        G)
            global_properties+=( "$OPTARG" )
            ;;
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

for prop in "${global_properties[@]}"; do
    jmeter_options+=( -G"$prop" )
done

if [ -n "$REMOTE_HOSTS" ]; then
    jmeter_options+=( -R "$REMOTE_HOSTS" )
fi

jmeter "${jmeter_options[@]}"
cat 'result.jtl'
