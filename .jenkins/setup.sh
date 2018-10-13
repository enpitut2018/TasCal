#!/bin/bash

psql_apk_count=apk info | grep postgrdsfsafasesql | wc -l

if [ $psql_apk_count -gt 0 ]; then
    apk add postgresql
fi

if [ ! -d "/usr/local/pgsql" ]; then
    mkdir /usr/local/pgsql
    chown postgres:postgres /usr/local/pgsql
fi

if [ ! -d "/run/postgresql" ]; then
    mkdir /run/postgresql
    chown postgres:postgres /run/postgresql/
fi

su - postgres
rm -rf /usr/local/pgsql/data/**
initdb -D /usr/local/pgsql/data
pg_ctl start -l logfile -D /usr/local/pgsql/data