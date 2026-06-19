# Monitoring and Observability Setup

This document describes the monitoring and observability infrastructure for the e-commerce microservices platform using Prometheus and Grafana.

## Components

### 1. Prometheus
- **Purpose**: Metrics collection and time-series database
- **Default Port**: 9090
- **Configuration**: `prometheus.yml`

### 2. Grafana
- **Purpose**: Metrics visualization and dashboard management
- **Default Port**: 3000 (Docker Compose) / 3001 (Kubernetes)
- **Default Credentials**: 
  - Username: `admin`
  - Password: `admin`

## Docker Compose Deployment

### Starting the Stack

`powershell
docker compose up --build -d
`

Access services:
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001

## Kubernetes Deployment

### Deploy Monitoring Stack

`bash
kubectl apply -f k8s/prometheus-deployment.yaml
kubectl apply -f k8s/grafana-deployment.yaml
`

### Port Forward

`bash
kubectl port-forward svc/prometheus 9090:9090
kubectl port-forward svc/grafana 3000:3000
`

## Ansible Deployment

### Configure Monitoring

Edit `ansible/inventory.ini` and run:

`bash
ansible-playbook -i inventory.ini site.yml -e "install_monitoring=true"
`

## Alert Rules

Configured alerts for:
- High error rates (5xx errors)
- Service downtime
- High memory/CPU usage
- Disk space issues

## Key PromQL Queries

### Service Health
`promql
up{job=~"product-service|order-service|inventory-service"}
`

### Request Rate
`promql
rate(http_requests_total[5m])
`

### Error Rate
`promql
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])
`

### Response Time (p95)
`promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
`

## Troubleshooting

1. **Prometheus not scraping**: Check http://localhost:9090/targets
2. **Grafana connection issues**: Verify Prometheus is accessible
3. **High resource usage**: Check retention policy and scrape intervals

For detailed information, see the complete MONITORING.md documentation.
