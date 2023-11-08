#!/bin/bash

# Stop monitor system
containers=("grafana" \
            "node-exporter" \
            "prometheus" \
            "cadvisor")

# Loop through each container
for container in "${containers[@]}"
do
  # Stop the container
  docker stop $container
  
  # Remove the container
  docker rm $container
done

# Stop token assets 
images=("token-sdk-owner2" \
        "token-sdk-issuer" \
        "token-sdk-owner1" \
        "swaggerapi/swagger-ui" \
        "token-sdk-auditor")

for image in "${images[@]}"
do
  # Get container IDs of running containers created from the image
  container_ids=$(docker ps -a -q --filter ancestor=$image)

  # If there are any running containers, stop them
  if [ ! -z "$container_ids" ]
  then
    docker stop $container_ids
  fi
done

# Remove token compoments
cd ./token-sdk && bash ./scripts/down.sh;

# Stop the network 
cd ../test-network/addOrg3/ && bash addOrg3.sh down;

sudo rm -rf ../../high-throughput/application-go/wallet/
sudo rm -rf ../../high-throughput/application-go/keystore/

# Remove all unused system & network resources
docker system prune -f
docker network prune -f