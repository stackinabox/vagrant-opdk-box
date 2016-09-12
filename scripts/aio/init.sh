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

# add aws integration and ssh tunnel scripts to vagrant home directory
cp /vagrant/scripts/tunnel/tunnel.sh /home/vagrant/
chmod 755 /home/vagrant/tunnel.sh
cp /vagrant/scripts/aws/aws-setup.sh /home/vagrant/
chmod 755 /home/vagrant/aws-setup.sh

# /bin/bash -c "/vagrant/scripts/aio/add-agent-install-packages.sh"

# ARTIFACT_URL=http://artifacts.stackinabox.io/urbancode/ibm-ucd-patterns-engine
# ARTIFACT_STREAM=latest
# wget -Nv $ARTIFACT_URL/$ARTIFACT_STREAM.txt
# ARTIFACT_VERSION=${ARTIFACT_VERSION:-$(cat $ARTIFACT_STREAM.txt)}
# ARTIFACT_DOWNLOAD_URL=${ARTIFACT_DOWNLOAD_URL:-$ARTIFACT_URL/$ARTIFACT_VERSION/ibm-ucd-patterns-engine-$ARTIFACT_VERSION.tgz}
# wget -Nv $ARTIFACT_DOWNLOAD_URL

# tar -xf ibm-ucd-patterns-engine-$ARTIFACT_VERSION.tgz
# tar -xf /tmp/ibm-ucd-patterns-install/engine-install/media/engine/plugins/ibm-cloud-ext-*.plugin.tar.gz -C /tmp
# tar -xf /tmp/ibm-ucd-patterns-install/engine-install/media/engine/plugins/ibm-sw-orch-*.plugin.tar.gz -C /tmp

# cd /tmp
# tar -xf ibm-cloud-ext-*.tar.gz
# cd ibm-cloud-ext-*dev*
# sudo python ./setup.py install
# cp -R build/lib.*/ibm_cloud_ext /var/lib/heat/ibm_cloud_ext

# cd /tmp
# tar -xf ibm-sw-orch-*.tar.gz
# cd ibm-sw-orch-*dev*
# sudo python ./setup.py install
# cp -R build/lib.*/ibm_sw_orch /var/lib/heat/ibm_sw_orch

# cd ~
# rm -rf /tmp/ibm-ucd-patterns-install/
# rm -f ibm-ucd-patterns-engine-$ARTIFACT_VERSION.tgz
# rm -rf /tmp/ibm-*

# sudo pip install semver
# sudo pip install logger



# sudo pip install argparse-1.4.0-py2.py3-none-any.whl IPy-0.82a0-py2-none-any.whl \
#     azure-1.0.3.zip	\
#     azure_common-1.0.0-py2.py3-none-any.whl	\
#     azure_mgmt_common-0.20.0-py2.py3-none-any.whl \
#     azure_mgmt_compute-0.20.1-py2.py3-none-any.whl \
#     azure_mgmt_network-0.20.1-py2.py3-none-any.whl \
#     azure_mgmt_nspkg-1.0.0-py2.py3-none-any.whl	\
#     azure_mgmt_resource-0.20.1-py2.py3-none-any.whl	\
#     azure_mgmt_storage-0.20.0-py2.py3-none-any.whl \
#     azure_nspkg-1.0.0-py2.py3-none-any.whl \
#     azure_servicebus-0.20.1-py2.py3-none-any.whl \
#     azure_servicemanagement_legacy-0.20.2-py2.py3-none-any.whl \
#     azure_storage-0.20.3-py2-none-any.whl \
#     boto-2.36.0-py2.py3-none-any.whl \
#     click-5.1-py2.py3-none-any.whl \
#     futures-3.0.4-py2-none-any.whl \
#     httplib2-0.9.2-py2-none-any.whl	\
#     importlib-1.0.3-py2-none-any.whl \
#     MySQL_python-1.2.5-cp27-none-linux_x86_64.whl \
#     nsx_python_sdk-0.0.2-py2.py3-none-any.whl \
#     nsx-python-sdk-0.0.2.tar.gz \
#     poster-0.8.1-py2-none-any.whl \
#     prettytable-0.7.2-py2-none-any.whl \
#     prompt_toolkit-0.53-py2-none-any.whl \
#     Pygments-2.0.2-py2-none-any.whl \
#     python_dateutil-2.4.2-py2.py3-none-any.whl \
#     pyvmomi-5.5.0-py2-none-any.whl \
#     requests-2.7.0-py2.py3-none-any.whl \
#     semver-2.6.0-py2.py3-none-any.whl \
#     six-1.10.0-py2.py3-none-any.whl \
#     SoftLayer-4.1.1-py2.py3-none-any.whl \
#     softlayer_object_storage-0.5.4-py2-none-any.whl \
#     wcwidth-0.1.5-py2.py3-none-any.whl

# echo "to use uclient or any openstack cli tools just ssh into box and execute: "
# echo "            source /home/vagrant/openrc "
# echo ""

# source /home/vagrant/openrc

# add security group rule to allow ssh access
# echo "Open port 22 by default in OpenStack Security Group Rules"
# nova secgroup-add-group-rule default default tcp 22 22

# setup vagrant user with ssh keys
# mkdir -p ~vagrant/.ssh
# ssh-keygen -t rsa -N "" -f ~vagrant/.ssh/id_rsa -C "vagrant@stackinabox.io"

# create new keypair on openstack for the 'admin' user using vagrants ssh pub/priv keys
# nova keypair-add --pub-key ~vagrant/.ssh/id_rsa.pub --key-type ssh admin

# public_key=`cat ~vagrant/.ssh/id_rsa.pub`
# private_key=`cat ~vagrant/.ssh/id_rsa`

# setup root and vagrant user's for no-password login via ssh keys
# echo | sudo /bin/sh <<EOF
# mkdir -p /root/.ssh
# echo '#{private_key}' > /root/.ssh/id_rsa
# chmod 600 /root/.ssh/id_rsa
# echo '#{ops_private_key}' > /root/.ssh/authorized_keys
# chmod 600 /root/.ssh/authorized_keys
# echo '#{ops_private_key}' > /root/.ssh/id_rsa.pub
# chmod 644 /root/.ssh/id_rsa.pub
# EOF

# turn off strict host key checking for the vagrant user
# echo 'Host *' > ~vagrant/.ssh/config
# echo StrictHostKeyChecking no >> ~vagrant/.ssh/config
# chown -R vagrant: ~vagrant/.ssh

# sudo bash -c "echo 'Host *' > /root/.ssh/config"
# sudo bash -c "echo StrictHostKeyChecking no >> /root/.ssh/config"
# sudo bash -c "chown -R root: /root/.ssh"