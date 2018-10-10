#!/bin/bash

docker run --rm --name tascal-psql -e POSTGRES_PASSWORD=mysecretpassword -d postgres:10

for i in `seq 1 5`; do
  echo "Wait for 5 seconds..."
  sleep 5

  docker exec tascal-psql psql -U postgres -c 'select 1;' 2>&1 > /dev/null

  if [[ $? -eq 0 ]]; then
    echo "Connection established."
    docker exec tascal-psql psql -U postgres -c "CREATE ROLE tascal_tester WITH LOGIN PASSWORD 'few32h32jew90';"
    docker exec tascal-psql psql -U postgres -c "ALTER ROLE tascal_tester CREATEDB"

    if [[ $? -ne 0 ]]; then
        exit 1
    fi

    exit 0
  fi
done

echo "Failed to connect to database."
exit 1