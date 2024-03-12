# Use the official PostgreSQL 16.1 image as the base image
ARG PG_VERSION=16.1
FROM postgres:${PG_VERSION}-alpine

ARG PGTAP_VERSION=v1.3.2
ENV DOCKERIZE_VERSION=v0.6.1

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.8/main'>> /etc/apk/repositories \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main'>> /etc/apk/repositories \
    && apk add --no-cache --update curl wget git openssl build-base make perl perl-dev \
    && rm -rf /var/cache/apk/* /tmp/* \
    && cpan TAP::Parser::SourceHandler::pgTAP \
    && git clone https://github.com/theory/pgtap.git \
    && cd pgtap && git checkout tags/$PGTAP_VERSION \
    && make

WORKDIR /

COPY test/unit/*.sql /test/

CMD ["postgres"]

