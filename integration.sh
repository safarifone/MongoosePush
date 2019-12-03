#!/bin/bash

docker network create n

docker run -p 4000:4000 -p 4001:4001 --name fcm --network n mongooseim/fcm-mock-server

docker run -v `pwd`/priv:/opt/app/priv \
    -e PUSH_FCM_ENABLED=true \
    -e PUSH_FCM_PORT=4000 \
    -e PUSH_FCM_ENDPOINT="fcm" \
    -e PUSH_APNS_ENABLED=false \
    -e TLS_SERVER_CERT_VALIDATION=false \
    -e FCM_AUTH_ENDPOINT="http://fcm:4001" \
    --network n \
    -p 8443:8443 \
    $DOCKERHUB_REPOSITORY/$DOCKER_IMAGE:$DOCKER_TAG
