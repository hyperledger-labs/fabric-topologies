/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"io/ioutil"
	"log"
	"os"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/hyperledger/fabric-samples/asset-transfer-basic/chaincode-go/chaincode"
)

func main() {
	assetChaincode, err := contractapi.NewChaincode(&chaincode.SmartContract{})
	if err != nil {
		log.Panicf("Error creating asset-transfer-basic chaincode: %v", err)
	}

	//The ccid is assigned to the chaincode on install (using the “peer lifecycle chaincode install <package>” command) for instance
	ccid := os.Getenv("CHACINCODE_ID")
	address := os.Getenv("CHACINCODE_ADDRESS")

	server := &shim.ChaincodeServer{
		CCID:     ccid,
		Address:  address,
		CC:       assetChaincode,
		TLSProps: getTLSProperties(),
	}
	log.Printf("Starting the chaincode server ...")
	if err := server.Start(); err != nil {
		log.Panicf("error starting server chaincode: %s", err)
	}
}

func getTLSProperties() shim.TLSProperties {

	key := getEnvOrDefault("CHAINCODE_TLS_KEY", "")
	cert := getEnvOrDefault("CHAINCODE_TLS_CERT", "")
	clientCACert := getEnvOrDefault("CHAINCODE_CLIENT_CA_CERT", "")

	tlsDisabled := false
	var keyBytes, certBytes, clientCACertBytes []byte
	var err error

	if !tlsDisabled {
		keyBytes, err = ioutil.ReadFile(key)
		if err != nil {
			log.Panicf("error while reading the crypto file: %s", err)
		}
		certBytes, err = ioutil.ReadFile(cert)
		if err != nil {
			log.Panicf("error while reading the crypto file: %s", err)
		}
	}
	// Did not request for the peer cert verification
	if clientCACert != "" {
		clientCACertBytes, err = ioutil.ReadFile(clientCACert)
		if err != nil {
			log.Panicf("error while reading the crypto file: %s", err)
		}
	}

	return shim.TLSProperties{
		Disabled:      tlsDisabled,
		Key:           keyBytes,
		Cert:          certBytes,
		ClientCACerts: clientCACertBytes,
	}
}

func getEnvOrDefault(env, defaultVal string) string {
	value, ok := os.LookupEnv(env)
	if !ok {
		value = defaultVal
	}
	return value
}
