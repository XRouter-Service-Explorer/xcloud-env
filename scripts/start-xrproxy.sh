#!/bin/bash

cat > /opt/uwsgi/conf/uwsgi.ini << EOL
[uwsgi]
processes = 4
threads = 4
buffer-size = 32768
set-ph = SERVICENODE_PRIVKEY=${SN_KEY}
set-ph = BLOCKNET_CHAIN=mainnet
set-ph = RPC_BLOCK_HOSTIP=snode
set-ph = RPC_BLOCK_PORT=41414
set-ph = RPC_BLOCK_USER=${RPC_USER}
set-ph = RPC_BLOCK_PASS=${RPC_PASSWORD}
set-ph = RPC_BLOCK_VER=2.0

set-ph = RPC_BLOCK_HOSTIP=127.0.0.1
set-ph = RPC_BLOCK_PORT=41414
set-ph = RPC_BLOCK_USER=${RPC_USER}
set-ph = RPC_BLOCK_PASS=${RPC_PASSWORD}
set-ph = RPC_BLOCK_VER=2.0

EOL

# ensure supervisord runs at pid1
exec supervisord -c /etc/supervisord.conf