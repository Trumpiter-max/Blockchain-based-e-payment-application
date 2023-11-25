#!/bin/bash

# Stop monitor system
containers=("grafana" \
            "node-exporter" \
            "prometheus" \
            "cadvisor")

# Stop and remove all containers in one command
docker stop "${containers[@]}" && docker rm "${containers[@]}"

# Stop token assets 
images=("token-sdk-owner2" \
        "token-sdk-issuer" \
        "token-sdk-owner1" \
        "swaggerapi/swagger-ui" \
        "token-sdk-auditor")

# Remove all images in one command
# docker rmi "${images[@]}"

# Stop and remove token components with docker-compose
cd ./token-sdk && docker-compose down
sudo rm -rf ./keys
sudo rm -rf ./data
docker network rm token-sdk_default
docker network rm fabric_test

# Stop the network 
cd ../test-network/addOrg3/ && bash addOrg3.sh down;

# Remove all unused system & network resources with one command
echo "[+] This action will wipe out all your docker images, containers, networks, and volumes"
sudo docker system prune -f
sudo docker network prune -f
sudo docker system df

sudo rm -rf $HOME/.fabric-ca-client
# Restart the docker service with systemctl
sudo systemctl restart docker
