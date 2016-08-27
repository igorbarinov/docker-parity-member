#!/bin/bash

# remove running container
sudo docker rm -f parity-member1

# ip of master node in your private blockchain
MASTER_IP=172.17.0.2
# port for p2p netorking in your private blockchain
MASTER_PORT=30303
# caddy web server serves static content, e.g. chain.json and enode id
CADDY_PORT=8001
# this one is very important. Here we get bootstrap enode it 
ENODE="$(curl -q $MASTER_IP:$CADDY_PORT)$MASTER_IP:$MASTER_PORT"

# we pass ip and caddy port of the master node to get chain.json of master node from the docker container
sudo docker run --name parity-member1 -e ENODE=$ENODE -e MASTER_IP=$MASTER_IP -e CADDY_PORT=$CADDY_PORT -d igorbarinov/docker-parity-member

sudo docker exec -it parity-member1 bash 

