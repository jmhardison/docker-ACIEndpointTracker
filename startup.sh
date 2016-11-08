#!/bin/bash
#set -e
########################################
# jmhardison/docker-ACIEndpointTracker
# Defines the startup logic between 
# running as a polling agent or running
# as a webgui node.
########################################
printf "Startup of ACITracker"


if [ ${GUI} ]
    #GUI is set to true, launch GUI web server.
    printf "GUI Mode Enabled - MYSQL Server ${MYSQLIP}"
    sh -c python /var/acitoolkit/applications/endpointtracker/aci-endpoint-tracker-gui.py -i ${MYSQLIP} -a ${MYSQLADMINLOGIN} -s ${MYSQLPASSWORD}
else
    #GUI is false or not defined, launch the polling agent.
    printf "Polling Agent Enabled - MYSQL Server ${MYSQLIP}"
    sh -c python /var/acitoolkit/applications/endpointtracker/aci-endpoint-tracker.py -u ${APICURL} -l ${APICUSERNAME} -p ${APICPASSWORD} -i ${MYSQLIP} -a ${MYSQLADMINLOGIN} -s ${MYSQLPASSWORD}
fi


