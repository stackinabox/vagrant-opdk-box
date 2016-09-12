#!/bin/bash

sed -i 's|/usr/local/bin/heat-engine|# /usr/local/bin/heat-engine|g' /opt/stack/devstack/stack-noscreenrc
sed -i 's|/usr/local/bin/heat-api|# /usr/local/bin/heat-api|g' /opt/stack/devstack/stack-noscreenrc
sed -i 's|/usr/local/bin/heat-api-cfn|# /usr/local/bin/heat-api-cfn|g' /opt/stack/devstack/stack-noscreenrc
sed -i 's|/usr/local/bin/heat-api-cloudwatch|# /usr/local/bin/heat-api-cloudwatch|g' /opt/stack/devstack/stack-noscreenrc

ps -o pid,args -e | grep -e /usr/local/bin/heat-api-cloudwatch \
   -e /usr/local/bin/heat-api-cfn \
   -e /usr/local/bin/heat-api \
   -e /usr/local/bin/heat-engine | \
   grep -v 'grep' | \
   awk '{print "kill -9 " $1}' | \
   sh