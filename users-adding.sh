#!/bin/bash

# Define an array with user information
users=(
    "lakshan_sl \"ssh_key1\" \"password1\""
    # Add more users as needed
)

# Iterate through the array and create users with SSH keys and passwords
for user_info in "${users[@]}"; do
    # Split the user information into username, public key, and password
    read -r username public_key password <<< "$user_info"

    # Remove the double quotes around the public key and password
    public_key="${public_key//\"/}"
    password="${password//\"/}"

    # Create a new user with the specified password
    sudo useradd -m -p "$(openssl passwd -1 "$password")" "$username"

    # Add the user to the sudo group
    sudo usermod -aG sudo "$username"

    # Switch to the user's home directory
    user_home_directory="/home/$username"

    # Create the .ssh directory and authorized_keys file
    sudo -u $username mkdir -p "$user_home_directory/.ssh"
    sudo -u $username touch "$user_home_directory/.ssh/authorized_keys"

    # Add the public key to authorized_keys
    echo "$public_key" | sudo -u $username tee -a "$user_home_directory/.ssh/authorized_keys" > /dev/null

    # Set proper permissions
    sudo -u $username chmod 700 "$user_home_directory"
    sudo -u $username chmod 700 "$user_home_directory/.ssh"
    sudo -u $username chmod 600 "$user_home_directory/.ssh/authorized_keys"

    echo "User $username created with SSH key and password."

    # Example: How to log in using the SSH key
    echo "To log in as $username, use the following command:"
    echo "ssh $username@<server-ip> -p <port-number>"
done
