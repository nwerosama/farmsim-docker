#!/bin/bash

REGISTRY_URL=ghcr.io/nwerosama/farmsim-docker
REGISTRY_TAG=sandbox

docker build -t $REGISTRY_URL:$REGISTRY_TAG .

if [ "$REGISTRY_TAG" = "fs25" ]; then
  docker push $REGISTRY_URL:$REGISTRY_TAG
fi
