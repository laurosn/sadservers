#!/bin/bash
# Fix a broken Nginx Kubernetes Deployment that fails to schedule due to:
#   1. nodeSelector pointing at an unreachable node
#   2. memory request of 2000Mi exceeding available node capacity

DEPLOY=$(kubectl get deployment -o jsonpath='{.items[0].metadata.name}')
echo "Patching deployment: $DEPLOY"

# Fix 1: remove node scheduling constraints
kubectl patch deployment "$DEPLOY" --type=strategic -p '
{
  "spec": {
    "template": {
      "spec": {
        "nodeSelector": null,
        "affinity": null,
        "nodeName": null
      }
    }
  }
}'

# Fix 2: lower memory from 2000Mi to 128Mi so the pod fits on the available node
kubectl patch deployment "$DEPLOY" --type=strategic -p '
{
  "spec": {
    "template": {
      "spec": {
        "containers": [{
          "name": "nginx",
          "resources": {
            "requests": {"cpu": "100m", "memory": "128Mi"},
            "limits":   {"cpu": "100m", "memory": "128Mi"}
          }
        }]
      }
    }
  }
}'

echo ""
echo "=== Waiting for rollout (up to 90s) ==="
kubectl rollout status deployment/"$DEPLOY" --timeout=90s

echo ""
echo "=== Pod status ==="
kubectl get pods -o wide

echo ""
echo "=== Test ==="
curl -s --max-time 5 10.43.216.196 | grep -o '<title>.*</title>'
