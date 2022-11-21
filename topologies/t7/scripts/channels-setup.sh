#!/bin/sh
set -e
set -x

export FABRIC_CFG_PATH=/tmp/crypto-material/config
configtxgen -profile OrgsOrdererGenesis -outputBlock /tmp/crypto-material/artifacts/channels/genesis.block -channelID syschannel
configtxgen -profile OrgsChannel -outputCreateChannelTx /tmp/crypto-material/artifacts/channels/channel.tx -channelID mychannel