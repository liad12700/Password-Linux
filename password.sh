#!/bin/bash

createuser() {
	read -p "Oh I see that you are a new user, Please enter your password " pass
	hash_pass=$(echo "$pass"| sha256sum)
	sqlite3 data.db "INSERT INTO users (username, pass) VALUES('$hash_user', '$hash_pass')"
	option
}

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


openscreen() {
	read -p  "Hello, Please enter your username " username
	hash_user=$(echo "$username"| sha256sum)
	check=$(sqlite3 data.db "SELECT COUNT(*) FROM users WHERE username='$hash_user'") 
	if [ "$check" -gt "0" ];
        	then
			echo "Oh I see that you have an account please enter your passward " 
			chpa
        	else    
                	createuser
	fi
}

chpa() {
 read pass
 hash_pass=$(echo "$pass"| sha256sum)
 check_pass=$(sqlite3 data.db "SELECT COUNT(*) FROM users WHERE username='$hash_user' AND pass='$hash_pass'")
 if [ "$check_pass" -gt "0" ];
         then   
		start
         else
                echo "YOU ARE WRONG Please try again"
		chpa
         fi

}

start() {
	echo "WELCOME!!!"
        echo "What would you like to do? "
	option
}

option() {
	read -p "<1> Add New Password    <2>Check Password     <3> Delete Your Account <4> EXIT " ans
        if [ "$ans" -eq "1" ]; 
                then
                        insert
        elif [ "$ans" -eq "2" ]; 
                then
                        spass
        elif [ "$ans" -eq "3" ];
                then
                        delete
        elif [ "$ans" -eq "4" ];
		then	
			exit 0
			echo "BYE BYE!"
	else
                echo "Please enter number from the options"
                option
        fi

}

insert() {
	read -p "Enter the site or app name of your passward you want to add " site
	chsite=$(sqlite3 data.db "SELECT COUNT(*) FROM data WHERE site='$(echo "$site"| sha256sum)' AND user_name='$hash_user'")
	if [ "$chsite" -eq "0" ]; then
		read -p "Enter the passward " pass_add
		sqlite3 data.db "INSERT INTO data (site, pass_site, user_name) VALUES('$(echo "$site"| sha256sum)', '$(encrypt $pass_add)', '$hash_user')"
        	echo "Password Added Successfully"
		option
        else
		echo "You already inserted a password in this site"
		option
	fi
	}


spass() {
	read -p "Type the site or app of the password that you would like to check? " csite
	chsite=$(sqlite3 data.db "SELECT COUNT(*) FROM data WHERE site='$(echo "$csite"| sha256sum)' AND user_name='$hash_user'")
	if [ "$chsite" -eq "0" ]; then
		echo "You Didnt Save a Passward of $csite"
		spass
	else
echo "Your Passard Is: $(decrypt $(sqlite3 data.db "SELECT pass_site FROM data WHERE user_name='$hash_user' AND site='$(echo "$csite"|\
 sha256sum)'"))"
		option
	fi
}

delete() {
	echo "Are You Sure You Want To DELETE your account?"
	read -p "Type 1 if yes, if you dont want to so just click any diffrent button " dans
	if [ "$dans" -eq "1" ]; then
		sqlite3 data.db "DELETE FROM data WHERE user_name='$hash_user'"
		sqlite3 data.db "DELETE FROM users WHERE username='$hash_user'"
		echo "Your Account Removed Successfully"
		openscreen
	else
		option
	fi
}

openscreen

