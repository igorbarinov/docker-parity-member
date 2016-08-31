#!/bin/bash

# remove running container
sudo docker rm -f parity-member1

# ip of master node in your private blockchain
MASTER_IP=172.17.0.2

# default port for p2p netorking in your private blockchain
MASTER_PORT=30303
# default port for caddy web server on master node which serves static content, e.g. chain.json and enode id
CADDY_PORT=8001
# enode of master node, used by member node as connection string 
ENODE="$(curl -q $MASTER_IP:$CADDY_PORT)$MASTER_IP:$MASTER_PORT"

# we pass ip and caddy port of the master node to get chain.json of master node inside docker container
sudo docker run --name parity-member1 -p 8546:8545 -e ENODE=$ENODE -e MASTER_IP=$MASTER_IP -e CADDY_PORT=$CADDY_PORT -d igorbarinov/docker-parity-member

# bash to container, just in case you need to tail -f /var/log/parity
sudo docker exec -it parity-member1 bash 

