#!/bin/bash

nohup postgres &

function usage() { echo "Usage: $0 -h host -d database -p port -u username -w password -t 'tests/*.sql'" 1>&2; exit 1; }

while getopts d:h:p:u:w:b:n:t: OPTION
do
  case $OPTION in
    d)
      DATABASE=$OPTARG
      ;;
    h)
      HOST=$OPTARG
      ;;
    p)
      PORT=$OPTARG
      ;;
    u)
      USER=$OPTARG
      ;;
    w)
      PASSWORD=$OPTARG
      ;;
    t)
      TESTS=$OPTARG
      ;;
    H)
      usage
      ;;
  esac
done

TIMEOUT=60
INTERVAL=1
echo "Checking if PostgreSQL is ready..."
until pg_isready -h $HOST -p $PORT -d $DATABASE -U $USER
do
  TIMEOUT=$((TIMEOUT - INTERVAL))
  if [ $TIMEOUT -eq 0 ]; then
    echo "Timed out waiting for PostgreSQL to be ready"
    exit 1
  fi
  echo "Waiting for database..."
  sleep 1
done
echo "Postresql is ready"


echo "Running tests: $TESTS"
# Install pgtap
PGPASSWORD=$PASSWORD psql -q -h $HOST -p $PORT -d $DATABASE -U $USER -f /pgtap/sql/pgtap.sql

# Check if pgtap installed successfully
if [ $? -ne 0 ]; then
  echo "pgTap was not installed properly. Unable to run tests!"
  exit 1
else
  echo "pgTap was installed successfully."
fi

# Run the tests
PGPASSWORD=$PASSWORD pg_prove -h $HOST -p $PORT -d $DATABASE -U $USER $TESTS
rc=$?

# Uninstall pgtap
PGPASSWORD=$PASSWORD psql -q -h $HOST -p $PORT -d $DATABASE -U $USER -f /pgtap/sql/uninstall_pgtap.sql > /dev/null 2>&1

# Exit with return code of the tests
exit $rc
