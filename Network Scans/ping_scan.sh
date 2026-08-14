#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
fi

dir="/var/log/Scans"
timestamp=$(date +"%Y-%m-%d")

subdomain="192.168.1.0"
sub_mask=24

function validate_path {

        if [ ! -d "$dir" ]; then
                echo "Creating directory: $dir"
                mkdir -v "$dir"
        fi
}

function validate_network {

        if ! curl -s --max-time 2 https://google.com >/dev/null 2>&1; then
                echo "Cannot establish network connection"
                exit 1
        fi

}

function ping_scan {

        local subnet=$1
        local mask=$2

        nmap -sP "${subdomain}/${sub_mask}" -oX "${dir}/${timestamp}_scanr.xml"

}

validate_path
validate_network
ping_scan "$subdomain" "$sub_mask"