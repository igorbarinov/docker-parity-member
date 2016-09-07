  
#!/bin/bash

#####################
# create an account #
#####################

PASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1)
echo $PASSWORD > $HOME/.parity-pass

parity account new --password $HOME/.parity-pass

address=0x$(parity account list | awk 'END{print}' | tr -cd '[:alnum:]._-')