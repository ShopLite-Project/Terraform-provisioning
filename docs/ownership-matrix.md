# Ownership Matrix

| Component | Owner | Reason |
|---|---|---|
| VPC | Terraform | Base AWS infrastructure |
| Bastion | Terraform | Access foundation |
| EKS | Terraform | Cluster foundation |
| IAM / IRSA | Terraform | AWS identity foundation |
| cert-manager | Terraform | Bootstrap TLS dependency |
| Traefik | Terraform | Bootstrap ingress dependency |
| External DNS | Terraform | Bootstrap DNS dependency |
| ArgoCD | Terraform | GitOps bootstrap entrypoint |
| External Secrets Operator | ArgoCD | Second-wave platform layer |
| Policy engines | ArgoCD | Ongoing platform policy management |
| Observability | ArgoCD | Ongoing platform stack |
| Service mesh | ArgoCD | Ongoing platform stack |
| Kafka operator | ArgoCD | Ongoing platform stack |
| Kafka cluster manifests | ArgoCD | In-cluster lifecycle after bootstrap |
| ShopLite services | ArgoCD | Application delivery |

## Rule

No component should be managed by both Terraform and ArgoCD at the same time.
