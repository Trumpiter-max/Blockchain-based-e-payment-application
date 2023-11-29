#!/bin/bash

echo "[+] This action will wipe out all your docker images, containers, networks, and volumes";

# Stop monitor system
containers=("grafana" \
        "node-exporter" \
        "prometheus" \
        "cadvisor");

# Stop and remove all containers in one command
docker stop "${containers[@]}" && docker rm "${containers[@]}";

# Stop token assets 
images=("token-sdk-owner2" \
        "token-sdk-issuer" \
        "token-sdk-owner1" \
        "swaggerapi/swagger-ui" \
        "token-sdk-auditor");

# Remove all images if images are error or out of date
# docker rmi "${images[@]}";

# Stop and remove token components for token chaincode
cd ./token-sdk && docker-compose down;
docker-compose -f compose-ca.yaml down;
docker stop peer0org1_tokenchaincode_ccaas peer0org2_tokenchaincode_ccaas;
sudo rm -rf ./keys;
sudo rm -rf ./data;
sudo rm -f ./tokenchaincode/zkatdlog_pp.json;

# Stop all network
docker network rm token-sdk_default;
docker network rm fabric_test;

# Stop the network 
cd ../test-network/addOrg3 && bash addOrg3.sh down;

# Remove all unused system & network resources
sudo docker system prune -f;
sudo docker network prune -f;
sudo docker system df;

sudo rm -rf $HOME/.fabric-ca-client;
# Restart the docker service with systemctl
sudo systemctl restart docker;