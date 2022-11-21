#!/bin/bash
set -e
set -x

# enroll peer1 node
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org2/peer1/node
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org2:peer1PW@0.0.0.0:7054
mv /tmp/crypto-material/peers/org2/peer1/node/msp/cacerts/* /tmp/crypto-material/peers/org2/peer1/node/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/peers/org2/peer1/node/msp

# enroll org2 admin
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org2/admins/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org2:org2AdminPW@0.0.0.0:7054
mv /tmp/crypto-material/orgs/org2/admins/admin/msp/cacerts/* /tmp/crypto-material/orgs/org2/admins/admin/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org2/admins/admin/msp

# enroll org2 user
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org2/users/user
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org2:org2AdminPW@0.0.0.0:7054
mv /tmp/crypto-material/orgs/org2/users/user/msp/cacerts/* /tmp/crypto-material/orgs/org2/users/user/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org2/users/user/msp

# enroll org2 client
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org2/clients/client
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-identities/ca-cert.pem
fabric-ca-client enroll -d -u https://admin-org2:org2AdminPW@0.0.0.0:7054
mv /tmp/crypto-material/orgs/org2/clients/client/msp/cacerts/* /tmp/crypto-material/orgs/org2/clients/client/msp/cacerts/ca-cert.pem
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org2/clients/client/msp

# setup org2 msp
mkdir -p /tmp/crypto-material/orgs/org2/msp
cp /tmp/config/config.yaml /tmp/crypto-material/orgs/org2/msp
mkdir -p /tmp/crypto-material/orgs/org2/msp/cacerts
cp /tmp/crypto-material/cas/org2/ca-identities/ca-cert.pem /tmp/crypto-material/orgs/org2/msp/cacerts/ca-cert.pem
mkdir -p /tmp/crypto-material/orgs/org2/msp/tlscacerts
cp /tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem /tmp/crypto-material/orgs/org2/msp/tlscacerts/org1-tls-ca-cert.pem
cp /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem /tmp/crypto-material/orgs/org2/msp/tlscacerts/org2-tls-ca-cert.pem
mkdir -p /tmp/crypto-material/orgs/org2/msp/users
