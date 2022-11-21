#!/bin/bash
set -e
set -x

echo "Setup configs for couchdb1 ..."
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/log/file" -d '"/opt/couchdb/var/log/log.txt"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/log/writer" -d '"file"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/log/level" -d '"debug"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/couch_httpd_auth/timeout" -d '"60000"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/chttpd_auth/secret" -d '"e7d0e9c49271253dbd3bfdeb19ba9db5"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/couchdb/uuid" -d '"38567436ddaf5b11fb11181fdede1791"'
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/couchdb/os_process_timeout" -d '"60000"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/replicator/connection_timeout" -d '"60000"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/replicator/worker_processes" -d '"4"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb1.local/_config/query_server_config/os_process_limit" -d '"4"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_users" 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_replicator" 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_global_changes" 

echo "Setup configs for couchdb2 ..."
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/log/file" -d '"/opt/couchdb/var/log/log.txt"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/log/writer" -d '"file"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/log/level" -d '"debug"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/couch_httpd_auth/timeout" -d '"60000"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/chttpd_auth/secret" -d '"e7d0e9c49271253dbd3bfdeb19ba9db5"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/couchdb/uuid" -d '"38567436ddaf5b11fb11181fdede1791"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/couchdb/os_process_timeout" -d '"60000"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/replicator/connection_timeout" -d '"60000"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/replicator/worker_processes" -d '"4"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_node/couchdb@${TOPOLOGY}-org2-peer1-couchdb2.local/_config/query_server_config/os_process_limit" -d '"4"' 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_users" 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_replicator" 
curl -u admin:hltopos -X PUT "http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_global_changes"

echo "Setup cluster for couchdb1 node ..."
curl -u admin:hltopos -X POST -H "Content-Type: application/json" http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_cluster_setup -d '{"action": "enable_cluster", "bind_address":"0.0.0.0", "username": "admin", "password":"hltopos", "port": 5984, "node_count": "2", "remote_node": "t8-org2-peer1-couchdb2.local", "remote_current_user": "admin", "remote_current_password": "password"}'
curl -u admin:hltopos -X POST -H "Content-Type: application/json" http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_cluster_setup -d '{"action": "add_node", "host":"t8-org2-peer1-couchdb2.local", "port": 5984, "username": "admin", "password":"hltopos"}' 

echo "Setup cluster for couchdb2 node ..."
curl -u admin:hltopos -X POST -H "Content-Type: application/json" http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_cluster_setup -d '{"action": "enable_cluster", "bind_address":"0.0.0.0", "username": "admin", "password":"hltopos", "port": 5984, "node_count": "2", "remote_node": "t8-org2-peer1-couchdb1.local", "remote_current_user": "admin", "remote_current_password": "password"}' 
curl -u admin:hltopos -X POST -H "Content-Type: application/json" http://${TOPOLOGY}-org2-peer1-couchdb2.local:5984/_cluster_setup -d '{"action": "add_node", "host":"t8-org2-peer1-couchdb1.local", "port": 5984, "username": "admin", "password":"hltopos"}' 

echo "Finish cluster ..."
curl -u admin:hltopos -X POST -H "Content-Type: application/json" http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_cluster_setup -d '{"action": "finish_cluster"}' 

# curl -u admin:hltopos "http://${TOPOLOGY}-org2-peer1-couchdb1.local:5984/_membership" 