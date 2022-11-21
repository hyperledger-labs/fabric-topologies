#!/bin/bash
set -e
set -x

mkdir -p /tmp/crypto-material/cas/orgs/tls
cat /tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem \
    /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem > \
    /tmp/crypto-material/cas/orgs/tls/org1-org2-ca-cert.pem
