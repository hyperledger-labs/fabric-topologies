# T9: Channel Participation API
## Description
---
T1 network + Channel Participation API (No System Channel)

## Diagram
---
![Diagram of components](../image_store/T9.png)

## Relevant Documentation

- https://hyperledger-fabric.readthedocs.io/en/latest/create_channel/create_channel_participation.html

## Components List
---
* Org 1
  * Orderer 1
  * Orderer 2
  * Orderer 3
  * TLS CA
  * Identities CA
* Org 2
  * Peer 1
  * Peer 1 CLI
  * Peer 2
  * TLS CA
  * Identities CA
* Org 3
  * Peer 1
  * Peer 1 CLI
  * Peer 2
  * TLS CA
  * Identities CA
  
## Characteristics

- World State Database Instance (LevelDB) embedded (in peer containers)
- Chaincode installed directly on peers
- Communication between all components done via TLS 