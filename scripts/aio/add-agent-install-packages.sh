#!/bin/bash

AGENT_URL=${AGENT_URL:-http://artifacts.stackinabox.io/urbancode/ibm-ucd-platform-agent-packages}
ARTIFACT_STREAM=latest
DEPLOY_SERVER_URL=${DEPLOY_SERVER_URL:-http://192.168.27.100:8080}
DEPLOY_SERVER_AUTH_TOKEN=${DEPLOY_SERVER_AUTH_TOKEN:-}

if [ -z "$DEPLOY_SERVER_AUTH_TOKEN" ]; then

  # UCD Server takes a few seconds to startup. If we call this function too early it will fail
  # loop until it succeeds or fail after # of attempts
  attempt=1
  until $(curl -k -u admin:admin --output /dev/null --silent --head --fail "${DEPLOY_SERVER_URL}/cli/systemConfiguration"); do
      attempt=$(($attempt + 1))
      sleep 5
      if [ "$attempt" -gt "5" ]; then
        echo "Failed to connect to ucd server at ${DEPLOY_SERVER_URL}. Please check for valid values for UCD_SERVER and UCD_SERVER_HTTP_PORT."
        exit 1
      fi
  done

	DEPLOY_SERVER_AUTH_TOKEN=$(curl -k -u admin:admin \
    	-X PUT \
    	"${DEPLOY_SERVER_URL}/cli/teamsecurity/tokens?user=admin&expireDate=12-31-2020-12:00" | python -c \
"import json; import sys;
data=json.load(sys.stdin); print data['token']")
fi

wget -Nv $AGENT_URL/$ARTIFACT_STREAM.txt

AGENT_VERSION=${AGENT_VERSION:-$(cat $ARTIFACT_STREAM.txt)}
AGENT_DOWNLOAD_URL=${AGENT_DOWNLOAD_URL:-$AGENT_URL/$AGENT_VERSION/ibm-ucd-platform-agent-packages-$AGENT_VERSION.tgz}

wget -Nv $AGENT_DOWNLOAD_URL
tar -zxf ibm-ucd-platform-agent-packages-$AGENT_VERSION.tgz -C /tmp
pushd /tmp/ibm-ucd-patterns-install/agent-package-install/

sed -i 's|#!\/bin\/sh|#!\/bin\/bash|g' /tmp/ibm-ucd-patterns-install/agent-package-install/install-agent-packages.sh
/bin/bash -c "`pwd`/install-agent-packages.sh -s ${DEPLOY_SERVER_URL} -a ${DEPLOY_SERVER_AUTH_TOKEN}"

rm -rf /tmp/ibm-ucd-patterns-install ibm-ucd-platform-agent-packages-$ARTIFACT_VERSION.tgz
popd