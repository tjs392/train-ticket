#!/bin/bash

kubectl patch svc ts-zipkin -n ts -p '{"spec": {"type": "NodePort"}}'

kubectl apply -f manifests/helm/generic_service/otel-patch.yaml

kubectl rollout restart deployment -n ts ts-opentelemetry-collector

ZIPKIN_PORT=$(kubectl get svc ts-zipkin -n ts -o jsonpath='{.spec.ports[0].nodePort}')
MINIKUBE_IP=$(minikube ip)

echo "Minikube IP: $MINIKUBE_IP"
echo "Zipkin NodePort: $ZIPKIN_PORT"

kubectl get svc ts-zipkin -n ts

echo "Waiting for Zipkin to respond at $MINIKUBE_IP:$ZIPKIN_PORT..."
until curl -sSf "http://$MINIKUBE_IP:$ZIPKIN_PORT" > /dev/null; do
  sleep 2
done

PIDS=$(lsof -t -i:9411)
if [ -n "$PIDS" ]; then
  echo "Killing existing processes on port 9411: $PIDS"
  echo "$PIDS" | xargs kill
fi

nohup caddy reverse-proxy --from :9411 --to "$MINIKUBE_IP:$ZIPKIN_PORT" > caddy-zipkin.log 2>&1 &
echo "Caddy started: http://localhost:9411"

