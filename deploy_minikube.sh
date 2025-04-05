#!/bin/bash

MEMORY_MB=$1
CPUS=$2
NAMESPACE="ts"
REPO="host.minikube.internal:5000"
HELM_CHART_PATH="manifests/helm/generic_service"

if [ -z "$MEMORY_MB" ] || [ -z "$CPUS" ]; then
  echo "Usage: $0 <memory_in_mb> <cpus>"
  exit 1
fi

minikube start --insecure-registry="$REPO" --memory="$MEMORY_MB" --cpus="$CPUS"

kubectl label nodes minikube disk=ssd --overwrite

helm install ts "$HELM_CHART_PATH" -n "$NAMESPACE" --create-namespace \
  --set global.monitoring=opentelemetry \
  --set skywalking.enabled=false \
  --set global.image.tag=latest \
  --set global.image.repository="$REPO" \
  --set opentelemetry-collector.mode=deployment

MINIKUBE_IP=$(minikube ip)

nohup caddy reverse-proxy --from :8080 --to "$MINIKUBE_IP:30080" > caddy.log 2>&1 &

