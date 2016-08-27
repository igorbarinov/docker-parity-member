## How to build
sudo docker build -t igorbarinov/docker-parity-master .

## How to run
`sudo docker run --name parity-master -p 8545:8545 -p 30303:30303 -p 8001:8001 -p 8002 -d igorbarinov/docker-parity-master`

## Ports
* 30303  p2p networking
* 8545 rpc calls. Should be restricted by cors settings in Dockerfile/firewalled in production
* 8001 for static page web server to get enode. Used to bootstrap other nodes
* 8002 for Parity UI (should be restricted to docker host/firewalled in production

## FAQ
Q: Where a /root volume mounted on local system?
A: `sudo docker inspect parity-master `

Q: How do I get into shell of a container?
A:  `sudo docker exec -it parity-master bash`

Q: How do I get credentials to connect to Parity UI?
A: Shell to a docker container. Cat passwords to console ` cat /etc/init.d/parity `
copy username from --dapps-user and pass from --dapps-pass

Q: How do I connect to Parity UI?
A: In browser type http://IP_OF_CONTAINER:8002 . You can get IPAddress of the container using `docker inspect parity-master | grep \"IPAddress\"`

Q: Why to build from source?
A: While building, docker generates address, private keys, dapps ui password. If you use built image your credentials are like public. I do not recommend to use it in production.

## Source
Github: https://github.com/igorbarinov/docker-parity-master
based on: https://github.com/jesuscript/vagrant-eth-env

# docker-parity-member
