#!/bin/bash
set -e
set -x

export FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE=/tmp/crypto-material/cas/org2/ca-tls-admin/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE=/tmp/crypto-material/cas/org2/ca-tls-admin/msp/signcerts/cert.pem

# enroll peer1 node
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer1/node
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org3:peer1PW@0.0.0.0:7054
mv /tmp/crypto-material/peers/org3/peer1/node/msp/cacerts/* /tmp/crypto-material/peers/org3/peer1/node/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/peers/org3/peer1/node/msp

# enroll peer2 node
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer2/node
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org3:peer2PW@0.0.0.0:7054
mv /tmp/crypto-material/peers/org3/peer2/node/msp/cacerts/* /tmp/crypto-material/peers/org3/peer2/node/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/peers/org3/peer2/node/msp

# enroll org3 admin
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org3/admins/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org3:org3AdminPW@0.0.0.0:7054
mv /tmp/crypto-material/orgs/org3/admins/admin/msp/cacerts/* /tmp/crypto-material/orgs/org3/admins/admin/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org3/admins/admin/msp

# enroll org3 user
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org3/users/user
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org3:org3AdminPW@0.0.0.0:7054
mv /tmp/crypto-material/orgs/org3/users/user/msp/cacerts/* /tmp/crypto-material/orgs/org3/users/user/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org3/users/user/msp

# enroll org3 client
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org3/clients/client
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org3:org3AdminPW@0.0.0.0:7054
mv /tmp/crypto-material/orgs/org3/clients/client/msp/cacerts/* /tmp/crypto-material/orgs/org3/clients/client/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org3/clients/client/msp

# setup org3 msp
mkdir -p /tmp/crypto-material/orgs/org3/msp
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org3/msp
mkdir -p /tmp/crypto-material/orgs/org3/msp/cacerts
cp /tmp/crypto-material/cas/org3/ca-identities/ca-cert.pem /tmp/crypto-material/orgs/org3/msp/cacerts/ca-cert.pem
mkdir -p /tmp/crypto-material/orgs/org3/msp/tlscacerts
cp /tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem /tmp/crypto-material/orgs/org3/msp/tlscacerts/org1-tls-ca-cert.pem
cp /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem /tmp/crypto-material/orgs/org3/msp/tlscacerts/org2-tls-ca-cert.pem
cp /tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem /tmp/crypto-material/orgs/org3/msp/tlscacerts/org3-tls-ca-cert.pem
mkdir -p /tmp/crypto-material/orgs/org3/msp/users
