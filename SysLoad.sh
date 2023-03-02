#!/bin/bash
### Script to monitor system load each 1 min
##      ErrorCodes:
#               0:Success
#
#
#
#### Monitor system load at the last 1min, 5mins, and 15mins and storing the values 
SYSLOAD=$(uptime | sed 's/^.*average://g' )
M1=$(echo ${SYSLOAD} | awk 'BEGIN {FS=","} {print $1}')
M2=$(echo ${SYSLOAD} | awk 'BEGIN {FS=","} {print $2}')
M3=$(echo ${SYSLOAD} | awk 'BEGIN {FS=","} {print $3}')
#
#### Getting server ip
IP=$( hostname -I )
#
#### Checking if the system load increases
CH1=$(echo "${M1}>${M2}" | bc)
CH2=$(echo "${M2}>${M3}" | bc)
#
#### Recording logs and events in case of high load
if [ ${CH1} -eq 1 ] || [ ${CH2} -eq 1 ]
then
        # Recording a log with load and date in case of high load
        logger -p local3.crit "system load is ${SYSLOAD} at $(date)"

        # Recording the event to /tmp/events file
        echo -e "Subject: Server ${IP} load \nBody: \n \t Dear, \n \t \t The system ${HOSTNAME} runs with IP ${IP} has a load of \n \t \t 1MIN load: ${M1} \n \t \t 5MIN load:${M2} \n \t \t 15MIN load:${M3} \n \t Thank you ." >> /tmp/events
fi
exit 0
