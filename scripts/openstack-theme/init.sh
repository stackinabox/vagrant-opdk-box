#!/bin/bash

cp /vagrant/scripts/openstack-theme/logo.png /opt/stack/horizon/static/dashboard/img/logo.png
cp /vagrant/scripts/openstack-theme/logo-splash.png /opt/stack/horizon/static/dashboard/img/logo-splash.png

mv /vagrant/scripts/openstack-theme/favicon.ico /opt/stack/horizon/static/dashboard/img/favicon.ico