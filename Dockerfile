#Dockerfile for creating the web tier of ACI Endpoint Tracker
#You only need one of these containers running to harvest information from ACI.
#Other containers you may want are a GUI front end and the actual MySQL DB container.
FROM ubuntu:16.04
MAINTAINER Jonathan Hardison <jmh@jonathanhardison.com>

#expose these ports for when operating as a GUI server.
EXPOSE 80

#Environment Variables - these should be provided at runtime instead based on actual deployment.
#ENV APICURL http://ipofapic or https://fqdnofasic
#ENV APICUSERNAME APICUserText
#ENV APICPASSWORD APICPasswordText
#ENV MYSQLIP IPofMYSQLServer
#ENV MYSQLADMINLOGIN UserText
#ENV MYSQLPASSWORD PasswordText
#ENV GUI TRUE/FALSE

ENV DEBIAN_FRONTEND noninteractive

ADD ./startup.sh /usr/local/bin/startup.sh

#performing a download of tar instead of clone to try and reduce file size of images.
RUN apt-get update && apt-get -y install curl python python-pip && \
    cd /tmp && \
    curl -o acitoolkit.tar.gz https://codeload.github.com/datacenter/acitoolkit/legacy.tar.gz/master && \
    mkdir acitoolkit && \
    tar -xzvf acitoolkit.tar.gz -C ./acitoolkit --strip-components=1 && \
    mv acitoolkit/ /usr/local/bin/acitoolkit/ && \
    cd /usr/local/bin/acitoolkit && \ 
    python setup.py install && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get -y remove curl python-pip && apt-get -y autoremove && apt-get clean && \
    chmod +x /usr/local/bin/startup.sh

#launch command is startup.sh which drives the logic to use either GUI or Polling Agent.
CMD ["/usr/local/bin/startup.sh"]


