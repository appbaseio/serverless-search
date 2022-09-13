# Serverless Search

## Docker

### Docker Image

For `serverless-search`, the docker image can be found [here at docker hub](https://hub.docker.com/repository/docker/appbaseio/serverless-search).

Following steps can be followed to setup the docker image locally.

1. Zinc

The Docker image requires [Zinc]() to be setup in order for it to work properly. That can be done with the following command:

```shell
mkdir data
docker run -v /full/path/of/data:/data -e ZINC_DATA_PATH="/data" -p 4080:4080 \
    -e ZINC_FIRST_ADMIN_USER=appbase -e ZINC_FIRST_ADMIN_PASSWORD=zincf0rappbase \
    --name zinc public.ecr.aws/zinclabs/zinc:latest
```

2. Update environment

The environment file contains all necessary details (set to default value) except `APPBASE_ID` and `CLUSTER_ID`. These values need to be added in the `config/docker.env` file.

3. Start container

Once the above steps are done, container can be started with the following command:

```shell
docker build -t serverless-search . && docker run --rm --name serverless-search -p 8000:8000 --env-file=config/docker.env serverless-search
```


### Docker Compose

A docker compose is provided for convenience to startup the service locally and try it out.

#### Environments

All values are set to default and will not require changing for serverless-search except the `APPBASE_ID` and `CLUSTER_ID` values. Those values should be updated in the `docker-compose.yml` file before running the compose command.

Once the values are set, the compose can be run with the following command:

```shell
docker-compose up -d
```

**With Nginx**

By default, `nginx` is not added in the docker compose, it can be added by passing the `profile` flag to docker-compose in the following way:

```shell
docker-compose up --profile nginx
```