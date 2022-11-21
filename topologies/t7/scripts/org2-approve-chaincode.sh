#!/bin/bash
set -e
set -x

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer1:7051
export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org2/admins/admin/msp
QUERY_INSTALLED=`FABRIC_LOGGING_SPEC=ERROR peer lifecycle chaincode queryinstalled | grep myccv1`
IFS=' ' read -r -a array <<< $QUERY_INSTALLED
PACKAGE_ID=${array[2]}
PACKAGE_ID=${PACKAGE_ID::-1}
echo "The Package ID for the installed chaincode is: $PACKAGE_ID"


peer lifecycle chaincode approveformyorg --channelID mychannel --name myccv1 --version "1.0" \
    --package-id $PACKAGE_ID \
    --peerAddresses ${TOPOLOGY}-org2-peer1:7051 \
    --peerAddresses ${TOPOLOGY}-org2-peer2:7051 \
    --tlsRootCertFiles /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem \
    --tlsRootCertFiles /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem \
    --sequence 1 --tls --cafile /tmp/crypto-material/cas/org1/ca-tls/ca-cert.pem \
    --collections-config /tmp/config/collections_config.json
peer lifecycle chaincode queryapproved -C mychannel --name myccv1 