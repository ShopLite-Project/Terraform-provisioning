# Bootstrap Order

## Intended Order

1. s3-backend
2. cert-manager
3. Traefik
4. External DNS
5. ArgoCD

## Why Backend Comes First

The S3 bucket and DynamoDB lock table must exist before the other Terraform roots can safely use shared remote state.

This root is the bootstrap exception:

- it runs first
- it can use local state during first bootstrap
- after it succeeds, the other roots can switch to the shared S3 backend

## Why This Order

### cert-manager first

Certificates and issuers are common dependencies for exposed platform services.

### Traefik second

Ingress should exist before later platform endpoints are exposed.

### External DNS third

DNS automation becomes useful after ingress endpoints exist.

### ArgoCD last

ArgoCD can then be exposed through the intended ingress and certificate path from day one.

## What Happens Next

After ArgoCD is reachable and healthy, it should deploy:

- secrets and policy helpers
- observability and service mesh layers
- stateful operator stacks
- ShopLite workloads
