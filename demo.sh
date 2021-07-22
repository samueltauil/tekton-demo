#!/bin/sh

oc apply -f echo-hello-world.yaml

tkn task start --showlog hello

oc create -f apply_manifest_task.yaml

oc create -f update_deployment_task.yaml

oc create -f pvc.yaml

oc create -f pipeline.yaml

## Backend - https://github.com/openshift-pipelines/vote-api.git
tkn pipeline start build-and-deploy -w name=shared-workspace,claimName=source-pvc -p deployment-name=vote-api -p git-url=https://github.com/openshift-pipelines/vote-api.git -p IMAGE=image-registry.openshift-image-registry.svc:5000/`oc project -q`/vote-api --showlog

## Frontend - https://github.com/openshift-pipelines/vote-ui.git
tkn pipeline start build-and-deploy -w name=shared-workspace,claimName=source-pvc -p deployment-name=vote-ui -p git-url=https://github.com/openshift-pipelines/vote-ui.git -p IMAGE=image-registry.openshift-image-registry.svc:5000/`oc project -q`/vote-ui --showlog
