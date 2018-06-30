#!/bin/sh

IP=`cat $1/conf.lua|grep db_ip| awk -F"'" '{print $2}'|awk -F":" '{print $1}'`
PORT=`cat $1/conf.lua|grep console_port| awk -F"'" '{print $2}'|awk -F":" '{print $1}'`
echo $IP $PORT
./1.9/tarantoolctl connect $IP:$PORT

