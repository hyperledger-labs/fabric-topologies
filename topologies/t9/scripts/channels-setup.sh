#!/bin/sh
set -e
set -x

export FABRIC_CFG_PATH=/tmp/crypto-material/config
configtxgen -profile MyChannel -outputBlock /tmp/crypto-material/artifacts/channels/mychannel.pb -channelID mychannel