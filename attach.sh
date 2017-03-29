#!/bin/sh

IP=`cat $1/conf.lua|grep console_url| awk -F"'" '{print $2}'|awk -F":" '{print $1}'`
PORT=`cat $1/conf.lua|grep console_url| awk -F"'" '{print $2}'|awk -F":" '{print $2}'`
echo $IP $PORT
rlwrap nc $IP $PORT

