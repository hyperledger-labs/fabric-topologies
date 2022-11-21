#!/bin/sh
set -e
set -x

export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org2/admins/admin/msp

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer1:7051
peer channel join -b  /tmp/crypto-material/artifacts/channels/mychannel.pb

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer2:7051
peer channel join -b  /tmp/crypto-material/artifacts/channels/mychannel.pb