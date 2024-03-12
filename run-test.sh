docker build -t postgres-pgtap:16.1 -f Dockerfile.test .
docker run -d --rm --name pgtap-tests -v "./db/seed:/docker-entrypoint-initdb.d" -e "POSTGRES_PASSWORD=example" -e "POSTGRES_USER=postgres"\
  -e "DATABASE=postgres"  -e "HOST=localhost"  -e "TESTS=/test/*.sql"  -e "PORT=5432" postgres-pgtap:16.1
docker exec pgtap-tests /test/test.sh
docker stop pgtap-tests
