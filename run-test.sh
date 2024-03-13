docker build -t postgres-pgtap:16.1 -f Dockerfile.test .
docker run --rm --name pgtap-tests -v "./db/seed:/docker-entrypoint-initdb.d" -v "./test/test.sh:/test/test.sh"\
-e "PASSWORD=example" -e "USER=postgres" -e "PORT=5432" -e "TESTS=/test/*.sql" -e "HOST=localhost"\
-e DATABASE="postgres" postgres-pgtap:16.1
