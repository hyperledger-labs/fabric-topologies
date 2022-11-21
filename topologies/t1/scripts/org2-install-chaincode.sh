#!/bin/bash
set -e
set -x

export CHAINCODE_DIR=/opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/assets-transfer-basic/chaincode-go

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer1:7051
export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org2/admins/admin/msp
peer lifecycle chaincode package mycc.tar.gz --path $CHAINCODE_DIR --lang golang --label myccv1
peer lifecycle chaincode install mycc.tar.gz

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer2:7051
peer lifecycle chaincode install mycc.tar.gz