![Status Badge](https://img.shields.io/badge/Status-archived-red)

**NOTE:** This lab has been archived and is no longer being maintained.

# I. INTRODUCTION 

A git repo that provides working examples of various Hyperledger Fabric network topologies that leverage a variety of features provided by the product, for production-ready deployments.

Each folder in the topologies directory represents a different type of network that can be created. All of the available topologies are based on T1 which contains three orgs: org1 contains 3 orderers, org2 and org3 both contain 2 peers each. Each org has it's own 2 CAs: am Identities CA (for network components identities) and a TLS CA (for secure SSL communications between network components). 

## Individual Topology Documentation
| Topology                        | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| [T0](./topologies/t0/README.md) | T1 minus 1 Org -- 1 Peer, 1 Orderer per Org      |
| [T1](./topologies/t1/README.md) | Base Topology                                    |
| [T2](./topologies/t2/README.md) | 2 orgs with orders and nginx proxies             |
| [T3](./topologies/t3/README.md) | External Chaincode                               |
| [T4](./topologies/t4/README.md) | Local LDAP Server                                |
| [T5](./topologies/t5/README.md) | Clustered CAs for one of the Orgs                |
| [T6](./topologies/t6/README.md) | Mutual TLS                                       |
| [T7](./topologies/t7/README.md) | Private Data Collections                         |
| [T8](./topologies/t8/README.md) | Clustered CouchDB Datastore For One of the Peers |
| [T9](./topologies/t9/README.md) | Channel Participation API                        |


# II. RUNNING A NETWORK 

## ***A. Prerequisites***

- Docker & Docker Compose Plugin (v2) need to be installed locally
  - docker needs be able to be executed as a non-root (logged-in user); i.e. no need to use *sudo* to run docker commands
  - The Docker Compose Plugin allows for *docker compose (instead of docker-compose) commands* to be executed. This  is leveraged extensively in setup scripts
- Linux or Mac environment (all setup/destroy scripts are bash scripts)

## ***B. Creating and Destroying a Network Topology***
   
1. Clone this repo locally
2. From the root folder of the repo navigate to the topology of interest
  ```sh
  cd topologies/t<n>  # where <n> is the topology number
  ```
```sh
1. To create a network topology
./setup-network.sh  # from the topology folder
```
4. How do you know the network has started succesfully?
```sh
******* NETWORK SETUP COMPLETED *******  # this should be the last message displayed once the setup-network.sh script has completed
```
5. To tear down (destroy) a network topology
```sh
./teardown-network.sh  # from the topology folder
```
6. To restart a network topology
```sh
./setup-network.sh  # from the topology folder

# towards the beginning of this script the teadown-network.sh script is run to cleanup resources from a prior run, and then the network start up occurs
```

## ***C. What do you get with a running network topogogy?***

1. A functional network with all components needed to execute some chaincode. The root folder of the topology has a README.md that explains the purpose of that topology and what are its constituent components.
2. The scripts create all the necessary crypto material (CA certs, public/signed certs, private keys, etc) for all entities (peer and orderer nodes and admin/user/client accounts) participating in the network
3. The scripts also create a genesis block for the system channel as well as an application channel joined by peers, on which the chaincode is installed.
4. Each component/server that is needed for the network runs as a Docker container. No processes run outside of Docker - therefore no Hyperledge Fabric binaries have to be installed directly in the host environment.
5. All docker containers for the same topology run within the context of the same Docker project and have unique names to associated with that topology.
6. All docker containers, for a single topology, run within the same Docker network (name scoped using the topology id) 
7. Points 4 and 5 provide the isolation that allows for multiple topology networks to be up and running at the same time, even running with different versions of the Hyperledger Fabric binaries.
8. The network setup completes with the installation of the asset transfer basic chaincode from the main product Git repo fabric-examples
   - to complete the verification process this chaincode is also executed by performing a write operation and then a read operation
9. When the network is torn down all the following resources are destroyed:
    - all docker containers created by the setup script are stopped and deleted. 
    - all crypto materials created for the network topology
    - all configurations and state files (blocks) for the system and application channels
    - any state maintained in databases (e.g. blockchain world state, Fabric CA db, etc)
10. When the network is destroyed, docker Images pulled to create the containers for the network ARE NOT DELETED. This allows for faster start-up the next time. For any further cleanup, they'd need to be deleted through other mechanisms.
11. Please note that most of the docker containers have volumes mounted from the host file system (the most notable mounted folder is the crypto-material, present inside each topology folder). 
    - the docker containers run with a **root user id** and as such files created inside these containers will be owned by root. Trying to delete/modify these files/folders from the volumes mapped into the host (w/o using the teardown-network.sh script) could result in errors if the user id trying to delete/modify these files does not have proper permissions. The teardwon-network.sh runs from inside a topology container and thus has the permissions (i.e. root) to delete these files.

## ***D. Available Configurations***

**1. Binaries Versions**
   
   Each topology has a .env file at the root of its folder that allows changing the versions of the Hyperledger binaries through environment variables. The name for docker project that houses the topology containers can be changed in this file as well.

**2. Ports exposed to the host**

   With one exception (for topology T8) none of the ports used by processes runing inside the topology containers are exposed to the host, to avoid any conflicts with other processes using these port numbers. 

   The docker-compose.yml file at the root of each topology folder can be referenced though for these purposes:
    - to get an idea about all containers running for the topology and the Docker images used by them
    - the port numbers used by processes inside the containers are also documented as comments. To expose access to these processes from the host, these port commands can be commented out and configured with desired ports that onE might want to use. This then allows for e.g. for peers and orders to be accessed by external applications or other components (e.g. OpemnLDAP, CoudchDB, MySQL, etc) to be accessed and have their data inspected from the host.

**3. Other configurations**

To make any other network configurations (e.g. change number of peers, orderers, chaincodes, customize features, etc.) one would need to study the various shell scripts and configuration files that exist in the topology folder. *A good starting point is the **setup-network.sh***.

There is a considerable amount of repetition in terms of configuration files and code in shell scripts, between the different topologies. We purposely did not pursue creating more common code/functions to increase reuse because of the following reason:

We wanted to make it easy to compare the code and configurations between different topologies to allow us to understand what were the changes made to get from one state of a network to another. 

With the exception of the t0 topology all other topologies use as a base (were built upon) the t1 topology. As such if one would like to understand for e.g. what is needed to configure mutual TLS (topology t6), a t1 to t6 folder compare - using any file/folder compare tool - can be done to visualize all the differences and study them.


# III. REASONS FOR DEVELOPING THESE TOPOLOGIES


## **A. Production Readiness**

In order to deploy a Hyperledger Fabric to production in an enterprise setting with mutliple participant organizations (sometime not connected to the same point-to-point networks, i.e. connected over the public internet) a few considertions need to be kept in mind:
   - Ability to provide secure and authenticated communications between all nodes: all communications between network nodes should be encrypted and authenticated with mutual TLS
   - identities associated with nodes and actors that connect to the network should have their credentials stored in a secure store, using solutions frequeantly deployed in enterprises: e.g. Fabric CA should be intergrated with an LDAP compliant store instead of using its own SQL database to store account credentials
   - There should be no single point of failure: this means that not only that there must be multiple instances of peers and orders but other components too: Fabric CA, World State Storage Databases, External Chaincode servers need to be replicated as well. Also wherever possible access should be done through a proxy which can load balance and provide fail over for access to each set of components. Nginx proxies have been used in some of the topologies for this purpose.

## ***B. Lack of sufficient online examples and tutorials***

- The official Hyperledger Fabric documentation of architecture, features and concepts is detailed and for the most part very comprehensive. Given the complexities of a blockchain network and the number of technologies involved, this is simply not enough though.
  
- There are some operations guides that show some examples how to setup certain components of the network but we often found that there were mistakes in some of the commands or steps described in them. For a new person starting to use Hyperledger it is very easy to get lost as soon as one hits the first few setup/execution errors: there are many moving parts and a network administrator needs to be familiar with many technologies.

- The scripts available in the official product code base in Github are useful in getting an initial network up an running but they really don't go into any sufficient depth to demonstrate setup examples for capabilities needed for a production deployment, such as those described above.

- There are a few online resources that demonstrate certain more complex aspects of Hyperledger Fabric but they frequently suffer from the same short comings present in the official documentation and the examples in the HL code base.

- In general there is a significant lack of working examples of network topologies that leverage many of the sophisticated capabilities of Hyperledger Fabric.

## ***C. Working examples that are easy to setup***

To speed up our understanding of Hyperledger Fabric and the learning curve for new developers working with these technologies, we wanted to create working examples of Hyperledger Fabric topologies that are:

- easy to get up and running with minimal amount of installs and configurations
- facilitate the comparison of different features by being able to study, for each of the main demonstrated features, what were the main network configurations, code, scripts, etc changes that had to be done to enable those capabilities.
- isolation for network topologies by providing the ability to run more than one network topology at the same time on the same machine; even with different versions of the binaries
- setup networks that are then easy to connect to with various client applications for local development

