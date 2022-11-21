#!/bin/bash
set -e
set -x
source /tmp/scripts/find-ca-private-key.sh
# get the CA private key file as 2 of them are created: one for the CA cert (ca-cert.pem) and another one for CA TLS cert (tls-cert.pem)
# and we need the keyfile for the CA TLS cert
CA_PRIV_KEYFILE=`find_private_key_path /tmp/crypto-material/cas/org2/ca-tls`
echo $CA_PRIV_KEYFILE
# initial enroll of bootstrap admin will be done with the key and cert of the CA server
# after this, the admin's key and cert will be used for registrations.
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem
# copy the CA server's key file to make it easier to use it
cp $CA_PRIV_KEYFILE /tmp/crypto-material/cas/org2/ca-tls/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE=/tmp/crypto-material/cas/org2/ca-tls/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE=/tmp/crypto-material/cas/org2/ca-tls/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/crypto-material/cas/org2/ca-tls-admin
fabric-ca-client enroll -d -u https://org2-ca-tls-admin:org2-ca-tls-adminpw@0.0.0.0:7054
sleep 1
mv /tmp/crypto-material/cas/org2/ca-tls-admin/msp/keystore/* /tmp/crypto-material/cas/org2/ca-tls-admin/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_KEYFILE=/tmp/crypto-material/cas/org2/ca-tls-admin/msp/keystore/key.pem
export FABRIC_CA_CLIENT_TLS_CLIENT_CERTFILE=/tmp/crypto-material/cas/org2/ca-tls-admin/msp/signcerts/cert.pem
fabric-ca-client register -d --id.name peer1-org2 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name peer2-org2 --id.secret peer2PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name admin-org2 --id.secret org2AdminPW --id.type admin -u https://0.0.0.0:7054