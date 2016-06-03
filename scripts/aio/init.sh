#!/bin/bash

echo "waiting on servers to complete startup process..."
sleep 60

echo "Configure udclient on box"
curl -O -s -u admin:admin -X GET http://192.168.27.100:8080/tools/udclient.zip
sudo unzip udclient.zip -d /opt
rm -rf udclient.zip

sudo bash -c 'cat >> /home/vagrant/openrc' <<'EOF'

export DS_USERNAME=admin
export DS_PASSWORD=admin
export DS_WEB_URL=http://192.168.27.100:8080
export PATH=$PATH:/opt/udclient/
EOF

echo "to use uclient or any openstack cli tools just ssh into box and execute: "
echo "            source /home/vagrant/openrc "
echo ""

source /home/vagrant/openrc

# add security group rule to allow ssh access
echo "Open port 22 by default in OpenStack Security Group Rules"
nova secgroup-add-group-rule default default tcp 22 22

