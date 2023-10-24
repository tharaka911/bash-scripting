#!/bin/bash

# Define an array with user information
users=(
    "lakshan_sl \"password\" \"ssh-key\""
    # Add more users as needed
)

# Iterate through the array and create users with SSH keys and passwords
for user_info in "${users[@]}"; do
    # Split the user information into username, public key, and password
    read -r username password public_key  <<< "$user_info"

    # Remove the double quotes around the public key and password
    public_key="${public_key//\"/}"
    password="${password//\"/}"

    # Create a new user with the specified password
    sudo useradd -m -p "$(openssl passwd -1 "$password")" -s /bin/bash "$username"

    # Add the user to the sudo group
    sudo usermod -aG sudo "$username"

    # Switch to the user's home directory
    user_home_directory="/home/$username"

    cd "$user_home_directory"
    mkdir -p .ssh
    cd .ssh

    # Add the public key to authorized_keys
    echo "$public_key" >> authorized_keys

    chown "$root":"$username" "$user_home_directory/.ssh" -R
    chmod 770 "$user_home_directory/.ssh" -R

    echo "User $username created with SSH key and password."

    # Example: How to log in using the SSH key
    echo "To log in as $username, use the following command:"
    echo "ssh $username@<server-ip> -p <port-number>"
done
 