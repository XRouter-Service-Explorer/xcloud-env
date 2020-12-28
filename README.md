# Enterprise Proxy XCloud Environment

Work in progress: Tor configuration
## Usage
Add the following config to environment variable
```
export PUBLIC_IP="x.x.x.x"                  # Update with your public ip address
export SN_NAME="snode01"                    # Update with your snode name
export SN_KEY="servicenodeprivatekey"       # Update with your snode private key
export SN_ADDRESS="servicenodekeyaddress"   # Update with your snode address
export RPC_USER="user"                      # Update with your rpc username
export RPC_PASSWORD="password"              # Update with your rpc password
export BLOCKNET_DATADIR="~/.blocknet"       # Update with your blocknet data directory path
export ONION_ADDRESS="onionaddress"         # Update with your onion address

```

## Tor
```
./deploy.sh tor
```