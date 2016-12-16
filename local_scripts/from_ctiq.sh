#!/bin/bash
export WORKING_DIR=`cd $(dirname "$0")/.. && pwd`
echo $WORKING_DIR

echo "About to do a real rsync from ctiq-blue to `git rev-parse --abbrev-ref HEAD`"
echo "These files will be pulled down..."
rsync -rOclptDvzhn -e "ssh -i /Users/mulhollm/.ssh/etpuppet -p 22225" --filter="- .git**" --filter="- tmp**" --filter="- Application Log" --filter="- log**" --filter="- db**" --filter="- coverage**" qcifdev@localhost:/local/home/qcifdev/theodi/pathway/* ${WORKING_DIR}/
echo "Press any key to continue..."
read $temp

rsync -rOclptDvzh -e "ssh -i /Users/mulhollm/.ssh/etpuppet -p 22225" --filter="- .git**" --filter="- tmp**" --filter="- Application Log" --filter="- log**" --filter="- db**" --filter="- coverage**" qcifdev@localhost:/local/home/qcifdev/theodi/pathway/* ${WORKING_DIR}/

