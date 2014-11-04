#!/bin/sh

set -e

mkdir -p /var/lib/tokumx/
mkdir -p /var/log/tokumx/
if [ -f /sys/kernel/mm/transparent_hugepage/enabled ]; then
	if grep -q "\[always\]" /sys/kernel/mm/transparent_hugepage/enabled; then
		echo "Error disabling transparent_hugepages, are you running in a linux container?" >&2
		echo "If the server fails to start, check that transparent hugepages are disabled." >&2
	fi
fi

if [ ! -f /.mongo_admin_created ]; then
	echo "Creating users"

	echo "=> starting mongo"
	/usr/bin/mongod --config /etc/tokumx.conf --noauth --noprealloc --nohttpinterface &
	sleep 1

	COLLECTD_PASS=$(pwgen -s 16 1)
	ADMIN_PASS=$(pwgen -s 16 1)
	USER_PASS=$(pwgen -s 16 1)

	sed -i -r "s/\{PASS\}/${COLLECTD_PASS}/" /etc/collectd/collect.d/mongodb.conf

	echo "" > /tmp/init.js
        echo "db.addUser({ user: \"collectd\", pwd: \"${COLLECTD_PASS}\", roles: [ \"clusterMonitor\" ] });" >> /tmp/init.js
        echo "db.addUser({ user: \"admin\", pwd: \"${ADMIN_PASS}\", roles: [ \"clusterAdmin\", \"dbAdminAnyDatabase\" ] });" >> /tmp/init.js
        echo "db.addUser({ user: \"user\", pwd: \"${USER_PASS}\", roles: [ \"readWriteAnyDatabase\" ] });" >> /tmp/init.js

	/usr/bin/mongo admin /tmp/init.js
	rm /tmp/init.js

	echo "-------------------------------"
	echo ""
	echo "mongo collectd pass: ${COLLECTD_PASS}"
	echo "mongo admin pass: ${ADMIN_PASS}"
	echo "mongo user pass: ${USER_PASS}"
	echo ""
	echo "-------------------------------"


	touch /.mongo_admin_created

	PID=`ps x | grep -v grep | grep mongod | awk '{ print $1 }'`
	kill -2 ${PID}
	sleep 1
fi
