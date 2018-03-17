#!/bin/bash

# Variables
USERNAME="allanselvan"
IMAGE="openldap"
TAGNAME="$USERNAME/$IMAGE"
VERSION=`cat VERSION`

echo "Building new image with tag: $TAGNAME"
docker build -t $TAGNAME:latest .