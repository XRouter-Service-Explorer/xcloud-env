#!/bin/bash

cat > /opt/uwsgi/conf/uwsgi.ini << EOL
[uwsgi]
processes = ${CORES}
threads = 2
buffer-size = 32768

# Place your Service Node private key here (this is not a wallet private key!)
# Allows the XRouter Proxy to sign packets on your Service Node's behalf
# DO NOT SHARE THIS KEY

set-ph = SERVICENODE_PRIVKEY=${SN_KEY}

#  mainnet or testnet
set-ph = BLOCKNET_CHAIN=mainnet

# Handle XRouter payments

set-ph = HANDLE_PAYMENTS=true
set-ph = HANDLE_PAYMENTS_ENFORCE=true
set-ph = HANDLE_PAYMENTS_RPC_INCLUDE_HEADERS=true
set-ph = HANDLE_PAYMENTS_RPC_HOSTIP=snode
set-ph = HANDLE_PAYMENTS_RPC_PORT=41414
set-ph = HANDLE_PAYMENTS_RPC_USER=${RPC_USER}
set-ph = HANDLE_PAYMENTS_RPC_PASS=${RPC_PASSWORD}
set-ph = HANDLE_PAYMENTS_RPC_VER=2.0

# BLOCK SPV RPC configuration
set-ph = RPC_BLOCK_HOSTIP=snode
set-ph = RPC_BLOCK_PORT=41414
set-ph = RPC_BLOCK_USER=${RPC_USER}
set-ph = RPC_BLOCK_PASS=${RPC_PASSWORD}
set-ph = RPC_BLOCK_VER=2.0

EOL

cat > /etc/nginx/nginx.conf << EOL
user nginx;                                                                     
worker_processes ${CORES};
                                                                                
error_log  /var/log/nginx/error.log warn;                                       
pid        /var/run/nginx.pid;                                                  
                                                                                
events {                                                                        
    worker_connections ${WORKER_CONNECTIONS};
}                                                                               
                                                                                
http {                                                                          
    include       /etc/nginx/mime.types;                                        
    default_type  application/octet-stream;                                     
    keepalive_timeout  65;                                                      
                                                                                
    log_format  main '\$ssl_protocol \$ssl_cipher ' '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                          '\$status \$body_bytes_sent "\$http_referer" '
                          '"\$http_user_agent" "\$http_x_forwarded_for"';
                                                                                
    access_log  /var/log/nginx/access.log  main;                                
                                                                                
    upstream uwsgicluster {                                                     
        server 127.0.0.1:8080;                                                  
    }                                                                           
                                                                                
    server {                                                                    
        listen              80;
        listen              443 ssl;
        server_name         ${SERVER_NAME};
        ssl_certificate     /opt/uwsgi/conf/cert.pem;
        ssl_certificate_key /opt/uwsgi/conf/key.pem;  

        # Proxying connections to application servers 
        location / {                                                            
                                                                                
        }                                                                       
                                                                                
        include /etc/nginx/conf.d/xcloud/*.conf;                                
                                                                                
        location ~ ^/xrs?/.*$ {                                                 
            root               /opt/uwsgi;                                      
            include            uwsgi_params;                                    
            uwsgi_pass         uwsgicluster;                                    
            proxy_redirect     off;                                             
            proxy_set_header   Host \$host;                                      
            proxy_set_header   X-Real-IP \$remote_addr;                          
            proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;      
            proxy_set_header   X-Forwarded-Host \$server_name;                   
        }                                                                       
    }                                                                           
                                                                                
    include /etc/nginx/conf.d/*.conf;                                           
}                  
EOL

# ensure supervisord runs at pid1
exec supervisord -c /etc/supervisord.conf