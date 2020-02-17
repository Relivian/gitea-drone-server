# gitea-drone-server
Gitea-Drone http server setup with docker-compose

## Introduction

This little project provides a docker-compose.yml and configuration files for a minimum setup of a Gitea/Drone server.
It is set up for use in a VPN which also means that SSL configuration for HTTPS connection is not (yet) added, but it can be done easily.

## Setup

After checking out the project only the settings in the docker .env file and the two passwords in setup/create_mysql.sql have to be adapted, but the setup will also work with these default passwords.

### Setup in .env

**Note: You may uncomment also the ports if you intend to expose these ports on the host system. This example uses the containers default ports that are only exposed on the containers IP address instead of allowing the docker daemon to make the system listening to the mapped ports on all devices.**
This means that Gitea's ssh port (22) can be used beside an existing ssh service on the host system.
Simply follow the comments and self-explaining values in the .env file.

### Setup in setup/create_mysql.sql

Just make sure that changed password match the according ones in .env

### Setup in docker-compose.yml

Actually here is nothing to do except you want to make changes to the installation for own reasons. 
Note that all ports are accessed directly by the hostnames. This setup allows that existing services (as ssh) can be used simultaneously with this installation. There's no need to expose these ports on the host system and that is why they are commented out.
If you do so make sure that these ports don't clash with existing ports on the host system. 

### Setup the network

Docker-compose will automaticalla create a bridge network named "gitnet" which hosts the containers. Fix IP addresses will be assigned to each container. The installation requires that these addresses are accessible by hostnames. The hostnames will be part uf the URL schmeme when using the services. To make the containers accessible on the host routing must be enabled. 
If you use firewalld the following statements should do the trick;
```
# GOGS/GITEA port:
firewall-cmd --zone=external --add-port=3000/tcp --permanent
# DRONE port:
firewall-cmd --zone=external --add-port=8000/tcp --permanent
# MySQL port (usually not needed since it's only internally needed):
firewall-cmd --zone=external --add-port=3306/tcp --permanent
firewall-cmd --reload
```
### Setup DNS

There are several ways to setup domain name resolution. The easiest way is to add the names to /etc/hosts:
```
192.168.10.3   mariadb         mariadb.local.home
192.168.10.4   gitea           gitea.local.home
192.168.10.5   drone           drone.local.home
192.168.10.6   drone-runner    docker-runner.local.home
192.168.10.7   ssh-runner      ssh-runner.local.home
```
This maps all hostnames to the IP addresses on Dockers gitnet. This setup makes sure that the domain local.home won't be resolved publicly.
The downside of this approach is that these hosts have to be added to /etc/hosts on all computers that access Gitea/Drone services.

Better would be to add the names to your local DNS server.
If you use bind the zone file would look like this:
```
$TTL 2D
@               IN SOA          host.mydomain.tld.     root.host.mydomain.tld. (
                                2019111500      ; serial
                                3H              ; refresh
                                1H              ; retry
                                1W              ; expiry
                                1D )            ; minimum

local.home.     IN NS           host.mydomain.tld.
mariadb         IN A            192.168.10.3
gitea           IN A            192.168.10.4
drone           IN A            192.168.10.5
docker-runner   IN A            192.168.10.6
ssh-runner      IN A            192.168.10.7
```
Up to this point the GOGS setup will look pretty much the same.

### Browser Setup

When using Gitea you have to click on ‘Sign In’ first.

Change all fields that contain localhost to your actual host name (like the database host or Application URL) not only because of the given hints, but especially because the software runs in containers where localhost points to the loopback device of the container and not to the host system.

Even though the UI suggests UTF8 collation for the MySQL database, select UTF8MB4 collation instead as it is recommended by the Gogs documentation and as it is provided by the SQL script.

If you exposed the ports on the host system and changed the Gitea port from 3000, for instance, to 8080 make sure that you add this port to the field “Application URL” (e.g. http://gitea.local.home:8080) and leave the the field “HTTP Port” at 3000. Otherwise connecting to your Gitea service can get a bit more tricky after the next restart (it’s worth to read the installation instructions)

Set the gitea user and password in the SQL field (according to setup.sql and .env file).
The email settings can be a bit confusing:
```
SMTP Host      : enter smtphost.domain.tld:port
From           : the sender email address e.g. gogs@mydomain.tld
Sender Email   : email user name of the sender
Sender password: the sender password
```
SMTP Host      : enter smtphost.domain.tld:port
From           : the sender email address e.g. gogs@mydomain.tld
Sender Email   : email user name of the sender
Sender password: the sender password

## Further Links
[Gitea](https://gitea.io/en-us/) |
[Drone](https://drone.io/) |
[Website](https://dev.aeonsvirtue.com/en/ci-cd-with-gitea-drone-part-i/)


