#Docker ACI Endpoint Tracker
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

##Provision MySQL
Both the polling agent and the GUI server require access to the same backend MySQL server(s). The following deployment
is not indicative of full production impelemntations, but is an example start. This method of deployment will map the
database storage location to an external path allowing upgrades of MySQL to occurr without losing data. (Ensure you still
backup as required for retention.)
