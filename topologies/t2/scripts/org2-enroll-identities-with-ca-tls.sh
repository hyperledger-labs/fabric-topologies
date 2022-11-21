#!/bin/bash
set -e
set -x

# enroll peer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org2/peer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org2-peer1 --csr.hosts ${TOPOLOGY}-org2-peers-proxy

# enroll peer2 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org2/peer2/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org2:peer2PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org2-peer2 --csr.hosts ${TOPOLOGY}-org2-peers-proxy

# enroll orderer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org2/orderer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org2-orderer1:orderer1PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org2-orderer1 --csr.hosts ${TOPOLOGY}-orderers-proxy

# enroll orderer2 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org2/orderer2/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org2-orderer2:orderer2PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org2-orderer2 --csr.hosts ${TOPOLOGY}-orderers-proxy

mv /tmp/crypto-material/peers/org2/peer1/node-tls/msp/keystore/* /tmp/crypto-material/peers/org2/peer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/peers/org2/peer2/node-tls/msp/keystore/* /tmp/crypto-material/peers/org2/peer2/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/orderers/org2/orderer1/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org2/orderer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/orderers/org2/orderer2/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org2/orderer2/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/peers/org2/peer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org2/peer1/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/peers/org2/peer2/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org2/peer2/node-tls/msp/tlscacerts/ca-cert.pem

mv /tmp/crypto-material/orderers/org2/orderer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org2/orderer1/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/orderers/org2/orderer2/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org2/orderer2/node-tls/msp/tlscacerts/ca-cert.pem