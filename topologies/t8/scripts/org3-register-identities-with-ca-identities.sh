#!/bin/bash
set -e
set -x

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org3/ca-identities/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/cas/org3/ca-identities-admin
fabric-ca-client enroll -d -u https://org3-ca-identities-admin:org3-ca-identities-adminpw@0.0.0.0:7054
fabric-ca-client register -d --id.name peer1-org3 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name peer2-org3 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name admin-org3 --id.secret org3AdminPW --id.type admin -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name user-org3 --id.secret org3UserPW --id.type user -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name client-org3 --id.secret org3UserPW --id.type client -u https://0.0.0.0:7054