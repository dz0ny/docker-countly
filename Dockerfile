FROM base

env   DEBIAN_FRONTEND noninteractive

# REPOS
run    apt-get install -y software-properties-common
run    add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
run    add-apt-repository -y ppa:chris-lea/node.js
run    add-apt-repository -y ppa:nginx/stable
run    apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
run    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list
run    apt-get --yes update
run    apt-get --yes upgrade --force-yes
run    apt-get --yes install git supervisor nginx --force-yes

#SHIMS
run    dpkg-divert --local --rename --add /sbin/initctl
run    ln -s /bin/true /sbin/initctl

# TOOLS
run    apt-get install -y -q curl git wget

## MONGO
run    mkdir -p /data/db
run    apt-get install -y -q mongodb-10gen

## NODE
run    apt-get install -y -q nodejs
env   DEBIAN_FRONTEND dialog

run    mkdir -p /data/log
run    cd /opt; git clone https://github.com/Countly/countly-server.git countly --depth 2
run    apt-get install -y -q imagemagick sendmail build-essential --force-yes 
run    apt-get install -y -q nginx --force-yes
run    cd /opt/countly/api ; npm install time 
run    rm /etc/nginx/sites-enabled/default
run    cp  /opt/countly/bin/config/nginx.server.conf /etc/nginx/sites-enabled/default

run    cp  /opt/countly/frontend/express/public/javascripts/countly/countly.config.sample.js  /opt/countly/frontend/express/public/javascripts/countly/countly.config.js
run    cp  /opt/countly/api/config.sample.js  /opt/countly/api/config.js
run    cp  /opt/countly/frontend/express/config.sample.js  /opt/countly/frontend/express/config.js

add    ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
add    ./supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf
add    ./supervisor/conf.d/mongodb.conf /etc/supervisor/conf.d/mongodb.conf
add    ./supervisor/conf.d/countly.conf /etc/supervisor/conf.d/countly.conf

expose :80
volume ["/data"]
ENTRYPOINT ["/usr/bin/supervisord"]