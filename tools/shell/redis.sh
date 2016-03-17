#!/bin/sh
cmd=$1
redis-server /usr/local/etc/redis.conf ${cmd}
