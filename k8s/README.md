Kubernetes manifests for capstoneproject

How to deploy locally (requires kubectl access to your cluster):

1. Edit the `image` fields in the deployment YAMLs to point to your registry and tag.
2. Create the namespace and resources:

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/ -n capstoneproject
```

3. Optionally, update deployments with new images after pushing them:

```bash
kubectl -n capstoneproject set image deployment/product-deployment product=REGISTRY/IMAGE:TAG
kubectl -n capstoneproject set image deployment/order-deployment order=REGISTRY/IMAGE:TAG
kubectl -n capstoneproject set image deployment/inventory-deployment inventory=REGISTRY/IMAGE:TAG
kubectl -n capstoneproject set image deployment/frontend-deployment frontend=REGISTRY/IMAGE:TAG
```

Notes:
- The manifests use placeholder `REPLACE_WITH_IMAGE` for image values — set these before applying or use `kubectl set image`.
- These manifests are minimal and intended for demo/Dev clusters. Consider adding resource requests/limits, readiness/liveness probes, and ReplicaSets for production use.
