#!/bin/bash

set -e
set -x

source /tmp/scripts/find-ca-private-key.sh

CA_PRIV_KEYFILE=`find_private_key_path /tmp/crypto-material/cas/org2/ca-tls`
cp $CA_PRIV_KEYFILE /tmp/crypto-material/cas/org2/ca-tls/msp/keystore/key.pem