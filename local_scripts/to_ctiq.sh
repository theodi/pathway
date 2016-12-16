#!/bin/bash
export WORKING_DIR=`cd $(dirname "$0")/.. && pwd`
echo $WORKING_DIR

echo "About to do a real rsync from `git rev-parse --abbrev-ref HEAD` to ctiq-blue"
echo "These files will be copied up..."
rsync -rOclptDvzhn -e "ssh -i /Users/mulhollm/.ssh/etpuppet -p 22225" --filter="- coverage**" --filter="- .git**" --filter="- tmp**" --filter="- Application Log" --filter="- log**" --filter="- db**" --filter="- local_scripts**" ${WORKING_DIR}/* qcifdev@localhost:/local/home/qcifdev/theodi/pathway/
echo "Press any key to continue..."
read $temp

rsync -rOclptDvzh -e "ssh -i /Users/mulhollm/.ssh/etpuppet -p 22225" --filter="- coverage**" --filter="- .git**" --filter="- tmp**" --filter="- Application Log" --filter="- log**" --filter="- db**" --filter="- local_scripts**" ${WORKING_DIR}/* qcifdev@localhost:/local/home/qcifdev/theodi/pathway/

