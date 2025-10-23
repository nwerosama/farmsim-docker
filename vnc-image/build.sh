#!/bin/bash

REGISTRY_URL=ghcr.io/nwerosama/farmsim-docker-vnc
REGISTRY_TAG=latest
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Building on $GIT_BRANCH branch..."
docker build -t $REGISTRY_URL:$REGISTRY_TAG .

if [ "$GIT_BRANCH" != "sandbox" ]; then
  docker push $REGISTRY_URL:$REGISTRY_TAG
fi
