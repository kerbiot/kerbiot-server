#!/bin/bash
IP=$(curl -s ipinfo.io/ip)
HEX=$(echo $IP | awk -F '.' '{printf "%x", ($1 * 2^24) + ($2 * 2^16) + ($3 * 2^8) + $4}')

echo $IP '->' $HEX '->' 'https://'$HEX'.nip.io'