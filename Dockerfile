# VERSION               0.2
# DOCKER-VERSION        0.4.0

from    ubuntu:12.04
run     echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
run     apt-get -y update
run     apt-get -y install git python-software-properties
run     apt-add-repository ppa:chris-lea/node.js -y
run     echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" > /etc/apt/sources.list.d/mongodb-10gen-countly.list
run     apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
run     apt-get -y update
run     cd /opt; git clone https://github.com/Countly/countly-server.git countly --depth 1
run     bash /opt/countly/bin/countly.install.sh

expose :80
cmd  supervisord -n
