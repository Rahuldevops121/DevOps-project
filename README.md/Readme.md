Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions CI/CD
    │
    ▼
Docker Build + Trivy Scan
    │
    ▼
Docker Registry
    │
    ▼
Kubernetes Cluster
    │
 ┌──┴─────────────┐
 ▼                ▼
Application   Monitoring Stack
                  │
     ┌────────────┼─────────────┐
     ▼            ▼             ▼
 Prometheus    Grafana     AlertManager
     │
     ▼
 Fluent Bit
     │
     ▼
 Elasticsearch
     │
     ▼
 Kibana

# Kubernetes Deployment

### Kubernetes Resources

The application is deployed on Kubernetes using declarative manifests.

#### Namespace

```bash
kubectl apply -f k8s/namespace.yaml
```

#### ConfigMap

```bash
kubectl apply -f k8s/configmap.yaml
```

#### Secrets

```bash
kubectl apply -f k8s/secrets.yaml
```

#### Deployment

```bash
kubectl apply -f k8s/deployment.yaml
```

#### Service

```bash
kubectl apply -f k8s/service.yaml
```

#### Ingress

```bash
kubectl apply -f k8s/ingress.yaml
```

#### Horizontal Pod Autoscaler

```bash
kubectl apply -f k8s/hpa.yaml
```
#### Network-Policy

```bash
kubectl apply -f k8s/network-policy.yaml

### Features

* Namespace Isolation
* ConfigMap Configuration Management
* Kubernetes Secrets
* Rolling Updates
* Health Checks
* Readiness Probes
* Horizontal Pod Autoscaling
* Ingress-Based Routing

---

# Infrastructure as Code

Infrastructure provisioning is managed using Terraform.

### Components

* AWS EC2
* VPC
* Security Groups
* Networking Resources

### Terraform Commands

```bash
cd terraform

terraform init

terraform validate

terraform plan

terraform apply
```

### Features

* Infrastructure as Code (IaC)
* Version Controlled Infrastructure
* Repeatable Deployments
* Environment Configuration

---

# Containerization

The application is containerized using Docker.

### Build Image

```bash
docker build -t devops-platform-app -f docker/Dockerfile .
```

### Run Container

```bash
docker run -p 3000:3000 devops-platform-app
```

### Features

* Multi-stage Docker Build
* Non-root Container User
* Optimized Image Size
* Production-ready Configuration

---

# Deployment Automation

Deployment and rollback operations are automated using shell scripts.

### Deploy Application

```bash
./scripts/deploy.sh
```

### Rollback Deployment

```bash
./scripts/rollback.sh
```

### Features

* Automated Kubernetes Deployment
* Controlled Rollbacks
* Deployment Consistency
* Operational Simplicity

---

# CI/CD Pipeline

GitHub Actions is used to automate build, test, security scanning, and deployment workflows.

### Pipeline Stages

* Source Code Checkout
* Dependency Installation
* Unit Testing
* Docker Image Build
* Trivy Security Scan
* Docker Image Push
* Kubernetes Deployment

### Features

* Continuous Integration
* Continuous Delivery
* Automated Testing
* Container Security Scanning
* Deployment Automation

---

# Security

Security best practices are implemented throughout the project.

### Security Controls

* Non-root Docker Containers
* Kubernetes Secrets
* Trivy Vulnerability Scanning
* Least Privilege Principle
* Image Security Validation

### Scanning

```bash
trivy image devops-platform-app:latest
```

---

# Observability Stack

## Monitoring

* Prometheus
* Grafana
* AlertManager

## Logging

* Fluent Bit
* Elasticsearch
* Kibana

## Metrics

* HTTP Request Count
* Request Duration
* CPU Usage
* Memory Usage
* Node.js Runtime Metrics
* Custom Business Metrics

## Alerts

* Application Down
* High CPU Usage
* High Memory Usage
* High Latency
* Pod Restart Detection

## Deployment

```bash
./monitoring/install.sh

```

## Grafana as Code

Grafana configuration is managed through provisioning files and stored in Git.

### Datasource Provisioning

```text
monitoring/grafana/provisioning/datasources/
```

Automatically configures Prometheus as the default datasource.

### Dashboard Provisioning

```text
monitoring/grafana/provisioning/dashboards/
```

Automatically imports dashboards during Grafana startup.

### Dashboard Storage

```text
monitoring/grafana/dashboards/
```

Contains exported dashboard JSON definitions.

### Benefits

* Infrastructure as Code
* Version Controlled Dashboards
* Automated Grafana Setup
* Reproducible Monitoring Environment


## Monitoring Features

* ServiceMonitor Integration
* Prometheus Metrics Collection
* Grafana Dashboards
* AlertManager Notifications
* Centralized Log Aggregation
* Kubernetes Monitoring

---

# Application Endpoints

## Health Check

```bash
GET /health
```

## Readiness Check

```bash
GET /ready
```

## Metrics Endpoint

```bash
GET /metrics
```

## Application Information

```bash
GET /api/v1/info
```

## Get Items

```bash
GET /api/v1/items
```

## Create Item

```bash
POST /api/v1/items
```

User
 │
 ▼
Ingress
 │
 ▼
NodeJS App
 │
 ├── Metrics ─────► Prometheus ───► Grafana
 │
 └── Logs ───────► Fluent Bit ───► Elasticsearch ───► 



## Observability Stack
- **Metrics**: Prometheus + Grafana with custom dashboards and Slack alerting
- **Tracing**: Jaeger with OpenTelemetry auto-instrumentation
- **Logging**: Fluent Bit → Elasticsearch → Kibana

See `monitoring/` for all configuration and `monitoring/install.sh` for one-command setup.
