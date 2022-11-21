#!/bin/bash
set -e
set -x

export FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE=/tmp/crypto-material/cas/org1/ca-tls-admin/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE=/tmp/crypto-material/cas/org1/ca-tls-admin/msp/signcerts/cert.pem
# enroll orderer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer1:orderer1PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org1-orderer1

# enroll orderer2 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer2/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer2:orderer2PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org1-orderer2

# enroll orderer3 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer3/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer3:orderer3PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org1-orderer3

# enroll org1 admin-tls
unset FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE
unset FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org1/admins/admin-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE=/tmp/crypto-material/cas/org1/ca-tls-admin/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE=/tmp/crypto-material/cas/org1/ca-tls-admin/msp/signcerts/cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org1:org1AdminPW@0.0.0.0:7054

mv /tmp/crypto-material/orgs/org1/admins/admin-tls/msp/keystore/* /tmp/crypto-material/orgs/org1/admins/admin-tls/msp/keystore/key.pem 



mv /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org1/orderer2/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org1/orderer3/node-tls/msp/tlscacerts/ca-cert.pem