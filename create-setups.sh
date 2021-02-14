#!/bin/bash
set -e

function process_user() {
    if [ -n "$1" ]; then
        echo "Creating user '$1' with password '$2' and giving database access to '$3'..."
        echo "CREATE USER $1 WITH PASSWORD '$2'; \
            CREATE DATABASE $3; \
            GRANT ALL PRIVILEGES ON DATABASE $3 TO $1;" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
    fi
}

function parse_setup() {
    IFS=',' read -ra setups <<< "$1"
    for setup in "${setups[@]}"
    do
        IFS=':' read -ra setup_data <<< "$setup"
        
        local name="${setup_data[0]}"
        local pw=$name
        local db=$name
        
        if [ "${#setup_data[@]}" -gt "1" ]; then
            local pw="${setup_data[1]}"
        
            if [ "${#setup_data[@]}" -gt "2" ]; then
                local db="${setup_data[2]}"
            fi
        fi
        
        process_user $name $pw $db
    done
}

parse_setup $POSTGRES_SETUPS