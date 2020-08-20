#!/usr/bin/env bash

# Variables
ACME_EMAIL=${ACME_EMAIL:-''}
CONFIG_DIR=${CONFIG_DIR:-'/data'}
DATA_DIR=${DATA_DIR:-'/data'}
DOMAIN=${DOMAIN:-''}
TRAEFIK_ADMIN_HTPASSWORD=${TRAEFIK_ADMIN_HTPASSWORD:-''}
TRAEFIK_ADMIN_USERNAME=${TRAEFIK_ADMIN_USERNAME:-'admin'}

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
  echo "Completing traefik template..."
  envsubst '${ACME_EMAIL},${DOMAIN},${TRAEFIK_ADMIN_USERNAME},${TRAEFIK_ADMIN_HTPASSWORD}' < "${CONFIG_DIR}/traefik.toml.tmpl" > ${DATA_DIR}/traefik/traefik.toml

  echo "Creating empty acme.json for ACME config..."
  touch ${DATA_DIR}/traefik/acme.json
  chmod 600 ${DATA_DIR}/traefik/acme.json
}

## Create directories for the containers
create_data_dirs()
{
  mkdir -p ${DATA_DIR}/crawl
  mkdir -p ${DATA_DIR}/traefik
}

## Run the docker-compose file
run_docker_compose()
{
  cd ${CONFIG_DIR}
  docker-compose -d up
}

## Display usage information
usage()
{
  echo "[Environment Variables] deploy.sh [options]"
  echo "  Environment Variables:"
  echo "    ACME_EMAIL                  email for Let's Encrypt"
  echo "    DATA_DIR                    directory containing data files for containers"
  echo "    DOMAIN                      domain to attach to for Let's Encrypt and Traefik"
  echo "    TRAEFIK_ADMIN_USERNAME      traefik admin user (default: 'admin')"
  echo "    TRAEFIK_ADMIN_HTPASSWORD    traefik admin password, ht-password encrypted"
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