#!/bin/bash
set -e
set -x

mkdir -p /tmp/crypto-material/config
cp /tmp/config/configtx.yaml /tmp/crypto-material/config

cat /tmp/config/configtx.yaml | sed -r "s;<<CURRENT_HL_TOPOLOGY>>;${TOPOLOGY};g" | tee /tmp/crypto-material/config/configtx.yaml > /dev/null 