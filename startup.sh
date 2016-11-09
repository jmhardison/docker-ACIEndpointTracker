#!/bin/bash
#set -e
########################################
# jmhardison/docker-ACIEndpointTracker
# Defines the startup logic between 
# running as a polling agent or running
# as a webgui node.
########################################
printf "Startup of ACITracker\n"


if [ ${GUI} ]; then
    #GUI is set to true, launch GUI web server.
    printf "GUI Mode Enabled - MYSQL Server ${MYSQLIP}\n"
    sh -c "python /usr/local/bin/acitoolkit/applications/endpointtracker/aci-endpoint-tracker-gui.py -i ${MYSQLIP} -a ${MYSQLADMINLOGIN} -s ${MYSQLPASSWORD} --ip 0.0.0.0 --port 80"
else
    #GUI is false or not defined, launch the polling agent.
    printf "Polling Agent Enabled - MYSQL Server ${MYSQLIP}\n"
    sh -c "python /usr/local/bin/acitoolkit/applications/endpointtracker/aci-endpoint-tracker.py -u ${APICURL} -l ${APICUSERNAME} -p ${APICPASSWORD} -i ${MYSQLIP} -a ${MYSQLADMINLOGIN} -s ${MYSQLPASSWORD}"
fi


