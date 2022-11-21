#!/bin/bash

set -e

export CORE_PEER_ADDRESS=${TOPOLOGY}-org3-peer1:7051
export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org3/admins/admin/msp
QUERY_INSTALLED=`FABRIC_LOGGING_SPEC=ERROR peer lifecycle chaincode queryinstalled | grep myccv1`
IFS=' ' read -r -a array <<< $QUERY_INSTALLED
PACKAGE_ID=${array[2]}
PACKAGE_ID=${PACKAGE_ID::-1}
echo $PACKAGE_ID