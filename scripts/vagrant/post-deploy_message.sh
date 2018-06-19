#!/bin/bash

host_port=$(vagrant port --guest 8080)

echo
echo "========================================================="
echo "            LoRa App-Server can be accessed on:"
echo
echo "               https://localhost:$host_port"
echo "========================================================="
