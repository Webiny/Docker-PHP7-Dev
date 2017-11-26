#!/usr/bin/env bash
set -ex

# Docker Hub
USERNAME=webiny
IMAGE=php7-dev

# Increment Version
docker run --rm -v "$PWD":/app treeder/bump patch
version=`cat VERSION`
echo "version: $version-dev"

# Tag/push - GIT
git add -A
git commit -m "v$version-dev"
git tag -a "v$version-dev" -m "v$version-dev"
git push
git push --tags

# Docker - Tagging
docker tag $USERNAME/$IMAGE:$version-dev

# Push - Docker Hub
docker push $USERNAME/$IMAGE:$version-dev