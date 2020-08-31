#!/usr/bin/env bash

# Variables
ACME_EMAIL=${ACME_EMAIL:-''}
CONFIG_DIR=${CONFIG_DIR:-'/data'}
DATA_DIR=${DATA_DIR:-'/data'}
DOMAIN=${DOMAIN:-''}

# Functions

## Build the configuration file for docker-compose
build_docker_compose_config()
{
  echo "Completing docker-compose template..."
  envsubst '${DOMAIN}' < "${CONFIG_DIR}/docker-compose.yaml.tmpl" > ${DATA_DIR}/docker-compose.yaml
}

## Build the configuration file for traefik
build_traefik_config()
{
  echo "Completing traefik configuration template..."
  envsubst '${ACME_EMAIL}' < "${CONFIG_DIR}/traefik.toml.tmpl" > ${DATA_DIR}/traefik/traefik.toml

  echo "Deploying traefik dynamic configuration file..."
  cp ${CONFIG_DIR}/force-https.toml ${DATA_DIR}/traefik/dynamic/force-https.toml

  echo "Creating empty acme.json for ACME config..."
  touch ${DATA_DIR}/traefik/acme.json
  chmod 600 ${DATA_DIR}/traefik/acme.json
}

## Create directories for the containers
create_data_dirs()
{
  mkdir -p ${DATA_DIR}/crawl
  mkdir -p ${DATA_DIR}/traefik
  mkdir -p ${DATA_DIR}/traefik/dynamic
}

## Run the docker-compose file
run_docker_compose()
{
  docker-compose -f ${DATA_DIR}/docker-compose.yaml up --detach
}

## Display usage information
usage()
{
  echo "[Environment Variables] deploy.sh [options]"
  echo "  Environment Variables:"
  echo "    ACME_EMAIL                  email for Let's Encrypt"
  echo "    CONFIG_DIR                  directory containing configuration templates and files"
  echo "    DATA_DIR                    directory containing data files for containers"
  echo "    DOMAIN                      domain to attach to for Let's Encrypt and Traefik"
  echo "  Options:"
  echo "    -h | --help                 display this usage information"
}

# Logic

## Argument parsing
case $1 in
  -h | --help ) usage
                exit 0
esac

create_data_dirs
build_traefik_config
build_docker_compose_config
run_docker_compose