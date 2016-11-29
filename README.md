[![](https://images.microbadger.com/badges/version/jhardison/aciendpointtracker.svg)](https://microbadger.com/images/jhardison/aciendpointtracker "Get your own version badge on microbadger.com")
# Docker ACI Endpoint Tracker
Cisco ACI Endpoint Tracker, leveraging ACIToolkit.

This dockerfile provides the ability to launch either a polling agent or a GUI Server.
  * Polling Agent - Responsible for retrieving information from APIC and writing it to MySQL. One per install.
  * GUI Server - Provides web accessible simple website to interact with data in MySQL. Can be load balanced.

The following environment variables must be defined based on mode.

  * Polling Agent
    * APICURL - IP or FQDN of the APIC controller. Format example: http://10.1.1.1
    * APICUSERNAME - Valid username with access to APIC.
    * APICPASSWORD - Password text for valid user.
    * MYSQLIP - IP of the MySQL server.
    * MYSQLADMINLOGIN - Valid admin login for MySQL.
    * MYSQLPASSWORD - Password text for valid admin login.
  * GUI Server
    * GUI - A value of TRUE enables GUI mode.
    * MYSQLIP - IP of the MySQL server.
    * MYSQLADMINLOGIN - Valid admin login for MySQL.
    * MYSQLPASSWORD - Password tet for valid admin login.

In the case that the GUI variable is not defined, it will default to a polling agent.

## Create Environment File (Optional)
To simplify command lines below, you can utilize an environment variable file to supply variables to containers. This file provides a simple NAME=VALUE listing.

  * Create a file under /opt/ or a path of your choosing called acienv.list and ensure it has the following contents.
  
    ```APICURL=http://ipofapic
    APICUSERNAME=usernamehere
    APICPASSWORD=passwordhere
    MYSQLIP=ipofmysqlordockerhostiphere
    MYSQLADMINLOGIN=adminloginnamehere
    MYSQLPASSWORD=adminpasswordhere
    ```
  * Use "with environment file" steps below.
  

## Provision MySQL
Both the polling agent and the GUI server require access to the same backend MySQL server(s). The following deployment is not indicative of full production impelemntations, but is an example start. This method of deployment will map the database storage location to an external path allowing upgrades of MySQL to occurr without losing data. (Ensure you still backup as required for retention.)

  - Create DB File path
    
    `sudo mkdir /opt/mysqldata` 
    
  - Adjust File Path Permissions
    
    `sudo chown root:docker /opt/mysqldata`

    `sudo chmod u=rwX,g=rX,o=rX /opt/mysqldata`

  - Deploy MySQL Container
    
    * Without environment file:

      `sudo docker run -p 3306:3306 -d --name acidb --restart always -v /opt/mysqldata:/var/lib/mysql:rw -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_DATABASE=endpointtracker -e MYSQL_USER={MYSQLADMINLOGIN here} -e MYSQL_PASSWORD={MYSQLPASSWORD here} mysql`
    
    * With environment file:

      `sudo docker run -p 3306:3306 -d --name acidb --restart always -v /opt/mysqldata:/var/lib/mysql:rw --env-file /path/to/acienv.list mysql`

## Provision Polling Agent
    
  * Without environment file:

    `sudo docker run -d --name acipollingagent --restart always --read-only -e APICURL={http://iporfqdnhere} -e APICUSERNAME={usernamehere} -e APICPASSWORD={passwordhere} -e MYSQLIP={mysqliphere} -e MYSQLADMINLOGIN={MYSQLADMINLOGIN here} -e MYSQL_PASSWORD={MYSQLPASSWORD here} jhardison/aciendpointtracker`

  * With environment file:
      
    `sudo docker run -d --name acipollingagent --restart always --read-only --env-file /path/to/acienv.list jhardison/aciendpointtracker`

## Provision GUI Server
The deployment of the GUI in the following steps assumes the port being used to map to the container is standard HTTP(80). If you need an alternate port, configure as needed.
  * Without environment file:

    `sudo docker run -p 80:80 -d --name aciguiserver --restart always --read-only -e GUI=true -e MYSQLIP={mysqliphere} -e MYSQLADMINLOGIN={MYSQLADMINLOGIN here} -e MYSQL_PASSWORD={MYSQLPASSWORD here} jhardison/aciendpointtracker`

  * With environment file:
      
    `sudo docker run -p 80:80 -d --name aciguiserver --restart always --read-only -e GUI=true --env-file /path/to/acienv.list jhardison/aciendpointtracker`

## Test GUI
With the components deployed, you should now be able to open the web console for the GUI. Browse to the following path to test access:

`http://ipofdockerhost` or if using a custom port, `http://ipofdockerhost:portusedhere`

## Validate Logs
All the deployed containers logs can be viewed through the use of the following command.

  `sudo docker logs acidb`

  `sudo docker logs acipollingagent`

  `sudo docker logs aciguiserver`

While other methods should be employed to consolidate logs and ship to external services such as a central syslog server, this provides an immediate bare minimum method to troubleshoot containers.