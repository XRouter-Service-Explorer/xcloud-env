#!/bin/bash

#install jq
function installJq(){
	# echo 'test'
	sudo apt-get update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
		jq

}

function configure(){
	IFS=, read -a coins <<< ${COINS}

	# empty array

	jq 'del(.CoinConfig[])' < appsettings.json > temp && mv temp appsettings.json
	for coin in "${coins[@]}"
	do
		xbridge_conf=$( curl -s -L -X GET 'https://raw.githubusercontent.com/blocknetdx/blockchain-configuration-files/master/manifest.json' -H 'Content-Type: application/json'| jq --arg coin "$coin" --raw-output '[.[]|select(.ticker==$coin)][0].xbridge_conf')
	
		coin_long_name=$( curl -s -L -X GET 'https://raw.githubusercontent.com/blocknetdx/blockchain-configuration-files/master/xbridge-confs/'${xbridge_conf} -H 'Content-Type: application/json' | awk -F "=" '/Title/ {print $2}' | tr -d '\r')
		rpcport=$( curl -s -L -X GET 'https://raw.githubusercontent.com/blocknetdx/blockchain-configuration-files/master/xbridge-confs/'${xbridge_conf} -H 'Content-Type: application/json' | awk -F "=" '/Port/ {print $2}' | tr -d '\r')

		echo ""
		echo "[$coin]"
		echo "Please specify an RPC user and RPC password"
		read -p 'RPC Username: ' rpc_user
		read -sp 'RPC Password: ' rpc_pass
		echo -e "\n"
		daemonUrl="http://"
		daemonUrl=${daemonUrl}${rpc_user}:${rpc_pass}@localhost:${rpcport}
		jq --arg coinShortName "$coin" --arg coinLongName "$coin_long_name" --arg daemonUrl "$daemonUrl" --arg rpcUser "$rpc_user" --arg rpcPass "$rpc_pass" '.CoinConfig += [{"CoinShortName": $coinShortName, "CoinLongName": $coinLongName,"DaemonUrl": $daemonUrl, "WalletPassword": "", "RpcUserName": $rpcUser, "RpcPassword": $rpcPass, "RpcRequestTimeoutInSeconds": 30}]' < appsettings.json > temp && mv temp appsettings.json	
	done

	echo "Starting GetPeers Container"

	dotnet XCloud.GetPeers.Api.dll
}

read -p 'Install jq (required)? [y/n] ' inst_jq
if [ $inst_jq = "y" ]; then
   installJq
   configure
else
  echo "Not installing jq..."
  echo "Not starting XCloud Plugin GetPeers"
fi


