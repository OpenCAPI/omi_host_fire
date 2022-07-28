#!/usr/bin/env bash

echo '##############################################################################################'
echo '## Waived errors not found in fire/synthesize.log ############################################'
echo '##############################################################################################'
while read p; do
    if ! grep -Fq "$p" fire/synthesize.log; then
        echo "$p" | sed -ue 's/^.*$/\x1b[41m&\x1b[m/g'
    fi
done < waived_warnings.txt

declare -a logs=("synthesize.log" "implement_*.log")

for log_file in "${logs[@]}"
do
    echo "##############################################################################################"
    echo "## Unwaived errors and warnings in $log_file"
    echo "##############################################################################################"
    grep "^WARNING: " fire/${log_file} | grep -Fvf waived_warnings.txt | sed -ue 's/^WARNING.*$/\x1b[33m&\x1b[m/g'
    grep "^CRITICAL WARNING: " fire/${log_file} | grep -Fvf waived_warnings.txt | sed -ue 's/^CRITICAL WARNING.*$/\x1b[45m&\x1b[m/g'
    grep "^ERROR: " fire/${log_file} | sed -ue 's/^ERROR.*$/\x1b[41m&\x1b[m/g'
done
