####Welcome to **stackinabox.io**

### GETTING STARTED

This vagrant project will stand up a single Ubuntu 14.04 running OpenStack Liberty and Docker using Virtualbox.

## Set Up Instructions

# Prerequisites  

  - Oracle VirtualBox https://www.virtualbox.org/wiki/Downloads  
  - Vagrant https://www.vagrantup.com/downloads.html  

````
    # install a few required vagrant plugins
    vagrant plugin install vagrant-cachier
    vagrant plugin install vagrant-docker-compose
    vagrant plugin install vagrant-multi-hostupdater

	git clone https://github.com/stackinabox/stackinabox.io.git 
	cd stackinabox.io/vagrant
	cp Personalization.dist Personalization
	vagrant up

	vagrant ssh 
	cd /vagrant/patterns
	git clone https://github.com/stackinabox/jke.git 
	cd jke
	./init.sh
````

After executing the above you can open your local web browser to http://192.168.27.100:9080/landscaper and login with demo/labstack

# Access Information

 - OpenStack (DevStack) 
	 - available at http://192.168.27.100 
		 - username: demo
		 - password: labstack
		 _____________________
		 - username: admin
		 - password: labstack
 
 - Docker local passthrough image registry cache (pre-configured to use cache)
    - Registry Web Console
	  - available at http://192.168.27.100:4080
	 
 - UrbanCode Deploy Server
	 - available at http://192.168.27.100:8080
		 - username: admin
		 - password: admin
		 
 - UrbanCode Deploy Agent
	 - localagent (default for imports)
	 
 - UrbanCode Deploy heat Engine
	 - running at http://192.168.27.100:8004
	 
 - UrbanCode Deploy Blueprint Designer (HEAT Designer)
	 - available at http://192.168.27.100:9080/landscaper
	     - username: demo
	     - password: labstack
	     _____________________
		 - username: ucdpadmin
		 - password: ucdpadmin