#!/bin/bash
ADDR=$@
curl -d "address=${ADDR}" -s http://192.168.33.171
echo
