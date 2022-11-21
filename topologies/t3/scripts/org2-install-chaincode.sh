#!/bin/bash
set -e
set -x

export CHAINCODE_DIR=/opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode/assets-transfer-basic/chaincode-go

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer1:7051
export CORE_PEER_MSPCONFIGPATH=/tmp/crypto-material/orgs/org2/admins/admin/msp
cd /tmp/assets/chaincode/assets-transfer-basic/config/org2

rm -rf code.tar.gz
rm -rf myccv1.tgz
rm -rf connection.json
rm -rf ca-cert.pem
cp /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem peers.pem
#cat /tmp/crypto-material/cas/org2/ca-tls/ca-cert.pem /tmp/crypto-material/peers/org2/peer1/node-tls/msp/signcerts/cert.pem /tmp/crypto-material/peers/org2/peer2/node-tls/msp/signcerts/cert.pem > peers.pem

sed -i ':a;N;$!ba;s/\n/\\\\n/g' peers.pem
ROOT_CERT=`cat peers.pem`
cat connection.json.template | sed -r "s;ROOT_CERT_VALUE;${ROOT_CERT};g" | tee connection.json > /dev/null 
tar cfz code.tar.gz connection.json
tar cfz myccv1.tgz code.tar.gz metadata.json

peer lifecycle chaincode install ./myccv1.tgz

export CORE_PEER_ADDRESS=${TOPOLOGY}-org2-peer2:7051
peer lifecycle chaincode install ./myccv1.tgz