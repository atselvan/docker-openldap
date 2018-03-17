#!/bin/bash

# Variables
USERNAME="allanselvan"
NAME="openldap"
VERSION=`cat VERSION`
IMAGE="$USERNAME/$NAME:latest"
VOLUME="/Users/allanselvan/data/openldap-docker:/data/openldap"
NETWORK="isolated_nw"
LDAP_HOST="*"
LDAP_PORT="10389"
LDAP_BASE_DN="dc=privatesquare,dc=in"
LDAP_PASSWORD="welkom"
PORT="$LDAP_PORT:10389"

RUNNING=`docker ps | grep -c $NAME`
if [ $RUNNING -gt 0 ]
then
   echo "Stopping $NAME instance"
   docker stop $NAME
fi

EXISTING=`docker ps -a | grep -c $NAME`
if [ $EXISTING -gt 0 ]
then
   echo "Removing $NAME container"
   docker rm $NAME
fi

echo "Running a new instance with name $NAME"
echo "[INFO] IMAGE   : $IMAGE"
echo "[INFO] NAME    : $NAME"
echo "[INFO] VOLUME  : $VOLUME"
echo "[INFO] NETWORK : $NETWORK"
echo "[INFO] PORT    : $PORT"

docker run --name $NAME -d -p $PORT \
-e LDAP_HOST=$LDAP_HOST \
-e LDAP_PORT=$LDAP_PORT \
-e LDAP_BASE_DN=$LDAP_BASE_DN \
-e LDAP_PASSWORD=$LDAP_PASSWORD \
-v $VOLUME --network=$NETWORK $IMAGE