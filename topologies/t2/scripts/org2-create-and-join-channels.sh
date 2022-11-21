#!/bin/sh
set -e
set -x

export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org2/admins/admin/msp
peer channel create -c mychannel -f /tmp/crypto-material/artifacts/channels/channel.tx -o ${TOPOLOGY}-orderers-proxy:8443 --outputBlock /tmp/crypto-material/artifacts/channels/mychannel.block --tls --cafile /tmp/crypto-material/cas/orgs/tls/org1-org2-ca-cert.pem

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer1:7051
peer channel join -b /tmp/crypto-material/artifacts/channels/mychannel.block

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer2:7051
peer channel join -b /tmp/crypto-material/artifacts/channels/mychannel.block