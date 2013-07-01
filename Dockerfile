# VERSION               0.2
# DOCKER-VERSION        0.4.0

from    ubuntu:12.04
run     echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
run     apt-get -y update
run     apt-get -y install git
run     cd /opt; git clone https://github.com/Countly/countly-server.git countly --depth 1
run     bash /opt/countly/bin/countly.install.sh

expose :80
cmd  supervisord -n
