####Welcome to **stackinabox.io**

This project aims to be a basic resource for building skills in deployment automation, cloud, containers, and just about any other deployment technology you can put on a machine.  The project has evolved from what was a very simple Vagrant project that built a pre-installed Devstack box that you could easily use for learning OpenStack.  It has since evolved to include Docker and it even utilises LXD as the nova-hypervisor for the embedded devstack.  It is still a work in progress but everything is versioned and built via automation so we should be able to prevent any "major" outages due to the ongoing development.

##### GETTING STARTED

This vagrant project will stand up a single Ubuntu 14.04 VM using Virtualbox.  Within that VM there will be the following software pre-installed and running:

 - OpenStack (DevStack) 
	 - available at http://openstack.stackinabox.io 
		 - username: demo
		 - password: labstack
		 
 - Docker
 
 - Docker local passthrough image registry cache (pre-configured to use cache)
  
 - Docker Registry Web Console
	 - available at http://registry.stackinabox.io:4080
	 
 - UrbanCode Deploy Server
	 - available at http://ucd.stackinabox.io:8080
		 - username: admin
		 - password: admin
		 
 - UrbanCode Deploy Agent
	 - localagent
	 
 - UrbanCode Deploy heat Engine
	 - running at http://openstack.stackinabox.io:7000
	 
 - UrbanCode Deploy Patterns Designer
	 - available at http://designer.stackinabox.io:9080/landscaper
		 - username: ucdpadmin
		 - password: ucdpadmin

####Instructions for setting up the embedded BlueBox OpenStack server to work with the embedded UrbanCode Deploy Server & UrbanCode Blueprint HEAT Designer:
 
Log onto the UrbanCode Patterns Designer web console: http://designer.stackinabox.io:9080/landscaper
*username:* ucdpadmin
*password:* ucdpadmin

Navigate to:
*Settings->Users->Create New Realm:*
Use the following values for the settings
*Name*: BlueBox
*Type*: OpenStack Identity Service
*Identity URL*: http://192.168.27.100:5000/v2.0
*Timeout*: 60
*Use default orchestration engine*: false
*Facing Type*: Public
*Orchestration Engine URL*: http://192.168.27.100:7004
*Admin Username*: admin
*Admin Password*: labstack
*Admin Tenant*: admin
*Domain*: Default
 
Save that and click on the blue button "Import Users"
 
Then setup the cloud for that bluebox instance:
 
Settngs->Clouds->BlueBox:
 
Authorization->demo
Functional ID: demo
Password: labstack
 
Click blue "save" button and then "Test Connection" button.  You should see a "test successful" dialog box.
 
Now add our BlueBox users to the "internal team".
 
Settings->Internal Team:
 
Select "admin" from the "User..." drop down and check the "Admin" role for that user.
Select "demo" from the "User..." drop down and check every role except "Admin" for that user
 
Click the blue "save" button.
 
Now add our demo cloud as an authorized cloud for the Internal Team.
 
Click "Cloud Authorization" tab on the Settings->Internal Team page
Click the blue "Add" button and choose the "demo@BlueBox" from the dialog.
Click the blue "save" button.
 
Now logout of Landscaper as ucdpadmin and log back in as demo/labstack user.

Please reach out to me or Freddy (Sudahakar Frederick) with any questions.