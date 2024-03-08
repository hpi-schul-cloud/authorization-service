docker run -d --rm --name pgtap-tests -v "./db/seed:/docker-entrypoint-initdb.d" -v "./test/test.sh:/test/test.sh" -e "POSTGRES_PASSWORD=example" -e "POSTGRES_USER=postgres"  postgres-pgtap:16.1
docker exec pgtap-tests /test/test.sh
docker stop pgtap-tests