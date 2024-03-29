FROM golang:1.18.6 as builder

# Default value
# Run `--build-arg BILLING=true` to enable billing
ARG BILLING=false
ENV BILLING="${BILLING}"

# Run `--build-arg HOSTED_BILLING=true` to enable billing for hosted reactivesearch
ARG HOSTED_BILLING=false
ENV HOSTED_BILLING="${HOSTED_BILLING}"

# Run `--build-arg CLUSTER_BILLING=true` to enable billing for clusters
ARG CLUSTER_BILLING=false
ENV CLUSTER_BILLING="${CLUSTER_BILLING}"

# Run `--build-arg OPENSOURCE=true` to build opensource 
ARG OPENSOURCE=true
ENV OPENSOURCE="${OPENSOURCE}"

# Run `--build-arg IGNORE_BILLING_MIDDLEWARE=true` to disable billing middleware for testing
ARG IGNORE_BILLING_MIDDLEWARE=false
ENV IGNORE_BILLING_MIDDLEWARE="${IGNORE_BILLING_MIDDLEWARE}"

# Run `--build-arg PLAN_REFRESH_INTERVAL=X` to change the default interval of 1 hour, where 'X' is an integer represent the hours unit
ARG PLAN_REFRESH_INTERVAL=1
ENV PLAN_REFRESH_INTERVAL="${PLAN_REFRESH_INTERVAL}"

# Install tools required for project
# Run `docker build --no-cache .` to update dependencies
RUN apt-get clean && apt-get update
RUN apt-get -y install build-essential git
WORKDIR /serverless-search

# List project dependencies with go.mod and go.sum
COPY go.mod go.sum ./

# Set the config to be able to access private repo
RUN git config --global url."https://<--token-->:x-oauth-basic@github.com/".insteadOf "https://github.com/"

# Install library dependencies
RUN go mod download

# Remove the config since it contains sensitive information
RUN rm ~/.gitconfig

# Copy the entire project and build it
# This layer is rebuilt when a file changes in the project directory
COPY . .
RUN make clean && make

# Final stage: Create the running container
FROM debian:bullseye AS final

# Create env folder
RUN mkdir /serverless-search-data && touch /serverless-search-data/.env && chmod 777 /serverless-search-data/.env

# Import the compiled executable from the first stage.
COPY --from=builder /serverless-search /serverless-search
WORKDIR /serverless-search

EXPOSE 8000
ENTRYPOINT ["build/serverless-search", "--log", "stdout", "--plugins"]
