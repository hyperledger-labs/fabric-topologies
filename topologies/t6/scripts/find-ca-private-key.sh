#!/bin/bash

set -e
set -x

find_private_key_path() {
    CA_HOME=$1
    CA_CERTFILE=$CA_HOME/tls-cert.pem
    CA_HASH=`openssl x509 -noout -pubkey -in $CA_CERTFILE | openssl md5`

    for x in $CA_HOME/msp/keystore/*_sk; do 
    CA_KEYFILE_HASH=`openssl pkey -pubout -in ${x%} | openssl md5`
    if [[ "${CA_KEYFILE_HASH}" == "${CA_HASH}" ]]
    then
        echo ${x%}
        return 0
    fi
    done

    return -1
}