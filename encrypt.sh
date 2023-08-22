#!/bin/bash
read -p "Enter string tou would like to hash " try
encrypt(){
	local st="$1"
	local enc1="$(echo "$st" | openssl enc -aes-256-cbc -a -k "hrzl" -pbkdf2 -iter 10)" 
	echo "$enc1"
}

decrypt(){
	local st="$1"
	local denc1="$(echo "$st" | openssl enc -d -aes-256-cbc -a -k "hrzl" -pbkdf2 -iter 10)"
	echo "$denc1"
}
echo "$(encrypt $try)"
echo "$(decrypt $(encrypt $try))"



