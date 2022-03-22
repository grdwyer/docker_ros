#!/usr/bin/env bash

branch=$(git branch --show-current)

echo -e "Pushing base ros image for $branch"

docker push gdwyer/ros:$branch 
