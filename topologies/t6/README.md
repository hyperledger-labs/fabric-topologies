# T6: Mutual TLS
## Description
---
T1 network + communications between all components performed using TLS & Client authentication

## Diagram
---
![Diagram of components](../image_store/T6.png)

## Relevant Documentation

- https://hyperledger-fabric.readthedocs.io/en/latest/enable_tls.html

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
- Communication between all components done via Mutual TLS 