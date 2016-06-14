# Welcome to **stackinabox.io**

## Introduction

This vagrant project will stand up a single Ubuntu 14.04 running OpenStack Liberty and Docker using Virtualbox. It will pull Docker images for [UrbanCode Deploy](https://hub.docker.com/r/stackinabox/urbancode-deploy/), [UrbanCode Deploy Agent](https://hub.docker.com/r/stackinabox/urbancode-deploy-agent/), [UrbanCode Patterns Blueprint Designer](https://hub.docker.com/r/stackinabox/urbancode-patterns-designer/), and [UrbanCode Patterns Engine](https://hub.docker.com/r/stackinabox/urbancode-patterns-engine/).  Using this vagrant image, once running using vagrant up, you'll be able to design and develop OpenStack HEAT based cloud automation that you can use to deploy applications to the embedded [OpenStack](https://www.blueboxcloud.com/) or to any other cloud provider supported by [UrbanCode Deploy's Blueprint Designer](https://developer.ibm.com/urbancode/products/urbancode-deploy/features/blueprint-designer/) ([Amazon Web Services](https://aws.amazon.com/), [Softlayer](http://www.softlayer.com/), [Azure](https://azure.microsoft.com/), or even your on-prem [VMware vCenter](https://www.vmware.com/products/vcenter-server)).

Using this vagrant environment, it is hoped that you will share the automation that you develop to deploy applications to the cloud with the larger community.  An example of how to share automation is given with the [JKE Banking Application](https://github.com/stackinabox/jke) which can be easily cloned into the running environment and installed via the [init.sh](https://github.com/stackinabox/jke/blob/master/init.sh) script found in the root of the JKE cloned repository.

## Future Integrations

It's planned to add further Docker images to this vagrant setup to support many other deployment automation tools such as:  

  - [Chef Server](https://www.chef.io/chef/) (not yet implemented)
  - [Salt Stack](https://saltstack.com/) (not yet implemented)
  - [Puppet](https://puppet.com/) (not yet implemented)

### Set Up Instructions

#### Prerequisites  

  - Oracle VirtualBox https://www.virtualbox.org/wiki/Downloads  
  - Vagrant https://www.vagrantup.com/downloads.html  

````
    # install a few required vagrant plugins
    vagrant plugin install vagrant-cachier
    vagrant plugin install vagrant-docker-compose
    vagrant plugin install vagrant-multi-hostsupdater
````

#### Getting Started  

````
    # stand up the OpenStack and UrbanCode environment
	git clone https://github.com/stackinabox/stackinabox.io.git 
	cd stackinabox.io/vagrant
	vagrant up
````

After executing the above you can open your local web browser to http://192.168.27.100:9080/landscaper and login with demo/labstack.  The demo user is intended to be the user primarily used for building your automation.  The demo user belongs to a 'demo' team in the UrbanCode Blueprint Designer and has it's own tenant in OpenStack that will be used to run any automation provisioned through the Blueprint Designer on the OpenStack server when logged in as the demo user.  Additional user login information is provided below, under the **Access Information** section, to gain access to the administration views for both the Blueprint Designer as well as for the OpenStack server.

#### Install Example JKE Banking Application  

````
	cd stackinabox.io/vagrant

	# import the example JKE Banking Application automation
	vagrant ssh 
	cd /vagrant/patterns
	git clone https://github.com/stackinabox/jke.git 
	cd jke
	./init.sh
````

If you have never used UrbanCode Deploy or the UrbanCode Blueprint Designer before you can open your browser to the url that is displated at the end of the JKE Banking Application's init.sh script you ran above (http://192.168.27.100:9080/landscaper/view/tutorial) and login as demo/labstack user.  You will see a "guided tour" frame on the right side of your browser window.  Just follow the instructions and it will guide you through how to deploy the JKE Banking Application using UrbanCode Deploy and UrbanCode Blueprint Designer.

#### Halt the running environment without loosing any data/work  

````
	cd stackinabox.io/vagrant

	# halt the running vagrant environment without loosing any data
	vagrant halt
````

#### Resume the running environment with all previous data/work restored  

````
	cd stackinabox.io/vagrant

	# resume the running vagrant environment with all previous data/work restored
	# relies on having previously run 'vagrant halt'
	vagrant up
````

#### Destroy vagrant environment and restart from begining (will loose all existing data/work)  

````
	cd stackinabox.io/vagrant
	
	# destroy existing enviornment and restart from scratch (will loose any existing data/work)
	vagrant destroy
	vagrant up
````

#### Connect UrbanCode Blueprint Designer to Amazon's AWS

````
	cd stackinabox.io/vagrant
	vagrant up
	vagrant ssh

	# once logged into the vagrant box using the previous 'vagrant ssh' command
	./aws-setup.sh
````

#### Access Information

 - OpenStack (DevStack) 
	 - available at http://openstack.stackinabox.io 
		 - username: demo
		 - password: labstack  
		 _____________________  
		 - username: admin
		 - password: labstack
 
 - Docker local passthrough image registry cache (pre-configured to use cache)
    - Registry Web Console
	  - available at http://docker.stackinabox.io:4080
	 
 - UrbanCode Deploy Server
	 - available at http://ucd.stackinabox.io:8080
		 - username: admin
		 - password: admin
		 
 - UrbanCode Deploy Agent
	 - localagent (default for imports)
	 
 - UrbanCode Deploy heat Engine
	 - running at http://heat.stackinabox.io:8004
	 
 - UrbanCode Deploy Blueprint Designer (HEAT Designer)
	 - available at http://designer.stackinabox.io:9080/landscaper
	     - username: demo
	     - password: labstack  
	     _____________________  
		 - username: ucdpadmin
		 - password: ucdpadmin

		 