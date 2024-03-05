# Use the official PostgreSQL 16.1 image as the base image
ARG PG_VERSION=16.1
FROM postgres:${PG_VERSION}-alpine

ARG PGTAP_VERSION=v1.1.0
ENV DOCKERIZE_VERSION=v0.6.1

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.8/main'>> /etc/apk/repositories \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main'>> /etc/apk/repositories \
    && apk add --no-cache --update curl wget git openssl \
      build-base make perl perl-dev \
    && wget -O /tmp/dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz \
    && rm -rf /var/cache/apk/* /tmp/*

# install pg_prove
RUN cpan TAP::Parser::SourceHandler::pgTAP

# install pgtap

RUN git clone https://github.com/theory/pgtap.git \
    && cd pgtap && git checkout tags/$PGTAP_VERSION \
    && make

COPY test /test

RUN chmod +x /test/test.sh

WORKDIR /

ENV DATABASE="postgres" \
    HOST=db \
    PORT=5432 \
    USER="postgres" \
    PASSWORD="example" \
    TESTS="/test/*.sql"

CMD ["/test/test.sh"]