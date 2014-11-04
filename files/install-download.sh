#!/bin/sh
set -e

# https://github.com/Tokutek/mongo/blob/master/docs/building.md


mkdir -p /tmp/mongo-tokumx
cd /tmp/mongo-tokumx

git clone https://github.com/Tokutek/mongo
git clone https://github.com/Tokutek/ft-index
git clone https://github.com/Tokutek/jemalloc
git clone https://github.com/Tokutek/backup-community

(cd mongo; git checkout tokumx-${TOKU_VERSION})
(cd ft-index; git checkout tokumx-${TOKU_VERSION})
(cd jemalloc; git checkout tokumx-${TOKU_VERSION})
(cd backup-community; git checkout tokumx-${TOKU_VERSION})

# free-up space
rm -Rf mongo/.git
rm -Rf ft-index/.git
rm -Rf jemalloc/.git
rm -Rf backup-community/.git
