#!/bin/bash
set -e
set -x

# enroll peer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org3:peer1PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org3-peer1

# enroll peer2 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer2/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org3:peer2PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org3-peer2

# enroll org3 chaincode
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org3/chaincode
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://chaincode-org3:chaincodeOrg3PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org3-chaincode
mv /tmp/crypto-material/orgs/org3/chaincode/msp/keystore/* /tmp/crypto-material/orgs/org3/chaincode/msp/keystore/key.pem
chmod -R 777 /tmp/crypto-material/orgs/org3/chaincode/msp

mv /tmp/crypto-material/peers/org3/peer1/node-tls/msp/keystore/* /tmp/crypto-material/peers/org3/peer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/peers/org3/peer2/node-tls/msp/keystore/* /tmp/crypto-material/peers/org3/peer2/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/peers/org3/peer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org3/peer1/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/peers/org3/peer2/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org3/peer2/node-tls/msp/tlscacerts/ca-cert.pem