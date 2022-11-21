#!/bin/bash
set -e
set -x

# remove crypto material files
rm -rf /tmp/crypto-material/*
touch /tmp/crypto-material/.gitkeep

rm -rf /tmp/homefolders/*
mkdir -p /tmp/homefolders/peer1/couchdb1/logs
touch /tmp/homefolders/peer1/couchdb1/logs/.gitkeep
mkdir -p /tmp/homefolders/peer1/couchdb1/data
touch /tmp/homefolders/peer1/couchdb1/data/.gitkeep
mkdir -p /tmp/homefolders/peer1/couchdb1/config
touch /tmp/homefolders/peer1/couchdb1/config/.gitkeep
mkdir -p /tmp/homefolders/peer1/couchdb2/logs
touch /tmp/homefolders/peer1/couchdb2/logs/.gitkeep
mkdir -p /tmp/homefolders/peer1/couchdb2/data
touch /tmp/homefolders/peer1/couchdb2/data/.gitkeep
mkdir -p /tmp/homefolders/peer1/couchdb2/config
touch /tmp/homefolders/peer1/couchdb2/config/.gitkeep