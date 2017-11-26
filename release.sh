#!/usr/bin/env bash
set -ex

# Docker Hub
USERNAME=webiny
IMAGE=php7

# Increment Version
docker run --rm -v "$PWD":/app treeder/bump patch
version=`cat VERSION`-dev
echo "version: $version"

# Tag/push - GIT
git add -A
git commit -m "v$version"
git tag -a "v$version" -m "v$version"
git push
git push --tags

# Docker Pushing Tags
docker tag $USERNAME/$IMAGE:$version

# Push - Docker Hub
docker push $USERNAME/$IMAGE:$version