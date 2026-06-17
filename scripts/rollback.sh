#!/bin/bash
set -euo pipefail

NAMESPACE="devops-platform"
DEPLOYMENT="devops-platform-app"
REVISION=${1:-0}

# Show rollout history
echo "📋 Rollout history:"
kubectl rollout history deployment/${DEPLOYMENT} -n ${NAMESPACE}

if [ "$REVISION" -eq 0 ]; then
  echo "⏪ Rolling back to previous revision..."
  kubectl rollout undo deployment/${DEPLOYMENT} -n ${NAMESPACE}
else
  echo "⏪ Rolling back to revision $REVISION..."
  kubectl rollout undo deployment/${DEPLOYMENT} \
    -n ${NAMESPACE} --to-revision=${REVISION}
fi

kubectl rollout status deployment/${DEPLOYMENT} -n ${NAMESPACE} --timeout=120s

echo "🔍 Current pods after rollback:"
kubectl get pods -n ${NAMESPACE}

echo "✅ Rollback complete"
