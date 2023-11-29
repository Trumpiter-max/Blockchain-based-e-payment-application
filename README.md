# Blockchain-based e-payment application

This project based on template from [@HyperLedger](https://github.com/hyperledger/). In this project, asssets include some components:

- [Sample of Hyperledger Fabric](https://github.com/hyperledger/fabric-samples).
- [SSI application to be developed on top of Hyperledger Fabric](https://github.com/hyperledger-labs/aries-fabric-wrapper).

## Get started

Environment of project:

- OS: Ubuntu 20.04 LTS amd64.
- Docker & its components.
- Go lang: go1.21.3 linux/amd64.

For testing environment & setup machine:

- Bare machine - CPU: AMD Ryzen 5 5500U, RAM: 16GB, OS: Windows 11 23H2.
- Virtual machine - VMware Workstation 17 with 8 processors and 8 GB memory.

To get started with prerequirements from [this source](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html). Make sure the machine for installing has already install above requirements.

To start network:

```sh
    bash run.sh
```

To stop network (this will clear everything of network):

```sh
    bash stop.sh
```

##### Reference