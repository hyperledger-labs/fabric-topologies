#!/bin/sh
set -e
set -x

osnadmin channel join -o ${TOPOLOGY}-org1-orderer1:7057 \
  --ca-file /tmp/crypto-material/cas/org1/ca-tls-admin/msp/cacerts/0-0-0-0-7054.pem \
  --client-cert /tmp/crypto-material/cas/org1/ca-tls-admin/msp/signcerts/cert.pem \
  --client-key /tmp/crypto-material/cas/org1/ca-tls-admin/msp/keystore/key.pem \
  --channelID mychannel \
  --config-block /tmp/crypto-material/artifacts/channels/mychannel.pb

osnadmin channel join -o ${TOPOLOGY}-org1-orderer2:7057 \
  --ca-file /tmp/crypto-material/cas/org1/ca-tls-admin/msp/cacerts/0-0-0-0-7054.pem \
  --client-cert /tmp/crypto-material/cas/org1/ca-tls-admin/msp/signcerts/cert.pem \
  --client-key /tmp/crypto-material/cas/org1/ca-tls-admin/msp/keystore/key.pem \
  --channelID mychannel \
  --config-block /tmp/crypto-material/artifacts/channels/mychannel.pb

osnadmin channel join -o ${TOPOLOGY}-org1-orderer3:7057 \
  --ca-file /tmp/crypto-material/cas/org1/ca-tls-admin/msp/cacerts/0-0-0-0-7054.pem \
  --client-cert /tmp/crypto-material/cas/org1/ca-tls-admin/msp/signcerts/cert.pem \
  --client-key /tmp/crypto-material/cas/org1/ca-tls-admin/msp/keystore/key.pem \
  --channelID mychannel \
  --config-block /tmp/crypto-material/artifacts/channels/mychannel.pb