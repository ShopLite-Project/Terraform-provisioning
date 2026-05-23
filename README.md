# Terraform Provisioning

Single-repository Terraform layout for ShopLite platform provisioning.

This repository uses one repo with an internal split:

- `modules/` contains reusable Terraform modules
- `live/` contains the runnable Terraform roots that call the modules during provisioning
- `environments/` contains shared environment configuration files
- `ansible/` contains post-provisioning access and user configuration
- `docs/` explains ownership, flow, and bootstrap ordering

## Platform Ownership Model

Terraform owns the AWS and bootstrap platform layers:

- VPC and networking
- bastion host
- EKS
- IAM and IRSA foundations
- cert-manager
- Traefik
- External DNS
- ArgoCD

ArgoCD owns the next-wave platform and applications:

- External Secrets Operator
- policy engines
- observability stacks
- service mesh
- Kafka operator and Kafka cluster manifests
- ShopLite application deployments

This repo intentionally follows a bootstrap-first approach:

1. Terraform creates infrastructure.
2. Ansible configures bastion users and kubeconfig-related access paths.
3. Terraform installs the minimum core platform needed for safe cluster access and ingress.
4. ArgoCD manages the broader in-cluster platform and workloads.

## Repository Layout

```text
Terraform-provisioning/
  modules/
    argocd/
    bastion-host/
    cert-manager/
    eks-cluster/
    external-dns/
    iam/
    s3-backend/
    traefik/
    vpc-core-network/
  live/
    sandbox/
      s3-backend/
      argocd/
      bastion-host/
      cert-manager/
      eks-cluster/
      external-dns/
      traefik/
      vpc-core-network/
  environments/
    region.yaml
    shoplite_sandbox.yaml
  ansible/
    inventories/
    playbooks/
    roles/
  docs/
```

## Apply Order

Apply `live/sandbox` in this order:

1. `s3-backend`
2. `vpc-core-network`
3. `bastion-host`
4. `eks-cluster`
5. `cert-manager`
6. `traefik`
7. `external-dns`
8. `argocd`

State handling in that order is:

1. `s3-backend` runs first with local state.
2. Every other root is initialized against S3 using its local `backend.hcl.example` as the template for a private `backend.hcl`.
3. Those later roots then read earlier outputs through `terraform_remote_state`.

## Implementation Order

Implement the modules in this order so that dependencies stay manageable:

1. `modules/s3-backend`
2. `modules/vpc-core-network`
3. `modules/bastion-host`
4. `modules/eks-cluster`
5. `modules/cert-manager`
6. `modules/traefik`
7. `modules/external-dns`
8. `modules/argocd`

The bootstrap order is deliberate:

- `cert-manager` establishes certificate management first
- `traefik` provides ingress
- `external-dns` automates DNS records for ingress endpoints
- `argocd` comes up on the ingress and TLS path created by the earlier components

## Ansible Scope

Ansible is used after the infrastructure is provisioned to handle operating access concerns such as:

- bastion user creation
- SSH key placement
- group and sudo policy
- kubeconfig access setup

Terraform remains the source of infrastructure outputs, while Ansible consumes those outputs to prepare human access paths.

## Notes

- `terraform.tfvars` files are intentionally gitignored.
- `backend.hcl` files are intentionally gitignored.
- Each folder under `live/sandbox/` is its own Terraform root.
- Remote state wiring is described in the `docs/` files and referenced from the `data.tf` files.
- `live/sandbox/s3-backend` should be run first and can use local state for the initial backend bootstrap.
- Terraform backends cannot read `locals` or YAML config during `init`, so backend settings are supplied separately with `backend.hcl`.
