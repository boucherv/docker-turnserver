#!/bin/bash

if [ -z $SKIP_AUTO_IP ] && [ -z $EXTERNAL_IP ]
then
    if [ ! -z USE_IPV4 ]
    then
        EXTERNAL_IP=`curl -4 icanhazip.com 2> /dev/null`
    else
        EXTERNAL_IP=`curl icanhazip.com 2> /dev/null`
    fi
fi

if [ -z $PORT ]
then
    PORT=3478
fi
if [ -z $PORT_RANGE_MIN ]
then
    PORT_RANGE_MIN=49152  
fi
if [ -z $PORT_RANGE_MAX ]
then
    PORT_RANGE_MAX=49252  
fi
if [ ! -e /tmp/turnserver.configured ]
then
    if [ -z $SKIP_AUTO_IP ]
    then
        echo external-ip=$EXTERNAL_IP > /etc/turnserver.conf
    fi
    echo listening-port=$PORT >> /etc/turnserver.conf
    echo min-port=$PORT_RANGE_MIN >> /etc/turnserver.conf
    echo max-port=$PORT_RANGE_MAX >> /etc/turnserver.conf
    echo "user=ouss:test" >> /etc/turnserver.conf
    if [ ! -z $LISTEN_ON_PUBLIC_IP ]
    then
        echo listening-ip=$EXTERNAL_IP >> /etc/turnserver.conf
    fi

    touch /tmp/turnserver.configured
fi

exec /usr/bin/turnserver --no-cli >>/var/log/turnserver.log 2>&1
