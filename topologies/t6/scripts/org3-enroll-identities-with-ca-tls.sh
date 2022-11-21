#!/bin/bash
set -e
set -x

export FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE=/tmp/crypto-material/cas/org3/ca-tls-admin/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE=/tmp/crypto-material/cas/org3/ca-tls-admin/msp/signcerts/cert.pem

# enroll peer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org3:peer1PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org3-peer1

# enroll peer2 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer2/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org3:peer2PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org3-peer2
# enroll org3 admin-tls
unset FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE
unset FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orgs/org3/admins/admin-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE=/tmp/crypto-material/cas/org3/ca-tls-admin/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE=/tmp/crypto-material/cas/org3/ca-tls-admin/msp/signcerts/cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-org3:org3AdminPW@0.0.0.0:7054
mv /tmp/crypto-material/orgs/org3/admins/admin-tls/msp/keystore/* /tmp/crypto-material/orgs/org3/admins/admin-tls/msp/keystore/key.pem
mv /tmp/crypto-material/peers/org3/peer1/node-tls/msp/keystore/* /tmp/crypto-material/peers/org3/peer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/peers/org3/peer2/node-tls/msp/keystore/* /tmp/crypto-material/peers/org3/peer2/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/peers/org3/peer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org3/peer1/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/peers/org3/peer2/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org3/peer2/node-tls/msp/tlscacerts/ca-cert.pem