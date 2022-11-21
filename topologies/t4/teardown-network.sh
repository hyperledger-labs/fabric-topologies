#!/bin/bash
# -----stop script execution on error and log commands
set -e
set -x

export CURRENT_HL_TOPOLOGY=t1

# -----------------------------------------------------------------------------
# -----remove current topoloy containers containers
# -----------------------------------------------------------------------------
# -----the chaincode dockers throw an error as not being able to be deleted, although they are being deleted. ignoring errors here
set +e
docker ps --filter name=${CURRENT_HL_TOPOLOGY}-org --filter status=running -aq | xargs -r docker stop | xargs -r docker rm
docker ps --filter name=${CURRENT_HL_TOPOLOGY}-org --filter status=exited -aq | xargs -r docker rm
set -e

# -----------------------------------------------------------------------------
# -----clear any state data written to disk
# -----------------------------------------------------------------------------
# -----docker exec will throw error if no running container found
if [ "$( docker container inspect -f '{{.State.Status}}' ${CURRENT_HL_TOPOLOGY}-shell-cmd )" == "running" ] 
then
    docker exec ${CURRENT_HL_TOPOLOGY}-shell-cmd /bin/sh -c "/bin/sh /tmp/scripts/delete-state-data.sh"
else
    echo "Shell Cmd Container is not running."
fi

# -----------------------------------------------------------------------------
# -----remove the bootstrap shell container
# -----------------------------------------------------------------------------
# -----remove shell command container
docker ps --filter name=${CURRENT_HL_TOPOLOGY}-shell-cmd --filter status=running -aq | xargs -r docker stop | xargs -r docker rm
docker ps --filter name=${CURRENT_HL_TOPOLOGY}-shell-cmd --filter status=exited -aq | xargs -r docker rm
