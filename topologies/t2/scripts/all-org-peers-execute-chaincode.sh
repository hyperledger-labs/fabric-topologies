#!/bin/sh

set -e
set -x

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer1:7051
export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org2/users/user/msp
peer chaincode invoke -C mychannel -o ${TOPOLOGY}-orderers-proxy:8443 -n myccv1 -c '{"Args":["InitLedger"]}' --waitForEvent --tls --cafile /tmp/crypto-material/cas/orgs/tls/org1-org2-ca-cert.pem \
    --peerAddresses ${TOPOLOGY}-org2-peers-proxy:8443 \
    --peerAddresses ${TOPOLOGY}-org3-peers-proxy:8443 \
    --tlsRootCertFiles /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem \
    --tlsRootCertFiles /tmp/crypto-material/cas/org3/ca-tls/ca-cert.pem \


peer chaincode query -C mychannel -n myccv1 -c '{"Args":["GetAllAssets"]}'
