#!/bin/bash
set -e
set -x

# enroll peer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org2/peer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org2-tls-peer1:peer1PW@0.0.0.0:7054 --csr.names "C=US,ST=Washington" --enrollment.attrs "hf.Type,hf.EnrollmentID,hf.Affiliation" --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org2-peer1

# enroll peer2 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/peers/org2/peer2/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org2-tls-peer2:peer2PW@0.0.0.0:7054 --csr.names "C=US,ST=Washington" --enrollment.attrs "hf.Type,hf.EnrollmentID,hf.Affiliation" --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org2-peer2

mv /tmp/crypto-material/peers/org2/peer1/node-tls/msp/keystore/* /tmp/crypto-material/peers/org2/peer1/node-tls/msp/keystore/key.pem
mv /tmp/crypto-material/peers/org2/peer2/node-tls/msp/keystore/* /tmp/crypto-material/peers/org2/peer2/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/peers/org2/peer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org2/peer1/node-tls/msp/tlscacerts/ca-cert.pem
mv /tmp/crypto-material/peers/org2/peer2/node-tls/msp/tlscacerts/* /tmp/crypto-material/peers/org2/peer2/node-tls/msp/tlscacerts/ca-cert.pem