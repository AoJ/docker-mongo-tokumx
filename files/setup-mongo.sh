#!/bin/sh

set -e

/usr/bin/mongod --config /etc/tokumx.conf --noauth --noprealloc --nohttpinterface &

sleep 1

echo "" > /tmp/init.js

echo 'db.addUser({ user: "collectd", pwd: "y1SNZ0a004ddxSGoKzLi", roles: [ "clusterMonitor" ] });' >> /tmp/init.js

/usr/bin/mongo admin /tmp/init.js

rm /tmp/init.js

/usr/bin/mongod --shutdown --config /etc/tokumx.conf
