#!/usr/bin/env bash
set -e

GIT_ID=$(git rev-parse --short HEAD)
GIT_BRANCH=$(git symbolic-ref --short HEAD)
REGISTRY=fi--didelx05.dide.ic.ac.uk:5000
NAME=montagu-db

APP_DOCKER_TAG=$REGISTRY/$NAME
APP_DOCKER_COMMIT_TAG=$REGISTRY/$NAME:$GIT_ID
APP_DOCKER_BRANCH_TAG=$REGISTRY/$NAME:$GIT_BRANCH

docker build --no-cache \
       --tag $APP_DOCKER_COMMIT_TAG \
       --tag $APP_DOCKER_BRANCH_TAG \
       .
docker push $APP_DOCKER_BRANCH_TAG
docker push $APP_DOCKER_COMMIT_TAG