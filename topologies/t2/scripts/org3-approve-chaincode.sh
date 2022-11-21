#!/bin/bash
set -e
set -x

export CORE_PEER_ADDRESS=${TOPOLOGY}-org3-peer1:7051
export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org3/admins/admin/msp
QUERY_INSTALLED=`FABRIC_LOGGING_SPEC=ERROR peer lifecycle chaincode queryinstalled | grep myccv1`
IFS=' ' read -r -a array <<< $QUERY_INSTALLED
PACKAGE_ID=${array[2]}
PACKAGE_ID=${PACKAGE_ID::-1}
echo "The Package ID for the installed chaincode is: $PACKAGE_ID"


peer lifecycle chaincode approveformyorg --channelID mychannel -o ${TOPOLOGY}-orderers-proxy:8443 --name myccv1 --version "1.0" \
    --package-id $PACKAGE_ID \
    --peerAddresses ${TOPOLOGY}-org3-peers-proxy:8443 \
    --tlsRootCertFiles /tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem \
    --sequence 1 --tls --cafile /tmp/crypto-material/cas/orgs/tls/org1-org2-ca-cert.pem

peer lifecycle chaincode queryapproved -C mychannel --name myccv1 