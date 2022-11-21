#!/bin/bash
set -e
set -x

# enroll orderer1 node-tls
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/orderers/org1/orderer1/node-tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
fabric-ca-client enroll -d -u https://org1-orderer1:or%24derer%5E1PW@0.0.0.0:7054 --enrollment.profile tls --csr.hosts ${TOPOLOGY}-org1-orderer1

mv /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/keystore/* /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/keystore/key.pem

mv /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/tlscacerts/* /tmp/crypto-material/orderers/org1/orderer1/node-tls/msp/tlscacerts/ca-cert.pem