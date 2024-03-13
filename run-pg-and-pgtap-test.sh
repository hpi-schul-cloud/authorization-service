#!/bin/bash

# Before PostgreSQL can function correctly, the database cluster must be initialized:
initdb -D /var/lib/postgresql/data

# internal start of server in order to allow set-up using psql-client
pg_ctl -D "/var/lib/postgresql/data" -o "-c listen_addresses='127.0.0.1'" -w start

# Seed the data
for file in /seed/*.sql; do
    echo "Seeding data from $file"
    psql -f $file
done

echo "Data seeding complete"

./test/test.sh

# stop internal postgres server
pg_ctl -D "/var/lib/postgresql/data" -m fast -w stop

exec "$@"
