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

# setup vagrant user with ssh keys
mkdir -p ~vagrant/.ssh
ssh-keygen -t rsa -N "" -f ~vagrant/.ssh/id_rsa -C "vagrant@stackinabox.io"

# create new keypair on openstack for the 'admin' user using vagrants ssh pub/priv keys
nova keypair-add --pub-key ~vagrant/.ssh/id_rsa.pub --key-type ssh admin

public_key=`cat ~vagrant/.ssh/id_rsa.pub`
private_key=`cat ~vagrant/.ssh/id_rsa`

# setup root and vagrant user's for no-password login via ssh keys
echo | sudo /bin/sh <<EOF
mkdir -p /root/.ssh
echo '#{private_key}' > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
echo '#{ops_private_key}' > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
echo '#{ops_private_key}' > /root/.ssh/id_rsa.pub
chmod 644 /root/.ssh/id_rsa.pub
EOF

# turn off strict host key checking for the vagrant user
echo 'Host *' > ~vagrant/.ssh/config
echo StrictHostKeyChecking no >> ~vagrant/.ssh/config
chown -R vagrant: ~vagrant/.ssh

sudo bash -c "echo 'Host *' > /root/.ssh/config"
sudo bash -c "echo StrictHostKeyChecking no >> /root/.ssh/config"
sudo bash -c "chown -R root: /root/.ssh"

cp /vagrant/scripts/tunnel/tunnel.sh /home/vagrant/
chmod 755 /home/vagrant/tunnel.sh
cp /vagrant/scripts/aws/aws-setup.sh /home/vagrant/
chmod 755 /home/vagrant/aws-setup.sh

