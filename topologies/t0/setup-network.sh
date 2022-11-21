#!/bin/bash
set -e
set -x

# get the folder of where the current script is located
export HL_TOPOLOGIES_BASE_FOLDER=$( cd ${0%/*} && pwd -P )
rm -rf ./topologies

export CURRENT_HL_TOPOLOGY=t0

# -----Delete old network----
echo "Deleting the old network..."
./teardown-network.sh

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
    -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-shell-cmd.yml up -d

echo "Starting the setup of the new network..."

docker exec ${CURRENT_HL_TOPOLOGY}-shell-cmd /bin/sh -c "/bin/sh /tmp/scripts/patch-configtx.sh"


# -----Setup CAs -----

# org1 CAs

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

# org2 CAs

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

# -----Setup Peers -----

docker exec ${CURRENT_HL_TOPOLOGY}-org2-ca-tls /bin/sh -c "/bin/sh /tmp/scripts/org2-enroll-identities-with-ca-tls.sh"
docker exec ${CURRENT_HL_TOPOLOGY}-org2-ca-identities /bin/sh -c "/bin/sh /tmp/scripts/org2-enroll-identities-with-ca-identities.sh"

# org2 single peer 

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/peers/org2-peers/docker-compose-org2-peers.yml up -d org2-peer1

# # # -----Setup CLIs -----

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/clis/org2-clis/docker-compose-org2-clis.yml up -d org2-cli-peer1


# -----Setup Orderers -----

docker exec ${CURRENT_HL_TOPOLOGY}-org1-ca-tls /bin/sh -c "/bin/sh /tmp/scripts/org1-enroll-identities-with-ca-tls.sh"
docker exec ${CURRENT_HL_TOPOLOGY}-org1-ca-identities /bin/sh -c "/bin/sh /tmp/scripts/org1-enroll-identities-with-ca-identities.sh"

# --setup channel --
docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/channels-setup.sh"

sleep 1

docker compose --env-file ${HL_TOPOLOGIES_BASE_FOLDER}/.env -f ${HL_TOPOLOGIES_BASE_FOLDER}/../docker-compose-base.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/docker-compose.yml \
   -f ${HL_TOPOLOGIES_BASE_FOLDER}/containers/orderers/org1-orderers/docker-compose-org1-orderers.yml up -d org1-orderer1

# Need to wait until raft leader selection is completed for the orderers
sleep 4
echo "Might be able to remove this sleep 4"

# -----Setup Channels -----

docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/org2-create-and-join-channels.sh"

# -----Setup Chaincode -----

docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/org2-install-chaincode.sh"

sleep 1

docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/org2-approve-chaincode.sh"

sleep 1

docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/all-org-peers-commit-chaincode.sh"

sleep 1

docker exec ${CURRENT_HL_TOPOLOGY}-org2-cli-peer1 /bin/sh -c "/tmp/scripts/all-org-peers-execute-chaincode.sh"

echo "******* NETWORK SETUP COMPLETED *******"
