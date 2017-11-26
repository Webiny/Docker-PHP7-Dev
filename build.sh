#!/usr/bin/env bash
set -ex
USERNAME=webiny
# image name
IMAGE=php7-dev
docker build -t $USERNAME/$IMAGE:latest .