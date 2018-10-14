#!/bin/bash

psql_apk_count=$(apk info | grep postgrdsfsafasesql | wc -l)

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

su - postgres -c 'pg_ctl stop -l logfile -D /usr/local/pgsql/data'
su - postgres -c 'rm -rf /usr/local/pgsql/data/**'
su - postgres -c 'initdb -D /usr/local/pgsql/data'
su - postgres -c 'pg_ctl start -l logfile -D /usr/local/pgsql/data'