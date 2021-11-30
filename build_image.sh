#!/usr/bin/env bash

branch=$(git branch --show-current)

echo -e "Building base ros image for $branch\n WARNING: this script must be run from the root of the repo not from within the .docker folder"

docker build --pull --rm -f ./Dockerfile  -t gdwyer/ros:$branch .
