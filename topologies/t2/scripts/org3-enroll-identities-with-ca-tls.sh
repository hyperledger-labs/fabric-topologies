#!/bin/bash
set -e
set -x

# enroll peer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer1-org3:peer1PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org3-peer1 --csr.hosts ${TOPOLOGY}-org3-peers-proxy

# enroll peer2 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer2/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org3:peer2PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org3-peer2 --csr.hosts ${TOPOLOGY}-org3-peers-proxy

# enroll peer3 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org3/peer3/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://peer3-org3:peer3PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org3-peer3 --csr.hosts ${TOPOLOGY}-org3-peers-proxy

mv /tmp/crypto-material/peers/org3/peer1/node-tls/msp/keystore/* /tmp/crypto-material/peers/org3/peer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/peers/org3/peer2/node-tls/msp/keystore/* /tmp/crypto-material/peers/org3/peer2/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/peers/org3/peer3/node-tls/msp/keystore/* /tmp/crypto-material/peers/org3/peer3/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/peers/org3/peer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org3/peer1/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/peers/org3/peer2/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org3/peer2/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/peers/org3/peer3/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org3/peer3/node-tls/msp/tlscacerts/ca-cert.pem