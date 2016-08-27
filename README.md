## How to build
sudo docker build -t igorbarinov/docker-parity-member .

## How to run
Configure MASTER_IP at ./1_run.sh
`./1_run.sh`

## Ports
* 30303  p2p networking
* 8545 rpc calls. Should be restricted by cors settings in Dockerfile/firewalled in production
* 8001 for static page web server to get enode. Used to bootstrap other nodes

## FAQ
Q: Where a /root volume mounted on local system?
A: `sudo docker inspect parity-master `

Q: How do I get into shell of a container?
A:  `sudo docker exec -it parity-master bash`

Q: Why should I  build this image from source?
A: While building, docker generates address, private keys, dapps ui password. If you use built image your credentials are like public. I do not recommend to use it in production.

## Source
Github: https://github.com/igorbarinov/docker-parity-master
based on: https://github.com/jesuscript/vagrant-eth-env

# docker-parity-member
