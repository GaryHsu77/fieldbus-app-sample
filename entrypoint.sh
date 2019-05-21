#!/bin/sh

if [ ! -z ${APPMAN_TAGSERVICE_ADDR+x} ];then
    # thingspro environment
    echo "${APPMAN_TAGSERVICE_ADDR}    localhost" > /etc/hosts
fi

mkdir -p /etc/fieldbusd
exec /usr/bin/fbcontroller ./protocol.json