#!/bin/bash

set -e

echo "Creating monitoring namespace..."
kubectl apply -f k8s/monitoring-namespace.yaml

echo "Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
helm repo add fluent https://fluent.github.io/helm-charts

helm repo update

echo "Installing Prometheus Stack..."
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --create-namespace \
  -f monitoring/prometheus/values.yaml

echo "Applying ServiceMonitor..."
kubectl apply -f monitoring/prometheus/servicemonitor.yaml

echo "Installing Elasticsearch..."
helm upgrade --install elasticsearch elastic/elasticsearch \
  -n monitoring \
  -f monitoring/elasticsearch/values.yaml

echo "Installing Kibana..."
helm upgrade --install kibana elastic/kibana \
  -n monitoring \
  -f monitoring/kibana/values.yaml

echo "Installing Fluent Bit..."
helm upgrade --install fluent-bit fluent/fluent-bit \
  -n monitoring \
  -f monitoring/fluent-bit/values.yaml

echo "Monitoring stack deployment complete."

# Install Jaeger
echo "Installing Jaeger..."
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
helm upgrade --install jaeger jaegertracing/jaeger \
  -n monitoring \
  -f jaeger/values.yaml
echo "✅ Jaeger installed"

# Fix Elasticsearch replica settings after startup
echo "Waiting for Elasticsearch to be ready..."
sleep 90
ES_PASSWORD=$(kubectl get secret elasticsearch-master-credentials \
  -n monitoring -o jsonpath='{.data.password}' | base64 -d)

# Set replicas to 0 on all existing indices
kubectl exec -it elasticsearch-master-0 -n monitoring -- \
  bash -c "curl -sk -u elastic:$ES_PASSWORD \
  -X PUT 'https://localhost:9200/*/_settings' \
  -H 'Content-Type: application/json' \
  -d '{\"index\":{\"number_of_replicas\":\"0\"}}'"

# Create index template so new indices also get 0 replicas
kubectl exec -it elasticsearch-master-0 -n monitoring -- \
  bash -c "curl -sk -u elastic:$ES_PASSWORD \
  -X PUT 'https://localhost:9200/_index_template/fluent-bit-template' \
  -H 'Content-Type: application/json' \
  -d '{\"index_patterns\":[\"fluent-bit-*\"],\"template\":{\"settings\":{\"number_of_replicas\":0}}}'"

echo "✅ Elasticsearch replica settings applied"
