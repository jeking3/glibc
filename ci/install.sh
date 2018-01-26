#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_TAG=$DOCKER_USER/$DOCKER_REPO:$CONTAINER

function dockerfile_changed {
  # image may not exist yet, so we have to let it fail silently:
  docker pull "$DOCKER_TAG" || true
  docker run "$DOCKER_TAG" bash -c "cd / && sha512sum Dockerfile" > .Dockerfile.sha512
  sha512sum -c .Dockerfile.sha512
}

pushd "$SCRIPT_DIR/$CONTAINER"
if dockerfile_changed; then
  echo Dockerfile has not changed.  No need to rebuild.
  exit 0
else
  echo Dockerfile has changed.
fi
popd

echo Rebuilding docker image "$CONTAINER"
docker build --build-arg "COVERITY_SCAN_TOKEN=$COVERITY_SCAN_TOKEN" --tag "$DOCKER_TAG" "$SCRIPT_DIR/$CONTAINER"

if [[ ! -z "$DOCKER_USER" ]] && [[ ! -z "$DOCKER_PASS" ]]; then 
  echo Pushing docker image "$DOCKER_TAG"
  docker login -u "$DOCKER_USER" -p "$DOCKER_PASS"
  docker push "$DOCKER_TAG"
else
  echo Not pushing docker image: one of DOCKER_USER or DOCKER_PASS is undefined.
fi

