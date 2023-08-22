#!/bin/bash

read -p "Enter string tou would like to hash" try
hash=$(echo "$try"| sha256sum)
echo "$hash"
