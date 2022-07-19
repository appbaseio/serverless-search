# Serverless Search

## Docker

### Docker Image

For `serverless-search`, the docker image can be found [here at docker hub](https://hub.docker.com/repository/docker/appbaseio/serverless-search)

### Docker Compose

A docker compose is provided for convenience to startup the service locally and try it out.

> TODO: Add instructions to start docker compose after testing it properly

**With Nginx**

By default, `nginx` is not added in the docker compose, it can be added by passing the `profile` flag to docker-compose in the following way:

```shell
docker-compose up --profile nginx
```