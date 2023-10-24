#!/bin/bash

# Define an array with user information
users=(
    "lakshan_sl \"<add-key>\""
    # Add more users as needed
)

# Iterate through the array and create users with SSH keys
for user_info in "${users[@]}"; do
    # Split the user information into username and public key
    read -r username public_key <<< "$user_info"

    # Remove the double quotes around the public key
    public_key="${public_key//\"/}"

    # Create a new user
    sudo adduser "$username"

    # Add the user to the sudo group
    sudo usermod -aG sudo "$username"

    # Switch to the user's home directory
    user_home_directory="/home/$username"
    cd "$user_home_directory"

    # Create the .ssh directory
    mkdir -p .ssh

    # Change to the .ssh directory
    cd .ssh

    # Add the public key to authorized_keys
    echo "$public_key" >> authorized_keys

    # Set proper permissions
    chmod 700 "$user_home_directory"
    chmod 700 .ssh
    chmod 600 authorized_keys

    echo "User $username created with SSH key."

    # Example: How to log in using the SSH key
    echo "To log in as $username, use the following command:"
    echo "ssh $username@<server-ip> -p <port-number>"
done
