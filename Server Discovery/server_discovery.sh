#!/bin/bash

set -euo pipefail

targets=('https://httpbin.org'
        'https://reqres.in'
        'https://jsonplaceholder.typicode.com'
        'https://postman-echo.com'
        'https://api.github.com'
        'https://api.open-meteo.com'
        'https://restcountries.com')

declare -A servers

file="/home/wiley/test.txt"

function validate_network {

        if ! curl -s --max-time 2 https://google.com >/dev/null 2>&1; then
                echo "Cannot establish network connection"
                exit 1
        fi
}

function identify_server {

        > "$file"

        for i in "${targets[@]}"; do

                curl -sI "${i}" | grep -i "server" | awk -F: '{print $2, $NF}' | xargs >> "$file"
        done
}


validate_network
identify_server
