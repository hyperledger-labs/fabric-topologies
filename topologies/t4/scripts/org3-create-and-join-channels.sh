#!/bin/sh
set -e
set -x

export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org3/admins/admin/msp

export CORE_PEER_ADDRESS=${TOPOLOGY}-org3-peer1:7051
peer channel join -b /tmp/crypto-material/artifacts/channels/mychannel.block

export CORE_PEER_ADDRESS=${TOPOLOGY}-org3-peer2:7051
peer channel join -b /tmp/crypto-material/artifacts/channels/mychannel.block