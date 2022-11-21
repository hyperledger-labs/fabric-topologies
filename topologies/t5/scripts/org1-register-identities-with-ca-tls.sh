#!/bin/bash
set -e
set -x

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/cas/org1/ca-tls-admin
fabric-ca-client enroll -d -u https://org1-ca-tls-admin:org1-ca-tls-adminpw@0.0.0.0:9000
fabric-ca-client register -d --id.name org1-orderer1 --id.secret orderer1PW --id.type orderer -u https://0.0.0.0:9000
fabric-ca-client register -d --id.name org1-orderer2 --id.secret orderer2PW --id.type orderer -u https://0.0.0.0:9000
fabric-ca-client register -d --id.name org1-orderer3 --id.secret orderer3PW --id.type orderer -u https://0.0.0.0:9000