#!/bin/bash
set -e
set -x

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org1/ca-identities/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/cas/org1/ca-identities-admin
fabric-ca-client enroll -d -u https://org1-ca-identities-admin:org1-ca-identities-adminpw@0.0.0.0:7054
fabric-ca-client register -d --id.name org1-orderer1 --id.secret orderer1PW --id.type orderer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name org1-orderer2 --id.secret orderer2PW --id.type orderer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name org1-orderer3 --id.secret orderer3PW --id.type orderer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name admin-org1 --id.secret org1adminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7054