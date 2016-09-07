FROM ubuntu:16.04

##################################
# install tools and dependencies #
##################################
ENV HOME=/root
RUN apt-get update -qq
RUN apt-get install -qq -y software-properties-common && add-apt-repository -y ppa:ethereum/ethereum 
RUN apt-get update -qq
RUN apt-get install -qq -y build-essential vim telnet wget git curl expect expect-dev unzip 

################
# install solc #
################
RUN apt-get -y install solc

##################
# install parity #
##################
ADD bin/parity.zip /usr/local/bin/parity.zip
RUN unzip /usr/local/bin/parity.zip -d /usr/local/bin

#################
# install caddy #
#################

RUN mkdir /var/www && mkdir /etc/caddy && curl https://getcaddy.com | bash
COPY caddyfile /etc/caddy

###################
# install goreman #
###################
COPY bin/goreman /usr/local/bin/goreman

####################
# configure parity #
####################
RUN mkdir /etc/goreman
COPY Procfile /etc/goreman
COPY configure-parity.sh $HOME/configure-parity.sh
RUN $HOME/configure-parity.sh

##########
# volume #
##########

VOLUME /root

# you need to specify -p 8545:8545 -p 30303:30303  in `docker run` to expose it to 0.0.0.0
EXPOSE 8545
EXPOSE 30303
# port for web server for static files with node id
EXPOSE 8001

COPY run.goreman /usr/local/bin
CMD ["run.goreman"]