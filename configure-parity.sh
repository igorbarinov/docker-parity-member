  
#!/bin/bash

echo "home: $HOME"
echo "user: $(whoami)"



#####################
# create an account #
#####################
PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
echo $PASSWORD > $HOME/.parity-pass

expect_out= expect -c "
spawn sudo parity account new
puts $HOME
expect \"Type password: \"
send ${PASSWORD}\n
expect \"Repeat password: \"
send ${PASSWORD}\n
interact
"

echo $expect_out

address=0x$(parity account list | awk 'END{print}' | tr -cd '[:alnum:]._-')

################
# create chain #
################

cat > $HOME/chain.json <<EOL
{
  "name": "Private",
  "engine": {
    "BasicAuthority": {
      "params": {
        "gasLimitBoundDivisor": "0x0400",
        "durationLimit": "0x0d",
        "authorities" : ["0x3c1cae652b86e2a682ead733df95c0f5810e5683"]
      }
    }
  },
  "params": {
    "accountStartNonce": "0x00",
    "maximumExtraDataSize": "0x20",
    "minGasLimit": "0x1388",
    "networkID" : "0xad"
  },
  "genesis": {
    "seal": {
      "generic": {
        "fields": 1,
        "rlp": "0x11bbe8db4e347b4e8c937c1c8370e4b5ed33adb3db69cbdb7a38e1e50b1b82fa"
      }
    },
    "difficulty": "0x20000",
    "author": "0x0000000000000000000000000000000000000000",
    "timestamp": "0x00",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "extraData": "0x",
    "gasLimit": "0x2fefd8"
  },
  "nodes": [],
  "accounts": {
    "0000000000000000000000000000000000000001": { "balance": "1", "nonce": "1048576", "builtin": { "name": "ecrecover", "pricing": { "linear": { "base": 3000, "word": 0 } } } },
    "0000000000000000000000000000000000000002": { "balance": "1", "nonce": "1048576", "builtin": { "name": "sha256", "pricing": { "linear": { "base": 60, "word": 12 } } } },
    "0000000000000000000000000000000000000003": { "balance": "1", "nonce": "1048576", "builtin": { "name": "ripemd160", "pricing": { "linear": { "base": 600, "word": 120 } } } },
    "0000000000000000000000000000000000000004": { "balance": "1", "nonce": "1048576", "builtin": { "name": "identity", "pricing": { "linear": { "base": 15, "word": 3 } } } }
  }
}
EOL

# for reference
#command="parity --chain $HOME/chain.json --author ${address} --unlock ${address} --password $HOME/.parity-pass --rpccorsdomain \"*\" --jsonrpc-hosts=all --jsonrpc-interface all >&1 1>>/var/log/parity.log 2>&1"
DAPP_PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
#command="parity --dapps-port 8002 --dapps-interface $(ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
# --dapps-user user --dapps-pass $DAPP_PASSWORD --chain $HOME/chain.json --author ${address} --unlock ${address} --password $HOME/.parity-pass --rpccorsdomain \"*\" --jsonrpc-hosts=all --jsonrpc-interface all >&1 1>>/var/log/parity.log 2>&1"

command="parity --chain $HOME/chain.json --unlock ${address} --password $HOME/.parity-pass --rpccorsdomain \"*\" --jsonrpc-hosts=all --jsonrpc-interface all --bootnodes $ENODE  >&1 1>>/var/log/parity.log 2>&1"

printf "%s\n%s" "#!/bin/sh" "$command" | tee /usr/local/bin/parity.sh

echo parity:$command >> /etc/goreman/Procfile 
