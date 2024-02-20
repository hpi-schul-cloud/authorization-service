# Description

The authorization-service is a microservice to authorize permissions for the column board and the file-storage. (Other parts will follow).

Internally there is a postgres db which stores, roles, user groups and entities.
They are linked the service returns a list of permissions for a given user groups and entity.

Roles are pre defined.
User groups and entities are required to be set up or managed via an api.

## Installation (Local development)

Install [docker compose](https://docs.docker.com/compose/install/)

```bash
$ npm install
```

## Start the Database

```bash
$ docker-compose up -f ./docker-compose.local.yml
```


## Running the app

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Test

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://kamilmysliwiec.com)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](LICENSE).
