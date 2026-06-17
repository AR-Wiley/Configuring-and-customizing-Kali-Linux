#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
fi


dir="/var/log/install_log"
file="/var/log/install_log/install"
timestamp=$(date +"%Y-%m-%d")

apt="apt-get"
fierce="fierce"
updates=("apt-get update -y" "apt-get upgrade -y" "apt-get dist-upgrade -y" "apt-get clean" "apt-get autoremove -y")

function validate_log_path {

        if [ ! -d "$dir" ]; then
                echo "Creating directory: $dir"
                mkdir -v "$dir"
        fi

}

function validate_log_file {

        if [ ! -e "$file" ]; then
                echo "Creating file: $file"
                touch "$file"
        fi

}

function verify_apt {

        if command -v -s "$apt"; then
                echo "$apt is not installed"
                exit 1
        fi

}

function run_updates {

        for i in "${updates[@]}"; do
                if ! bash -c "$i"; then
                        echo "$timestamp - '$i' Failed" >> "$file"
                        exit 1
                else
                        echo "$timestamp - '$i' Success" >> "$file"
                fi
        done
}

function install_fierce {

        local app=$1

        if command -v "$app" >/dev/null 2>&1; then
                echo "$timestamp -- $app is already installed" >> "$file"
        else
                echo "Installing $app"

                if ! apt install -y "$app"; then
                        echo "$timestamp -- $app failed to install" >> "$file"
                exit 1
                fi

                echo "$timestamp -- $app has been installed" >> "$file"
                "$app" -v
        fi

}


validate_log_path
validate_log_file
verify_apt
run_updates
install_fierce "$fierce"