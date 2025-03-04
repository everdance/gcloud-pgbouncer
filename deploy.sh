#!/usr/bin/env bash

PGBOUNCER_VER=1.24.0
PGB_CFG_HASH=$(find ./config -type f | sort | xargs cat | md5sum | awk '{print $1}' | tail -c 10)
PGB_BUILD_VER="${PGBOUNCER_VER}-${PGB_CFG_HASH}"
PGB_IMAGE_TAG="gcr.io/{GCLOUD_PROJECT_ID}/pgbouncer:${PGB_BUILD_VER}"
if [ -z "$(gcloud container images describe ${PGB_IMAGE_TAG} 2> /dev/null)" ]; then                    
    docker build \
           --build-arg "VERSION=${PGBOUNCER_VER}" \
           --tag "${PGB_IMAGE_TAG}" .
fi     

# AUTHENTICATE
# gcloud auth activate-service-account xxxx --key-file gcloud.json

docker push ${PGB_IMAGE_TAG}

gcloud config set project ${GCLOUD_PROJECT_ID}
# SET CLUSTER
# gcloud config set compute/zone xxx
# gcloud config set container/cluster xxx


mv "service.yaml" "service.yaml.tmp"
envsubst < "service.yaml.tmp" > "service.yaml"
kubectl apply -f "service.yaml"

mv "deployment.yaml" "deployment.yaml.tmp"
envsubst < "deployment.yaml.tmp" > "deployment.yaml"
kubectl apply -f "deployment.yaml"

