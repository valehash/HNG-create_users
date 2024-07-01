#!/bin/bash

if [[ ! -e /var/log/user_management.log ]]; then

    sudo touch /var/log/user_management.log
fi

if [[ ! -e /var/secure/user_passwords.txt ]]; then

    sudo touch /var/secure/user_passwords.txt
fi

log_file="/var/log/user_management.log"
pass_file="/var/secure/user_passwords.log"

echo "logfile created..." >> $log_file
echo "checking if text_file exists" >> $log_file

if [[ -z "$1" ]]; then
    echo "Usage: $0 filename"
    echo "Text file does not exist. ...exiting" >> $log_file
    exit 1
fi

echo "Reading file" >> $log_file

file_path="$1"
if [[ -f "$file_path" ]]; then
	echo "fetching the usernames and groups" >> $log_file
	while IFS= read -r lines; do
		user_name=$(echo "$lines" | awk -F';' '{print $1}') #explain in the post
		groups=$(echo "$lines" | awk -F';' '{print $2}')

		if id -u "$user_name">/dev/null 2>&1; then #explain in the post
			echo "user $user_name already exists"
			echo "user $user_name already exists" >> $log_file
		else
			IFS=',' read -ra group_array <<< "$groups" #explain in the post
			for group in "${group_array[@]}"; do
				if ! getent group "$group" >/dev/null 2>&1; then #explain in the post
					sudo groupadd "$group"
					echo "Group $group created"
					
					echo "Group $group created" >> $log_file
				fi
			done
			
			password=$(openssl rand -base64 12)


			sudo useradd -m -G "$groups" -p "$(openssl passwd -1 "$password")" "$user_name" #explain in post
			echo "adding groups :$groups for user: $user_name and password in $pass_file " >> $log_file
			
			sudo chmod 700 "/home/$user_name"
			sudo chown "$user_name:$user_name" "/home/$user_name"
			
			echo "Home directory for $user set up with appropriate permissions and ownership" >> $log_file

			echo "$user_name,$password" >> "$pass_file"
		fi
	done < "$file_path"
	sudo chmod 600 "$password_file"
    	sudo chown "$(id -u):$(id -g)" "$password_file"
    	echo "File permissions for $password_file set to owner-only read" >> $log_file
else
	echo "File not found: $file_path"
	echo "File not found: $file_path" >> "$log_file"
	exit 1

fi
