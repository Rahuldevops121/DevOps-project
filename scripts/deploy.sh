#!/bin/bash
set -euo pipefail

NAMESPACE="devops-platform"
DEPLOYMENT="devops-platform-app"
IMAGE="${DOCKERHUB_USERNAME}/devops-platform-app:${IMAGE_TAG}"

echo "🚀 Deploying image: $IMAGE"

# Apply namespace first and wait for it to be active
kubectl apply -f k8s/namespace.yaml
kubectl wait --for=jsonpath='{.status.phase}'=Active \
  namespace/${NAMESPACE} --timeout=30s

# Apply remaining manifests
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml

# Update image tag
kubectl set image deployment/${DEPLOYMENT} \
  app=${IMAGE} \
  -n ${NAMESPACE}

# Show current pods
kubectl get pods -n ${NAMESPACE}

echo "✅ Deploy triggered for $IMAGE"
