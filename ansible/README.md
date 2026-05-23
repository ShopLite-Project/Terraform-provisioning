# Ansible

This directory contains post-provisioning automation for operator and developer access.

It is intentionally separate from Terraform:

- Terraform creates infrastructure and core platform components
- Ansible prepares users to access the bastion and Kubernetes cluster

## Intended Scope

- bastion user creation
- SSH authorized key placement
- group and sudo configuration
- kubeconfig access setup

## Suggested Flow

1. Apply Terraform `live/sandbox` roots for network, bastion, and EKS.
2. Export or record the needed Terraform outputs.
3. Run the Ansible bastion user playbook.
4. Run the kubeconfig access playbook.
