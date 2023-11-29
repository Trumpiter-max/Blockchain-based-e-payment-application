#!/bin/bash

starttime=$(date +%s)
export TIMEOUT=10
export DELAY=3

# Set environment 
# Path for fabric binaries
export PATH=$PATH:${PWD}/bin
export FAB_BINS=${PWD}/bin
export FABRIC_CFG_PATH=${PWD}/config

# Path for golang
export GOPATH=$HOME/go;
export GO111MODULE=on go mod vendor;
export GOROOT=/usr/local/go;
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin;

# Path for token sdk
export FTS_PATH=$GOPATH/src/github.com/hyperledger-labs/fabric-token-sdk;
export OAPI_PATH=$GOPATH/src/github.com/deepmap/oapi-codegen;
export $(./test-network/setOrgEnv.sh bank | xargs);
export $(./test-network/setOrgEnv.sh business | xargs);
export CORE_PEER_TLS_ENABLED=true;

# Path for setup
export TEST_NETWORK_HOME=${PWD}/test-network;
export TOKEN_SDK_HOME=${PWD}/token-sdk;

# Install required packages
echo "[+] Update and install required packages";
sudo apt-get update;
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common;
sudo apt-get install -y git curl;

IMAGE_NAME="hyperledger/fabric";
IMAGE_TAG="2.5.0";
if docker image ls -q ${IMAGE_NAME}:${IMAGE_TAG} > /dev/null 2>&1; then
    echo "[+] The Hyperledger Fabric 2.5.0 image exists locally. Start the network up.";
else
    bash install-fabric.sh --fabric-version 2.5.0 docker
    echo "[+] Install the Hyperledger Fabric 2.5.0 image locally. Start the network up.";
fi;

# Start the network up
cd $TEST_NETWORK_HOME && bash ./network.sh up;
# Create private channel
# bash network.sh createChannel -c fast-channel && bash network.sh createChannel -c stable-channel;
bash ./network.sh createChannel;

# Add Org3 join to channel
# bash ./addOrg3/addOrg3.sh up -c fast-channel;

# Install token sdk
sudo git clone https://github.com/hyperledger-labs/fabric-token-sdk.git $FTS_PATH;
sudo git clone https://github.com/deepmap/oapi-codegen.git $OAPI_PATH;

# Setup REST API endpoint
cd $TOKEN_SDK_HOME;
go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest;
oapi-codegen -config auditor/oapi-server.yaml swagger.yaml;
oapi-codegen -config issuer/oapi-server.yaml swagger.yaml;
oapi-codegen -config owner/oapi-server.yaml swagger.yaml;
oapi-codegen -config e2e/oapi-client.yaml swagger.yaml;

# Setup token sdk
go install github.com/hyperledger-labs/fabric-token-sdk/cmd/tokengen@v0.3.0;

# Setup token chaincode
cd $TOKEN_SDK_HOME && bash ./scripts/up.sh;

# Get time execution
execution_time_seconds=$(( $(date +%s) - starttime ));
minutes=$((execution_time_seconds / 60));
seconds=$((execution_time_seconds % 60));

cat <<EOF

Total setup execution time : $minutes minutes $seconds seconds ...

EOF

# Start monitor
# cd ../test-network/prometheus-grafana && docker-compose up -d;
# cd .. && bash monitordocker.sh;
