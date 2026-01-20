#!/bin/bash

REGISTRY_URL=ghcr.io/nwerosama/farmsim-docker
REGISTRY_TAG=$(git rev-parse --abbrev-ref HEAD)

echo "Building on $REGISTRY_TAG branch..."
docker build -t $REGISTRY_URL:$REGISTRY_TAG .

if [ "$REGISTRY_TAG" = "novnc" ]; then
  docker push $REGISTRY_URL:$REGISTRY_TAG
fi
