# Blockchain-based e-payment application

This project based on template from [@HyperLedger](https://github.com/hyperledger/). In this project, asssets include some components:

- [Sample of Hyperledger Fabric](https://github.com/hyperledger/fabric-samples).
- [SSI application to be developed on top of Hyperledger Fabric](https://github.com/hyperledger-labs/aries-fabric-wrapper).

## Specs

Environment of running network:

- OS: Ubuntu 20.04 LTS amd64.
- Docker & its components.
- Go lang: go1.21.3 linux/amd64.
- Java: 17.0.6 2023-01-17 LTS.
- Maven: 3.8.3.
- ovsdb-server: https://hub.docker.com/r/openvswitch/ovs.
- Opendaylight: 
- Openflow

**Note*: there are some sources code of relative project inside this project for using or customizing.

For application built on top of network:

- Typescript with npm 10.2.3 and node 20.10.3.

For testing environment & setup machine:

- Bare machine - CPU: AMD Ryzen 5 5500U, RAM: 16GB, OS: Windows 11 23H2.
- Virtual machine - VMware Workstation 17 with 8 processors and 8 GB memory.

To get started with prerequirements from [this source](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html). Make sure the machine for installing has already install above requirements.

## Get started

To start network:

```sh
    bash run.sh
```

To stop network (this will clear everything of network):

```sh
    bash stop.sh
```

##### Reference

https://awjunaid.com/docker/how-to-use-ovs-with-docker/