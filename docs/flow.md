# Provisioning Flow

## End-to-end Flow

1. Terraform bootstraps the remote state backend.
2. Terraform provisions AWS networking.
3. Terraform provisions the bastion host.
4. Terraform provisions EKS and IAM-related cluster access foundations.
5. Ansible configures bastion users and kubeconfig-related access paths.
6. Terraform bootstraps cert-manager, Traefik, External DNS, and ArgoCD into the cluster.
7. ArgoCD syncs the next-wave operators and application platform from the GitOps repository.

## Kubeconfig Role

`kubeconfig` is the client-side access configuration for the EKS cluster.

Terraform should output at least:

- cluster name
- AWS region
- recommended `aws eks update-kubeconfig` command

Ansible can then distribute or prepare user access paths based on the organization standard.

## Ansible Handoff

Terraform should expose enough information for Ansible to work cleanly, for example:

- bastion public IP or DNS name
- cluster name
- AWS region
- recommended kubeconfig update command
- admin or operator IAM role names if applicable

Ansible should then use that information to:

- create bastion users
- place authorized keys
- configure shell access as required
- prepare kubeconfig usage instructions or files for approved users

## Remote State Expectations

- `s3-backend` runs first and prepares the shared backend bucket and lock table
- `bastion` depends on VPC outputs
- `eks` depends on VPC outputs
- bootstrap add-ons depend on EKS outputs
- some bootstrap add-ons may also depend on DNS or IAM outputs when implemented

## Structure Pattern

This repository follows a flat pattern similar to the reference `terraform-modules-dev` repository:

- `modules/<component>` holds reusable module code
- `live/sandbox/<component>` is a runnable Terraform root
- `environments/*.yaml` provides shared configuration consumed by the runnable roots
