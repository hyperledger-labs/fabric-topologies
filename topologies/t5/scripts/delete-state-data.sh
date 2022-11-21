#!/bin/bash
set -e
set -x

# remove crypto material files
rm -rf /tmp/crypto-material/*
touch /tmp/crypto-material/.gitkeep

rm -rf /tmp/homefolders/*
touch /tmp/homefolders/.gitkeep
