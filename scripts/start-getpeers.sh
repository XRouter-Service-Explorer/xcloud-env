#!/bin/bash

cat > /app/appsettings.json << EOL
{
  "CoinConfig": ${COIN_CONFIG},
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "System": "Information",
      "Microsoft": "Information"
    }
  },
  "Kestrel": {
    "EndPoints": {
      "Http": {
        "Url": "http://0.0.0.0:8080"
      }
    }
  }
}

EOL

cat /app/appsettings.json

echo "Starting GetPeers Container"

dotnet XCloud.GetPeers.Api.dll