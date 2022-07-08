#!/bin/bash

export PGUSER=${DB_USER}
export PGPASSWORD=${DB_PASS}
export PGDATABASE=${DB_NAME}
export PGPORT=5432

export DB_SOCKET_DIR=/cloudsql

export PGHOST="${DB_SOCKET_DIR}/${INSTANCE_CONNECTION_NAME}"
export PGPASSWORD=$(gcloud sql generate-login-token)
psql -c 'select * from pg_catalog.pg_tables'
#psql "sslmode=disable host=127.0.0.1 user=${DB_USER}"
