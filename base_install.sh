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
updates=("apt-get update -y" "apt-get upgrade -y" "apt-get dist-upgrade -y" "apt-get clean" "apt-get autoremove -y")
installs=("man-db" "file")

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


function application_install {

        for i in "${installs[@]}"; do
                if command -v "$i" > /dev/null 2>&1; then
                        echo "$timestamp - $i is already installed" >> "$file"
                else
                        echo "$timestamp - Installing $i" >> "$file"

                        if ! apt install "$i"; then
                        echo "$timestamp - $i failed to install" >> "$file"
                        exit 1
                        fi

                echo "$timestamp - $i has been installed" >> "$file"
                fi
        done
}



function post_verification {

        for i in "${installs[@]}"; do
                if dpkg -s "$i" >/dev/null 2>&1; then
                        echo "$timestamp - Verified: $i is installed" >> "$file"
                else
                        echo "$timestamp - Error: $i was installed but dpkg cannot verify" >> "$file"
                        exit 1
                fi
        done
}


validate_log_path
validate_log_file
verify_apt
run_updates
application_install
post_verification
