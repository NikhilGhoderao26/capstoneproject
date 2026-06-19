#!/usr/bin/env bash
set -euo pipefail
TAG=${1:-local}
REGISTRY=${2:-}
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Building images with tag: $TAG"

if [ -f "$ROOT_DIR/frontend/Dockerfile" ]; then
  docker build -t "capstoneproject-frontend:$TAG" $ROOT_DIR/frontend
else
  echo "frontend/Dockerfile not found, skipping"
fi

if [ -f "$ROOT_DIR/product-service/Dockerfile" ]; then
  docker build -t "capstoneproject-product-service:$TAG" $ROOT_DIR/product-service
else
  echo "product-service/Dockerfile not found, skipping"
fi

if [ -f "$ROOT_DIR/order-service/Dockerfile" ]; then
  docker build -t "capstoneproject-order-service:$TAG" $ROOT_DIR/order-service
else
  echo "order-service/Dockerfile not found, skipping"
fi

if [ -f "$ROOT_DIR/inventory-service/Dockerfile" ]; then
  docker build -t "capstoneproject-inventory-service:$TAG" $ROOT_DIR/inventory-service
else
  echo "inventory-service/Dockerfile not found, skipping"
fi

if [ -n "$REGISTRY" ]; then
  echo "Tagging and pushing to registry: $REGISTRY"
  docker tag "capstoneproject-frontend:$TAG" "$REGISTRY/capstoneproject-frontend:$TAG"
  docker tag "capstoneproject-product-service:$TAG" "$REGISTRY/capstoneproject-product-service:$TAG"
  docker tag "capstoneproject-order-service:$TAG" "$REGISTRY/capstoneproject-order-service:$TAG"
  docker tag "capstoneproject-inventory-service:$TAG" "$REGISTRY/capstoneproject-inventory-service:$TAG"

  docker push "$REGISTRY/capstoneproject-frontend:$TAG"
  docker push "$REGISTRY/capstoneproject-product-service:$TAG"
  docker push "$REGISTRY/capstoneproject-order-service:$TAG"
  docker push "$REGISTRY/capstoneproject-inventory-service:$TAG"
fi

echo "Done"
