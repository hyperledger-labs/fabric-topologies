#!/bin/bash
set -e
set -x

# enroll orderer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer1:orderer1PW@0.0.0.0:9000 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org1-orderer1

# enroll orderer2 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer2/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer2:orderer2PW@0.0.0.0:9000 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org1-orderer2

# enroll orderer3 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer3/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer3:orderer3PW@0.0.0.0:9000 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org1-orderer3

mv /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/tlscacerts/ca-cert.pem