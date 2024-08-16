#!/bin/bash

LOOKUP=($@ "ifconfig.me" "icanhazip.com" "ifconfig.co" "2ip.ru")

curl_host() {
  response=$(curl --write-out "%{http_code}" --silent --output /dev/null -L https://$1 --resolve "$1:443:127.0.0.1")

  if [ "$response" -eq 200 ]; then
    return 0
  fi

  return 1
}

for host in "${LOOKUP[@]}"; do
  if $(curl_host $host); then
    echo "Success $host"
    exit 0
  else
    echo "Err $host"
  fi
done

exit 1