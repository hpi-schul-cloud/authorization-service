#!/bin/sh

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

echo "Waiting for database..."
dockerize -timeout 240s -wait tcp://$HOST:$PORT
echo

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
