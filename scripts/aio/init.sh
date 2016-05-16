#!/bin/bash

echo "waiting on servers to complete startup process..."
sleep 60

# generate a ucd token
ucdToken=`curl -s -u admin:admin \
   	 -H 'Content-Type: application/json' \
   	 -X PUT \
 	 "http://192.168.27.100:8080/cli/teamsecurity/tokens?user=admin&expireDate=12-31-2020-12:00&description=init-ucdp" | python -c \
"import json; import sys;
data=json.load(sys.stdin); print data['token']"`

curl -s -u admin:admin \
	 -H 'Content-Type: application/json' \
	 -X PUT \
	 -d "
{
	\"externalURL\": \"http://192.168.27.100:8080\",
	\"externalUserURL\": \"http://192.168.27.100:8080\",
	\"repoAutoIntegrationPeriod\": 300000,
	\"deployMailHost\": \"smtp.example.com\",
	\"deployMailPassword\": \"\",
	\"deployMailPort\": 25,
	\"deployMailSecure\": false,
	\"deployMailSender\": \"sender@example.com\",
	\"deployMailUsername\": \"username\",
	\"cleanupHourOfDay\": 0,
	\"cleanupDaysToKeep\": -1,
	\"cleanupCountToKeep\": -1,
	\"cleanupArchivePath\": \"\",
	\"historyCleanupTimeOfDay\": 1463184001196,
	\"historyCleanupDaysToKeep\": 730,
	\"historyCleanupDuration\": 23,
	\"historyCleanupEnabled\": false,
	\"enableInactiveLinks\": false,
	\"enablePromptOnUse\": false,
	\"enableAllowFailure\": false,
	\"validateAgentIp\": false,
	\"skipCollectPropertiesForExistingAgents\": false,
	\"requireComplexPasswords\": false,
	\"minimumPasswordLength\": 0,
	\"enableUIDebugging\": false,
	\"enableMaintenanceMode\": false,
	\"isCreateDefaultChildren\": false,
	\"requireCommentForProcessChanges\": false,
	\"failProcessesWithUnresolvedProperties\": true,
	\"enforceDeployedVersionIntegrity\": true,
	\"artifactAgent\": \"\",
	\"artifactAgentName\": \"\",
	\"serverLicenseType\": \"No License\",
	\"serverLicenseBackupType\": \"No License\",
	\"rclServerUrl\": \"27000@licenses.example.com\",
	\"agentAutoLicense\": false,
	\"defaultLocale\": \"\",
	\"defaultSnapshotLockType\": \"ALL\"
}
" \
http://192.168.27.100:8080/rest/system/configuration

localagentId=`curl -s -u admin:admin \
	 -H 'Content-Type: application/json' \
	 -X GET \
	 http://192.168.27.100:8080/rest/agent | python -c \
"import json; import sys;
data=json.load(sys.stdin);
for item in data:
	if item['name'] == 'localagent':
		print item['id']"`

echo "localagentId = $localagentId"

curl -s -u admin:admin \
	 -H 'Content-Type: application/json' \
	 -X GET \
	 http://192.168.27.100:8080/rest/agent/$localagentId/restart

# dismiss the "intro" guide that user's see when logging into ucd for the first time
# curl -s -u admin:admin \
# 	 -H 'Content-Type: application/json' \
# 	 http://192.168.27.100:8080/rest/security/userPreferences/dismissAlert

sleep 10

curl -s -u admin:admin \
	 -H 'Content-Type: application/json' \
	 -X PUT \
	 -d "
{
	\"externalURL\": \"http://192.168.27.100:8080\",
	\"externalUserURL\": \"http://192.168.27.100:8080\",
	\"repoAutoIntegrationPeriod\": 300000,
	\"deployMailHost\": \"smtp.example.com\",
	\"deployMailPassword\": \"\",
	\"deployMailPort\": 25,
	\"deployMailSecure\": false,
	\"deployMailSender\": \"sender@example.com\",
	\"deployMailUsername\": \"username\",
	\"cleanupHourOfDay\": 0,
	\"cleanupDaysToKeep\": -1,
	\"cleanupCountToKeep\": -1,
	\"cleanupArchivePath\": \"\",
	\"historyCleanupTimeOfDay\": 1463184001196,
	\"historyCleanupDaysToKeep\": 730,
	\"historyCleanupDuration\": 23,
	\"historyCleanupEnabled\": false,
	\"enableInactiveLinks\": false,
	\"enablePromptOnUse\": false,
	\"enableAllowFailure\": false,
	\"validateAgentIp\": false,
	\"skipCollectPropertiesForExistingAgents\": false,
	\"requireComplexPasswords\": false,
	\"minimumPasswordLength\": 0,
	\"enableUIDebugging\": false,
	\"enableMaintenanceMode\": false,
	\"isCreateDefaultChildren\": false,
	\"requireCommentForProcessChanges\": false,
	\"failProcessesWithUnresolvedProperties\": true,
	\"enforceDeployedVersionIntegrity\": true,
	\"artifactAgent\": \""$localagentId"\",
	\"artifactAgentName\": \"localagent\",
	\"serverLicenseType\": \"No License\",
	\"serverLicenseBackupType\": \"No License\",
	\"rclServerUrl\": \"27000@licenses.example.com\",
	\"agentAutoLicense\": false,
	\"defaultLocale\": \"\",
	\"defaultSnapshotLockType\": \"ALL\"
}
" \
http://192.168.27.100:8080/rest/system/configuration

patternIntegrationId=`curl -s -u admin:admin \
	 -H 'Content-Type: application/json' \
	 -X GET \
	 http://192.168.27.100:8080/rest/integration/pattern | python -c \
"import json; import sys;
data=json.load(sys.stdin);
for item in data:
	if item['name'] == 'landscaper':
		print item['id']"`

curl -s -u admin:admin \
	 -H 'Content-Type: application/json' \
	 -X PUT \
	 -d "
{
	\"name\": \"landscaper\",
	\"description\": \"\",
	\"existingId\": \""$patternIntegrationId"\",
	\"properties\": 
	{
		\"landscaperUrl\": \"http://192.168.27.100:9080/landscaper\",
		\"useAdminCredentials\": true,
		\"landscaperUser\": \"demo\",
		\"landscaperPassword\": \"labstack\"
	}
}
" \
http://192.168.27.100:8080/rest/integration/pattern

# get UCDP system configuration
curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X PUT \
	 -d "
{
	\"designerServerUrl\": \"http://192.168.27.100:9080/landscaper\",
	\"licenseServer\": \"\",
	\"cloudDiscoveryServer\": \"http://192.168.27.100:7575\",
	\"tokenBasedAuthentication\": true,
	\"ucdUrl\": \"http://192.168.27.100:8080\",
	\"ucdToken\": \""$ucdToken"\",
	\"ucdUser\": \"\",
	\"ucdPassword\": \"\",
	\"chefValidatorKey\": \"\",
	\"chefClientName\": \"\",
	\"chefValidatorName\": \"\",
	\"chefUrl\": \"\",
	\"chefServerHostnameExpression\": \"\",
	\"chefClientKey\": \"\",
	\"chefFeatureEnabled\": true,
	\"gitblitUrl\": \"http://192.168.27.100:9080/gitblit\",
	\"gitblitUser\": \"gitadmin\",
	\"gitblitPassword\": \"gitadmin\",
	\"saltFeatureEnabled\": true,
	\"saltUrl\": \"\",
	\"saltUser\": \"\",
	\"saltPassword\": \"\"
}
" \
http://192.168.27.100:9080/landscaper/security/system/configuration

# add user realm for OpenStack
osAuthRealm=`curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X POST \
	 -d '
{
	"name": "OpenStack",
	"loginClassName": "com.urbancode.landscape.security.authentication.keystone.KeystoneLoginModule",
	"description": "",
	"allowedAttempts": null,
	"property/facingType": "PUBLIC",
	"properties": 
	{
		"url": "http://192.168.27.100:5000/v2.0/",
		"use-available-orchestration": "false",
		"overridden-orchestration": "http://192.168.27.100:8004",
		"admin-password": "labstack",
		"admin-username": "admin",
		"admin-tenant": "admin",
		"domain": "Default",
		"timeoutMins": "60"
	},
	"authorizationRealm": 
	{
		"properties": {}
	}
}
' \
http://192.168.27.100:9080/landscaper/security/authenticationRealm/ | python -c \
"import json; import sys;
data=json.load(sys.stdin); print data['id']"`

echo "osAuthRealm = $osAuthRealm"

# import users from new OpenStack user auth realm
curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X PUT \
	 http://192.168.27.100:9080/landscaper/security/authenticationRealm/$osAuthRealm/importUsers/undefined

# find OpenStack cloud provider
osCloudProvider=`curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X GET \
	 http://192.168.27.100:9080/landscaper/security/cloudprovider/ | python -c \
"import json; import sys;
data=json.load(sys.stdin);
for item in data:
	if item['name'] == 'OpenStack':
		print item['id']"`

echo "osCloudProvider = $osCloudProvider"

# find 'demo' cloud project under the OpenStack cloud provider
osCloudProject=`curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X GET \
	 http://192.168.27.100:9080/landscaper/security/cloudprovider/"$osCloudProvider"/projects | python -c \
"import json; import sys;
data=json.load(sys.stdin);
for item in data:
	if item['name'] == 'demo':
		print item['id']"`

echo "osCloudProject = $osCloudProject"

# add cloud authorization credentials to osCloudProject
curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X PUT \
	 -d "
{
	\"name\": \"demo\",
	\"cloudProviderId\": \"$osCloudProvider\",
	\"existingId\": \"$osCloudProject\",
	\"properties\": 
	[
		{
			\"name\": \"functionalId\",
			\"value\": \"demo\",
			\"secure\": false
		},
		{
			\"name\": \"functionalPassword\",
			\"value\": \"labstack\",
			\"secure\": true
		},
		{
			\"name\": \"domain\",
			\"value\": \"Default\",
			\"secure\": false
		}
	]
}
" \
http://192.168.27.100:9080/landscaper/security/cloudproject/$osCloudProject

osDemoUser=`curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X GET \
	 http://192.168.27.100:9080/landscaper/security/user/ | python -c \
"import json; import sys;
data=json.load(sys.stdin);
for item in data:
	if item['name'] == 'demo':
		print item['id']"`

echo "osDemoUser = $osDemoUser"

# create new 'demo' team and map 'demo' user into it with appropriate roles
osDemoTeam=`curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X POST \
	 -d "
{
	\"name\": \"demo\",
	\"roleMappings\": 
	[
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000004\"
		},
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000005\"
		},
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000301\"
		},
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000302\" 
		},
		{ 
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000303\"
		}
	],
	\"resources\": [],
	\"cloud_projects\": []
}
" \
http://192.168.27.100:9080/landscaper/security/team/ | python -c \
"import json; import sys;
data=json.load(sys.stdin); print data['id']"`

# add osCloudProject as authorized cloud project on this team
curl -s -u ucdpadmin:ucdpadmin \
	 -H 'Content-Type: application/json' \
	 -X PUT \
	 -d "
{
	\"name\": \"demo\",
	\"roleMappings\": 
	[
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000004\"
		},
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000005\"
		},
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000301\"
		},
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000302\"
		},
		{
			\"user\": \""$osDemoUser"\",
			\"role\": \"00000000-0000-0000-0000-000000000303\"
		}
	],
	\"resources\": [],
	\"cloud_projects\": [\""$osCloudProject"\"]
}
" \
http://192.168.27.100:9080/landscaper/security/team/$osDemoTeam