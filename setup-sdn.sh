#!/bin/bash
echo "[+] Install required packages";
# Install OVS to create OVS bridge for docker networking
sudo apt-get install openvswitch-switch openvswitch-common -y;
export PATH=$PATH:/usr/local/share/openvswitch/scripts;

# Install ovs-docker utility
# Check if ovs-docker is installed
echo "[+] Install ovs-docker";
sudo rm -f /usr/local/bin/ovs-docker;
sudo wget https://raw.githubusercontent.com/openvswitch/ovs/master/utilities/ovs-docker -P /usr/local/bin;
sudo chmod a+rwx /usr/local/bin/ovs-docker;

# Create overlay network on bare metal host
echo "[+] Setup OVS bridge for docker networking";
sudo ovs-vsctl add-br docker-br0;
sudo cp ./daemon.json $HOME/.docker/daemon.json;
sudo systemctl restart docker;
sudo ifconfig docker-br0 192.168.30.1 netmask 255.255.255.0 mtu 1450 up;

#echo "[+] Start the SDN components";
#cd ./test-network/sdn-compose && docker-compose up &;
#sudo ovs-vsctl set-controller docker-br0 tcp:localhost:6633
