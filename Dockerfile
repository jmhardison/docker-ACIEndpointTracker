#Dockerfile for creating the web tier of ACI Endpoint Tracker
#You only need one of these containers running to harvest information from ACI.
#Other containers you may want are a GUI front end and the actual MySQL DB container.
FROM python:latest
MAINTAINER Jonathan Hardison <jmh@jonathanhardison.com>

#Environment Variables - these should be provided at runtime instead based on actual deployment.
ENV APICURL http://127.0.0.1
ENV APICUSERNAME replaceuser
ENV APICPASSWORD replacepass
ENV MYSQLIP 127.0.0.1
ENV MYSQLADMINLOGIN mysqluser
ENV MYSQLPASSWORD MYSQLPASSWORD

ENV DEBIAN_FRONTEND noninteractive

RUN cd /var && \ 
    git clone https://github.com/datacenter/acitoolkit.git && \
    cd acitoolkit && \
    python setup.py install

CMD ["sh", "-c", "python /var/acitoolkit/applications/endpointtracker/aci-endpoint-tracker.py -u ${APICURL} -l ${APICUSERNAME} -p ${APICPASSWORD} -i ${MYSQLIP} -a ${MYSQLADMINLOGIN} -s ${MYSQLPASSWORD}"]


