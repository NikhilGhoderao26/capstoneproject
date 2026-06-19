# E-Commerce Microservices Platform - Architecture Diagram

## System Architecture Overview

\\\
┌─────────────────────────────────────────────────────────────────────────────┐
│                                 DEVELOPER                                     │
│                            (Local Development)                                │
│                                                                                │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │ Local Development Environment                                        │   │
│  │ ┌─────────────────────────────────────────────────────────────────┐ │   │
│  │ │ Docker Compose Stack                                            │ │   │
│  │ │                                                                 │ │   │
│  │ │ ┌─────────────┐  ┌──────────────┐  ┌────────────────────────┐ │ │   │
│  │ │ │  Frontend   │  │  Product     │  │  Order Service         │ │ │   │
│  │ │ │  :3000      │  │  Service :   │  │  :5001                 │ │ │   │
│  │ │ │  (Nginx)    │  │  5000        │  │  (Node.js)             │ │ │   │
│  │ │ └─────────────┘  └──────────────┘  └────────────────────────┘ │ │   │
│  │ │                                                                 │ │   │
│  │ │ ┌──────────────────┐  ┌──────────────────┐                    │ │   │
│  │ │ │ Inventory Svc    │  │ MySQL Database   │                    │ │   │
│  │ │ │ :5002            │  │ (Internal)       │                    │ │   │
│  │ │ │ (Node.js)        │  │ :3306            │                    │ │   │
│  │ │ └──────────────────┘  └──────────────────┘                    │ │   │
│  │ │                                                                 │ │   │
│  │ │ ┌──────────────────────────────────────────────────────────┐ │ │   │
│  │ │ │ Monitoring Stack                                         │ │ │   │
│  │ │ │ ┌─────────────────┐  ┌──────────────────────────────┐   │ │ │   │
│  │ │ │ │ Prometheus      │  │ Grafana                      │   │ │ │   │
│  │ │ │ │ :9090           │  │ :3001 (admin/admin)          │   │ │ │   │
│  │ │ │ │ (Metrics DB)    │  │ (Visualization & Dashboards) │   │ │ │   │
│  │ │ │ └─────────────────┘  └──────────────────────────────┘   │ │ │   │
│  │ │ └──────────────────────────────────────────────────────────┘ │ │   │
│  │ └─────────────────────────────────────────────────────────────┘ │   │
│  └──────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      │ git push
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              GITHUB REPOSITORY                               │
│                      (Version Control & Source Code)                         │
│                                                                               │
│  ├── Dockerfiles (all services)                                             │
│  ├── Jenkinsfile (CI/CD pipeline)                                           │
│  ├── Kubernetes manifests (k8s/)                                            │
│  ├── Terraform scripts (terraform/)                                         │
│  ├── Ansible playbooks (ansible/)                                           │
│  ├── Prometheus config (prometheus.yml)                                     │
│  ├── Grafana config (grafana-datasources.yml)                               │
│  ├── Alert rules (alert_rules.yml)                                          │
│  └── Docker Compose config (docker-compose.yml)                             │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                        (Webhook triggers on commit)
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            JENKINS CI/CD PIPELINE                            │
│                          (Build & Deployment)                                │
│                                                                               │
│  Stage 1: Checkout ─→ Stage 2: Build Apps ─→ Stage 3: Build Images ─→      │
│  Stage 4: Push to Registry ─→ Stage 5: Deploy to K8s ─→ Stage 6: Verify   │
│                                                                               │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         DOCKER IMAGE REGISTRY                                │
│                        (Container Images Storage)                            │
│                                                                               │
│  capstoneproject-frontend:latest    (102 MB)                                │
│  capstoneproject-product-service:latest    (226 MB)                         │
│  capstoneproject-order-service:latest      (226 MB)                         │
│  capstoneproject-inventory-service:latest  (226 MB)                         │
│                                                                               │
│  Also includes: prometheus:latest, grafana:latest, mysql:8                 │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        KUBERNETES CLUSTER                                    │
│                     (Container Orchestration)                                │
│                                                                               │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Namespace: capstoneproject (or default)                              │ │
│  │                                                                        │ │
│  │ Deployments:                                                          │ │
│  │ ├─ Frontend Deployment (1 replica)                                   │ │
│  │ │  └─ Pod: frontend (nginx:latest)                                   │ │
│  │ │     └─ Service: frontend (NodePort 30080)                          │ │
│  │ │                                                                     │ │
│  │ ├─ Product Service Deployment (1 replica)                           │ │
│  │ │  └─ Pod: product-service (Node.js)                                 │ │
│  │ │     └─ Service: product-service (ClusterIP :5000)                  │ │
│  │ │                                                                     │ │
│  │ ├─ Order Service Deployment (1 replica)                             │ │
│  │ │  └─ Pod: order-service (Node.js)                                   │ │
│  │ │     └─ Service: order-service (ClusterIP :5001)                    │ │
│  │ │                                                                     │ │
│  │ ├─ Inventory Service Deployment (1 replica)                         │ │
│  │ │  └─ Pod: inventory-service (Node.js)                               │ │
│  │ │     └─ Service: inventory-service (ClusterIP :5002)                │ │
│  │ │                                                                     │ │
│  │ ├─ Prometheus Deployment (1 replica)                                │ │
│  │ │  ├─ ConfigMap: prometheus-config                                   │ │
│  │ │  ├─ ServiceAccount: prometheus                                     │ │
│  │ │  ├─ ClusterRole: prometheus (pod discovery)                        │ │
│  │ │  └─ Service: prometheus (ClusterIP :9090)                          │ │
│  │ │                                                                     │ │
│  │ ├─ Grafana Deployment (1 replica)                                   │ │
│  │ │  ├─ ConfigMap: grafana-datasources                                 │ │
│  │ │  ├─ ConfigMap: grafana-dashboards-provider                         │ │
│  │ │  ├─ Secret: grafana-secret (admin password)                        │ │
│  │ │  └─ Service: grafana (LoadBalancer :3000)                          │ │
│  │ │                                                                     │ │
│  │ Storage:                                                             │ │
│  │ ├─ PersistentVolume: prometheus-data                                │ │
│  │ ├─ PersistentVolume: grafana-data                                   │ │
│  │ └─ PersistentVolume: mysql-data                                     │ │
│  │                                                                        │ │
│  │ ConfigMaps:                                                           │ │
│  │ ├─ prometheus-config (scrape configs, alert rules)                  │ │
│  │ ├─ grafana-datasources (Prometheus connection)                      │ │
│  │ └─ grafana-dashboards-provider (dashboard provisioning)             │ │
│  │                                                                        │ │
│  │ RBAC:                                                                 │ │
│  │ ├─ ServiceAccount: prometheus                                        │ │
│  │ ├─ ClusterRole: prometheus (node, pod access)                        │ │
│  │ └─ ClusterRoleBinding: prometheus                                    │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
        ┌─────────────────────────────┼─────────────────────────────┐
        ▼                             ▼                             ▼
┌───────────────────┐        ┌────────────────────┐      ┌──────────────────┐
│   MONITORING      │        │   APPLICATIONS     │      │   INFRASTRUCTURE │
│                   │        │                    │      │                  │
│ Prometheus        │        │ Frontend: :3000    │      │ Terraform        │
│ ├─ Metrics DB     │        │ Product: :5000     │      │ ├─ Build Infra   │
│ ├─ Scrapes        │        │ Order: :5001       │      │ ├─ Tag Images    │
│ ├─ 15s interval   │        │ Inventory: :5002   │      │ └─ Version Mgmt  │
│ └─ 30d retention  │        │ MySQL: :3306       │      │                  │
│                   │        │                    │      │ Ansible          │
│ Grafana           │        │ REST APIs          │      │ ├─ Server Setup  │
│ ├─ Dashboards     │        │ Service Discovery  │      │ ├─ Monitoring    │
│ ├─ Alerts         │        │ Load Balancing     │      │ │   Installation │
│ └─ Visualizations │        │ Health Checks      │      │ └─ Auto-startup  │
│                   │        │                    │      │                  │
│ Alert Rules       │        │ Database: MySQL    │      │                  │
│ ├─ Error Rates    │        │ User Data Storage  │      │                  │
│ ├─ Downtime       │        │ Connection Pool    │      │                  │
│ ├─ CPU Usage      │        │ Migrations Applied │      │                  │
│ └─ Memory Usage   │        │                    │      │                  │
└───────────────────┘        └────────────────────┘      └──────────────────┘
`

## Data Flow

### Request Flow:
1. **User Request** → Frontend (React App at :3000)
2. **Frontend** → API Gateway / Service Discovery
3. **Service Discovery** → Routes to appropriate microservice
   - Product Service (:5000) - Product catalog operations
   - Order Service (:5001) - Order management
   - Inventory Service (:5002) - Stock management
4. **Microservices** → MySQL Database (:3306)
5. **Response** → Back through chain to Frontend

### Monitoring Flow:
1. **Services** → Expose metrics on /metrics endpoint
2. **Prometheus** → Scrapes metrics every 15 seconds
3. **Time Series Database** → Stores metrics for 30 days
4. **Grafana** → Queries Prometheus for visualization
5. **Dashboards** → Display real-time metrics & health status
6. **Alerts** → Triggered based on alert rules

### Deployment Flow:
1. **Developer** → Commits code to GitHub
2. **GitHub Webhook** → Triggers Jenkins pipeline
3. **Jenkins Pipeline**:
   - Checks out code from GitHub
   - Builds frontend (npm install, npm run build)
   - Builds microservices (npm install)
   - Builds Docker images for all services
   - Tags with build number
   - Pushes to Docker Registry
4. **Docker Registry** → Stores versioned images
5. **Kubernetes** → Pulls images and deploys
6. **Services** → Start collecting metrics for Prometheus

## Key Technologies

### Application Layer
- **Frontend**: React.js + Nginx
- **Backend**: Node.js (Express)
- **Database**: MySQL 8

### Containerization
- **Docker**: Container runtime
- **Docker Compose**: Local orchestration
- **Docker Registry**: Image storage

### Orchestration
- **Kubernetes**: Production orchestration
- **Helm**: Package management (optional)

### Infrastructure as Code
- **Terraform**: Cloud infrastructure provisioning
- **Ansible**: Configuration management

### CI/CD
- **Jenkins**: Continuous integration/deployment
- **GitHub Actions**: Additional automation

### Monitoring & Observability
- **Prometheus**: Metrics collection
- **Grafana**: Visualization & dashboards
- **Alert Manager**: Alert routing (optional)

## Service Communication

### Internal Communication (Kubernetes)
- Services communicate via DNS: \service-name.namespace.svc.cluster.local\
- Example: \product-service.default.svc.cluster.local:5000\

### External Communication
- Frontend exposed via NodePort (K8s) or port 3000 (Docker Compose)
- APIs accessible on their respective ports
- Prometheus & Grafana accessible on their ports

## Security Considerations

- RBAC configured for Prometheus pod access
- ServiceAccounts with minimal permissions
- ConfigMaps for non-sensitive configuration
- Secrets for sensitive data (passwords)
- Health checks on all services
- Resource limits and requests defined

## Scalability

- **Horizontal Scaling**: Increase replicas in K8s deployments
- **Load Balancing**: Service mesh (Istio) for advanced routing
- **Database**: Connection pooling, read replicas
- **Caching**: Redis for session/data caching (optional)
- **CDN**: CloudFlare/AWS CloudFront for static assets

## High Availability Features

- Multiple replicas of services
- Persistent volumes for data durability
- Health checks with automatic restart
- Rolling updates for zero-downtime deployments
- Monitoring and alerting for early issue detection

## Cost Optimization

- Resource requests/limits prevent over-provisioning
- Horizontal Pod Autoscaler for dynamic scaling
- Container image optimization
- Efficient storage utilization
- Reserved instances (cloud providers)
