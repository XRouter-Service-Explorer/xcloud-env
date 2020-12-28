# Enterprise Proxy XCloud Environment

Example with a xcloud plugin. In this example the [GetPeers](https://github.com/XRouter-Service-Explorer/XCloud.GetPeers) plugin is used.

`COIN_CONFIG` variable is needed as configuration for the plugin. In this case the Blocknet (BLOCK) daemon information is passed to the plugin.
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
export COIN_CONFIG='[                       # Update with JSON format for each coin. 
    {
      "DaemonUrl": "http://user:password@snode:41414",
      "WalletPassword": "",
      "RpcUserName": "user",
      "RpcPassword": "password",
      "RpcRequestTimeoutInSeconds": 30,
      "CoinLongName": "Blocknet",
      "CoinShortName": "BLOCK"
    }
  ]'
```