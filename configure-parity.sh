  
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

