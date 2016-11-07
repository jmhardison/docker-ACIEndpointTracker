#Dockerfile for creating the web tier of ACI Endpoint Tracker
#You only need one of these containers running to harvest information from ACI.
#Other containers you may want are a GUI front end and the actual MySQL DB container.
FROM ubuntu:16.04
MAINTAINER Jonathan Hardison <jmh@jonathanhardison.com>

#Environment Variables - these should be provided at runtime instead based on actual deployment.
#ENV APICURL http://127.0.0.1
#ENV APICUSERNAME replaceuser
#ENV APICPASSWORD replacepass
#ENV MYSQLIP 127.0.0.1
#ENV MYSQLADMINLOGIN mysqluser
#ENV MYSQLPASSWORD MYSQLPASSWORD

ENV DEBIAN_FRONTEND noninteractive

#performing a download of tar instead of clone to try and reduce file size of images.
RUN apt-get update && apt-get -y install curl python python-pip && \
    cd /tmp && \
    curl -o acitoolkit.tar.gz https://codeload.github.com/datacenter/acitoolkit/legacy.tar.gz/master && \
    mkdir acitoolkit && \
    tar -xzvf acitoolkit.tar.gz -C ./acitoolkit --strip-components=1 && \
    mv acitoolkit/ /var/acitoolkit/ && \
    cd /var/acitoolkit && \ 
    python setup.py install && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get -y remove curl python-pip && apt-get -y autoremove && apt-get clean 

CMD ["sh", "-c", "python /var/acitoolkit/applications/endpointtracker/aci-endpoint-tracker.py -u ${APICURL} -l ${APICUSERNAME} -p ${APICPASSWORD} -i ${MYSQLIP} -a ${MYSQLADMINLOGIN} -s ${MYSQLPASSWORD}"]


