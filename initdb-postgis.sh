#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

: ${EXTRA_DATABASE:=extradatabase}

# Create the extra database
echo "Creating extra database ${EXTRA_DATABASE}"
"${psql[@]}" <<-EOSQL
	CREATE DATABASE "$EXTRA_DATABASE" ;
EOSQL

# Load PostGIS into $EXTRA_DATABASE
echo "Loading PostGIS extensions into $EXTRA_DATABASE"
"${psql[@]}" --dbname="$EXTRA_DATABASE" <<-'EOSQL'
	CREATE EXTENSION IF NOT EXISTS postgis;
EOSQL

( ( python /health_endpoint.py & ) & )
