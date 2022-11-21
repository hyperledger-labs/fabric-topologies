#!/bin/bash
# -----stop script execution on error and log commands
set -e
set -x

# -----get the folder of where the current script is located
export HL_TOPOLOGIES_BASE_FOLDER=$( cd ${0%/*} && pwd -P )
rm -rf ./topologies

export CURRENT_HL_TOPOLOGY=t9
echo "Topology ${CURRENT_HL_TOPOLOGY} Root Folder Set to: ${HL_TOPOLOGIES_BASE_FOLDER}"

# -----delete any old or existing docker networks and clear any state data----
echo "Deleting the old network..."
./teardown-network.sh

# -----bring up the hyperledger admin shell terminal console, used to bootstrap the network
docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
    -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-shell-cmd.yml up -d

# -----begin by modifying the configtx yaml file with any string replacements
echo "Starting the setup of the new network..."

docker exec ${CURRENT_HL_TOPOLOGY}-shell-cmd /bin/sh -c "/bin/sh /tmp/scripts/patch-configtx.sh"

# Setup docker images for openssl
./scripts/setup-docker-images.sh ${HL_TOPOLOGIES_BASE_FOLDER}

# -----------------------------------------------------------------------------
# -----setup the CAs for all orgs and register with these the TLS-CA and Identities-CA users, such as admins, clients, etc...-----
# -----------------------------------------------------------------------------
# -----org1 CAs
docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/cas/org1-cas/docker-compose-org1-cas.yml up -d org1-ca-tls
sleep 2
docker exec ${CURRENT_HL_TOPOLOGY}-org1-ca-tls /bin/sh -c "/bin/sh /tmp/scripts/org1-register-identities-with-ca-tls.sh"

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/cas/org1-cas/docker-compose-org1-cas.yml up -d org1-ca-identities
sleep 2
docker exec ${CURRENT_HL_TOPOLOGY}-org1-ca-identities /bin/sh -c "/bin/sh /tmp/scripts/org1-register-identities-with-ca-identities.sh"

# -----org2 CAs
docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/cas/org2-cas/docker-compose-org2-cas.yml up -d org2-ca-tls
sleep 2
docker exec ${CURRENT_HL_TOPOLOGY}-org2-ca-tls /bin/sh -c "/bin/sh /tmp/scripts/org2-register-identities-with-ca-tls.sh"

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/cas/org2-cas/docker-compose-org2-cas.yml up -d org2-ca-identities
sleep 2
docker exec ${CURRENT_HL_TOPOLOGY}-org2-ca-identities /bin/sh -c "/bin/sh /tmp/scripts/org2-register-identities-with-ca-identities.sh"

# -----org3 CAs
docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/cas/org3-cas/docker-compose-org3-cas.yml up -d org3-ca-tls
sleep 2
docker exec ${CURRENT_HL_TOPOLOGY}-org3-ca-tls /bin/sh -c "/bin/sh /tmp/scripts/org3-register-identities-with-ca-tls.sh"

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/cas/org3-cas/docker-compose-org3-cas.yml up -d org3-ca-identities
sleep 2
docker exec ${CURRENT_HL_TOPOLOGY}-org3-ca-identities /bin/sh -c "/bin/sh /tmp/scripts/org3-register-identities-with-ca-identities.sh"

# -----------------------------------------------------------------------------
# -----setup the Peers for all orgs-----
# -----------------------------------------------------------------------------
# -----begin by enrolling each orgs' TLS-CA and Identities-CA users
docker exec ${CURRENT_HL_TOPOLOGY}-org2-ca-tls /bin/sh -c "/bin/sh /tmp/scripts/org2-enroll-identities-with-ca-tls.sh"
docker exec ${CURRENT_HL_TOPOLOGY}-org2-ca-identities /bin/sh -c "/bin/sh /tmp/scripts/org2-enroll-identities-with-ca-identities.sh"

docker exec ${CURRENT_HL_TOPOLOGY}-org3-ca-tls /bin/sh -c "/bin/sh /tmp/scripts/org3-enroll-identities-with-ca-tls.sh"
docker exec ${CURRENT_HL_TOPOLOGY}-org3-ca-identities /bin/sh -c "/bin/sh /tmp/scripts/org3-enroll-identities-with-ca-identities.sh"

# -----org2 peers
docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/peers/org2-peers/docker-compose-org2-peers.yml up -d org2-peer1

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/peers/org2-peers/docker-compose-org2-peers.yml up -d org2-peer2

# -----org3 peers 
docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/peers/org3-peers/docker-compose-org3-peers.yml up -d org3-peer1

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/peers/org3-peers/docker-compose-org3-peers.yml up -d org3-peer2

# -----------------------------------------------------------------------------
# -----setup CLIs for each org-----
# -----------------------------------------------------------------------------
docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/clis/org2-clis/docker-compose-org2-clis.yml up -d org2-cli-peer1

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/clis/org3-clis/docker-compose-org3-clis.yml up -d org3-cli-peer1

# -----------------------------------------------------------------------------
# -----setup Orderers -----
# -----------------------------------------------------------------------------
# -----enroll orderer users with TLS-CA and Identities-CA for org1, the orderer org
docker exec ${CURRENT_HL_TOPOLOGY}-org1-ca-tls /bin/sh -c "/bin/sh /tmp/scripts/org1-enroll-identities-with-ca-tls.sh"
docker exec ${CURRENT_HL_TOPOLOGY}-org1-ca-identities /bin/sh -c "/bin/sh /tmp/scripts/org1-enroll-identities-with-ca-identities.sh"

# -----generate the mychannel artifacts
docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/channels-setup.sh"

sleep 1

# -----bring up org1 orderers
docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/orderers/org1-orderers/docker-compose-org1-orderers.yml up -d org1-orderer1

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/orderers/org1-orderers/docker-compose-org1-orderers.yml up -d org1-orderer2

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/orderers/org1-orderers/docker-compose-org1-orderers.yml up -d org1-orderer3

docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/org1-join-channels.sh"

# -----need to wait until raft leader selection is completed for the orderers-----------
sleep 4

# -----------------------------------------------------------------------------
# -----setup Channels -----
# -----------------------------------------------------------------------------
docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/org2-join-channels.sh"
docker exec ${CURRENT_HL_TOPOLOGY}-org3-cli-peer1 /bin/sh -c "/tmp/scripts/org3-join-channels.sh"

# -----------------------------------------------------------------------------
# -----setup Chaincode -----
# -----------------------------------------------------------------------------
docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/org2-install-chaincode.sh"
docker exec ${CURRENT_HL_TOPOLOGY}-org3-cli-peer1 /bin/sh -c "/tmp/scripts/org3-install-chaincode.sh"

sleep 1

docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/org2-approve-chaincode.sh"
docker exec ${CURRENT_HL_TOPOLOGY}-org3-cli-peer1 /bin/sh -c "/tmp/scripts/org3-approve-chaincode.sh"

sleep 1

docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/all-org-peers-commit-chaincode.sh"

sleep 1

# -----------------------------------------------------------------------------
# -----test Chaincode with invoke and query-----
# -----------------------------------------------------------------------------
docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/all-org-peers-execute-chaincode.sh"

echo "******* NETWORK SETUP COMPLETED *******"
