#!/usr/bin/env bash

# Variables
DATA_DIR=${DATA_DIR:-'/data'}
IMAGE=${IMAGE:-'frozenfoxx/crawl:latest'}
RESTART=${RESTART:-'always'}

# Functions

## Install the container
install_container()
{
  echo "Setting up container..."
  docker pull ${IMAGE}
}

## Run the container
run_container()
{
  echo "Running the container..."
  docker run -it \
    -d \
    --restart=${RESTART} \
    -p 8080:8080 \
    -v ${DATA_DIR}/:/data \
    --name='crawl_webtiles' \
    ${IMAGE}
}

## Stop the container
stop_container()
{
  echo "Stopping the container..."
  docker kill crawl-server
  echo y | docker container prune
}

## Display usage information
usage()
{
  echo "Usage: [Environment Variables] crawl_server.sh [arguments] [command]"
  echo "  Arguments:"
  echo "    -h                     display usage information"
  echo "  Commands:"
  echo "    install                set up and install the server"
  echo "    restart                restart the server"
  echo "    start                  start the server"
  echo "    stop                   stop the server"
  echo "  Environment Variables:"
  echo "    IMAGE                  the image to pull (default: 'frozenfoxx/crawl:latest')"
  echo "    RESTART                the restart policy for the container (default: 'always')"
}

# Logic

## Argument parsing
while [[ "$1" != "" ]]; do
  case $1 in
    install )     install_container
                  run_container
                  ;;
    restart )     stop_container
	                install_container
                  run_container
                  ;;
    start )       install_container
                  run_container
                  ;;
    stop )        stop_container
                  ;;
    -h | --help ) usage
                  exit 0
                  ;;
    * )           usage
                  exit 1
  esac
  shift
done
