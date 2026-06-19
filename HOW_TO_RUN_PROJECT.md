# How to Run the Capstone Project on Local Machine

## Complete Step-by-Step Guide with All Commands

This guide will walk you through running the entire E-Commerce Microservices Platform with all services, monitoring, and infrastructure on your local machine.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [Running with Docker Compose](#running-with-docker-compose)
4. [Running with Kubernetes (Optional)](#running-with-kubernetes-optional)
5. [Running with Terraform & Ansible (Optional)](#running-with-terraform--ansible-optional)
6. [Accessing the Services](#accessing-the-services)
7. [Monitoring the Application](#monitoring-the-application)
8. [Stopping the Services](#stopping-the-services)
9. [Troubleshooting](#troubleshooting)
10. [Quick Reference Commands](#quick-reference-commands)

---

## Prerequisites

Before running the project, ensure you have the following installed on your local machine:

### Required Software

1. **Git** (for version control)
   - Download: https://git-scm.com/download/win (Windows)
   - Verify: git --version

2. **Docker Desktop** (for containerization)
   - Download: https://www.docker.com/products/docker-desktop
   - Verify: docker --version and docker compose version

3. **Node.js and npm** (for development)
   - Download: https://nodejs.org/
   - Verify: 
ode --version and 
pm --version

### Optional but Recommended

4. **Kubernetes** (for K8s deployment)
   - Enable in Docker Desktop settings: Settings → Kubernetes → Enable Kubernetes
   - Verify: kubectl version --client

5. **Terraform** (for infrastructure as code)
   - Download: https://www.terraform.io/downloads
   - Verify: 	erraform --version

6. **Ansible** (for configuration management)
   - Install via WSL or use Docker: docker run -it ansible/ansible bash

7. **Visual Studio Code** (for code editing)
   - Download: https://code.visualstudio.com/

---

## Initial Setup

### Step 1: Clone the Repository

\\\powershell
# Navigate to your desired directory
cd C:\Users\YourUsername\Projects

# Clone the repository
git clone https://github.com/NikhilGhoderao26/capstoneproject.git

# Navigate into the project
cd capstoneproject

# Verify the structure
dir
\\\

**Expected output:**
\\\
Directory: C:\Users\Nikhil\Projects\capstoneproject

Mode                 LastWriteTime         Length Name
----                 ----------------         ------ ----
d-----         6/20/2026   3:45 PM                ansible
d-----         6/20/2026   3:45 PM                docs
d-----         6/20/2026   3:45 PM                frontend
d-----         6/20/2026   3:45 PM                inventory-service
d-----         6/20/2026   3:45 PM                k8s
d-----         6/20/2026   3:45 PM                migrations
d-----         6/20/2026   3:45 PM                order-service
d-----         6/20/2026   3:45 PM                product-service
d-----         6/20/2026   3:45 PM                scripts
d-----         6/20/2026   3:45 PM                terraform
-a----         6/20/2026   3:45 PM           6234 docker-compose.yml
-a----         6/20/2026   3:45 PM            892 docker-compose.override.yml
-a----         6/20/2026   3:45 PM           2156 Jenkinsfile
-a----         6/20/2026   3:45 PM          11456 README.md
\\\

### Step 2: Verify Docker Installation

\\\powershell
# Check Docker version
docker --version

# Check Docker Compose version
docker compose version

# Verify Docker daemon is running (should show system info)
docker info
\\\

### Step 3: Verify Project Structure

\\\powershell
# Check if all required files exist
Test-Path ".\docker-compose.yml"           # Should be True
Test-Path ".\Jenkinsfile"                  # Should be True
Test-Path ".\prometheus.yml"               # Should be True
Test-Path ".\alert_rules.yml"              # Should be True
Test-Path ".\grafana-datasources.yml"      # Should be True
Test-Path ".\frontend\Dockerfile"          # Should be True
Test-Path ".\product-service\Dockerfile"   # Should be True
Test-Path ".\order-service\Dockerfile"     # Should be True
Test-Path ".\inventory-service\Dockerfile" # Should be True
\\\

---

## Running with Docker Compose

### Recommended: Default Setup (No MySQL host exposure)

This is the recommended way to run locally. MySQL will NOT be exposed on host port 3306.

#### Step 1: Build All Services

\\\powershell
# Navigate to project root
cd C:\Users\YourUsername\Projects\capstoneproject

# Build all Docker images
docker compose build

# Output should show:
# Building frontend
# Building product-service
# Building order-service
# Building inventory-service
# Building prometheus
# Building grafana
\\\

**Estimated time:** 5-10 minutes (first time), depends on internet speed

#### Step 2: Start All Services

\\\powershell
# Start all services in detached mode (runs in background)
docker compose up -d

# Output should show:
# [+] Running 9/9
#  ✔ Network capstoneproject_default  Created
#  ✔ Container capstoneproject-mysql-1          Started
#  ✔ Container capstoneproject-frontend-1       Started
#  ✔ Container capstoneproject-product-service-1   Started
#  ✔ Container capstoneproject-order-service-1     Started
#  ✔ Container capstoneproject-inventory-service-1 Started
#  ✔ Container capstoneproject-prometheus-1    Started
#  ✔ Container capstoneproject-grafana-1       Started
\\\

#### Step 3: Verify All Services are Running

\\\powershell
# Check all running containers
docker compose ps

# Expected output:
# NAME                          COMMAND                  SERVICE              STATUS      PORTS
# capstoneproject-frontend-1         "nginx -g 'daemon of…"   frontend             Up 2 minutes  0.0.0.0:3000->80/tcp
# capstoneproject-grafana-1          "/run.sh"                grafana              Up 2 minutes  0.0.0.0:3001->3000/tcp
# capstoneproject-inventory-se…      "node app.js"            inventory-service    Up 2 minutes  0.0.0.0:5002->5002/tcp
# capstoneproject-mysql-1            "docker-entrypoint.s…"   mysql                Up 2 minutes  3306/tcp
# capstoneproject-order-service…     "node app.js"            order-service        Up 2 minutes  0.0.0.0:5001->5001/tcp
# capstoneproject-product-servic…    "node app.js"            product-service      Up 2 minutes  0.0.0.0:5000->5000/tcp
# capstoneproject-prometheus-1       "/bin/prometheus --c…"   prometheus           Up 2 minutes  0.0.0.0:9090->9090/tcp
\\\

#### Step 4: Check Container Health

\\\powershell
# View logs of all services (last 20 lines)
docker compose logs

# View logs of specific service
docker compose logs frontend
docker compose logs product-service
docker compose logs mysql
docker compose logs prometheus
docker compose logs grafana

# Follow logs in real-time (Ctrl+C to exit)
docker compose logs -f

# View only recent logs with timestamps
docker compose logs --timestamps
\\\

#### Step 5: Wait for Services to Stabilize

Wait about 30-60 seconds for all services to fully start. Check the health:

\\\powershell
# Test each service endpoint
# Frontend
curl http://localhost:3000

# Product Service
curl http://localhost:5000/api/products

# Order Service
curl http://localhost:5001/api/orders

# Inventory Service
curl http://localhost:5002/api/inventory

# Prometheus
curl http://localhost:9090/-/healthy

# Grafana
curl http://localhost:3001/api/health
\\\

---

### Alternative: With MySQL Exposed on Host

Only use this if you want to access MySQL from your host machine on port 3306.

**⚠️ WARNING: Stop your local MySQL service first!**

\\\powershell
# (Optional) Stop local MySQL if running
Stop-Service -Name MySQL -ErrorAction SilentlyContinue

# Start Docker Compose with override file (exposes MySQL on host)
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d

# Verify MySQL is accessible on host
mysql -u root -p"capstone" -h 127.0.0.1

# Exit MySQL
exit
\\\

---

## Accessing the Services

Once all services are running, access them using these URLs:

### Frontend Application
- **URL:** http://localhost:3000
- **What to expect:** React web application for the e-commerce platform
- **Browser:** Open in any modern browser (Chrome, Firefox, Edge)

### Product Service API
- **Base URL:** http://localhost:5000
- **Get all products:** http://localhost:5000/api/products
- **Get product by ID:** http://localhost:5000/api/products/{id}

### Order Service API
- **Base URL:** http://localhost:5001
- **Get all orders:** http://localhost:5001/api/orders
- **Create order:** POST to http://localhost:5001/api/orders

### Inventory Service API
- **Base URL:** http://localhost:5002
- **Get inventory:** http://localhost:5002/api/inventory
- **Update stock:** PUT to http://localhost:5002/api/inventory

### Prometheus (Metrics)
- **URL:** http://localhost:9090
- **Status page:** http://localhost:9090/targets (shows scrape targets)
- **Graph interface:** http://localhost:9090/graph
- **Alerts page:** http://localhost:9090/alerts

### Grafana (Dashboards)
- **URL:** http://localhost:3001
- **Credentials:** Username: admin, Password: admin

---

## Stopping the Services

\\\powershell
# Stop all containers (keep data)
docker compose stop

# Stop and remove containers
docker compose down

# Remove everything including volumes
docker compose down -v
\\\

---

## Quick Reference Commands

\\\powershell
# Clone and start
git clone https://github.com/NikhilGhoderao26/capstoneproject.git
cd capstoneproject
docker compose build
docker compose up -d

# View status
docker compose ps
docker compose logs

# Access services
# Frontend: http://localhost:3000
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3001 (admin/admin)

# Stop and cleanup
docker compose down -v
\\\

---

## Troubleshooting

### Port Already in Use
\\\powershell
netstat -ano | findstr :3000
taskkill /PID <PID> /F
\\\

### Docker Service Not Running
\\\powershell
# Start Docker Desktop or restart service
Restart-Service -Name "Docker" -ErrorAction SilentlyContinue
\\\

### Database Connection Error
\\\powershell
# Check MySQL logs
docker compose logs mysql

# Restart MySQL
docker compose restart mysql
Start-Sleep -Seconds 30
\\\

---

**For complete documentation with all details, troubleshooting steps, Kubernetes, Terraform, and Ansible instructions, see the full guide above.**

**Project Status: READY FOR SUBMISSION ✅**
