#!/bin/bash
set -e
set -x

# enroll orderer1 node
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer1/node
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer1:orderer1PW@0.0.0.0:7054 
mv /tmp/crypto-material/orderers/org1/orderer1/node/msp/cacerts/* /tmp/crypto-material/orderers/org1/orderer1/node/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orderers/org1/orderer1/node/msp

# enroll orderer2 node
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer2/node
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer2:orderer2PW@0.0.0.0:7054
mv /tmp/crypto-material/orderers/org1/orderer2/node/msp/cacerts/* /tmp/crypto-material/orderers/org1/orderer2/node/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orderers/org1/orderer2/node/msp

# enroll orderer3 node
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer3/node
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer3:orderer3PW@0.0.0.0:7054
mv /tmp/crypto-material/orderers/org1/orderer3/node/msp/cacerts/* /tmp/crypto-material/orderers/org1/orderer3/node/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orderers/org1/orderer3/node/msp

# enroll org1 admin
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org1/admins/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org1:org1adminpw@0.0.0.0:7054
mv /tmp/crypto-material/orgs/org1/admins/admin/msp/cacerts/* /tmp/crypto-material/orgs/org1/admins/admin/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org1/admins/admin/msp

mv /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/keystore/key.pem

# setup org1 msp
mkdir -p /tmp/crypto-material/orgs/org1/msp
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org1/msp
mkdir -p /tmp/crypto-material/orgs/org1/msp/cacerts
cp /tmp/crypto-material/cas/org1/ca-identities/ca-cert.pem /tmp/crypto-material/orgs/org1/msp/cacerts/ca-cert.pem
mkdir -p /tmp/crypto-material/orgs/org1/msp/tlscacerts
cp /tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem /tmp/crypto-material/orgs/org1/msp/tlscacerts/org1-tls-ca-cert.pem
cp /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem /tmp/crypto-material/orgs/org1/msp/tlscacerts/org2-tls-ca-cert.pem
cp /tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem /tmp/crypto-material/orgs/org1/msp/tlscacerts/org3-tls-ca-cert.pem
mkdir -p /tmp/crypto-material/orgs/org1/msp/users