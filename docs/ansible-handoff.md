# Ansible Handoff

## Purpose

Terraform provisions the platform foundation. Ansible prepares human access to use that foundation safely.

## Terraform to Ansible Contract

Terraform should expose outputs that Ansible can consume, such as:

- bastion public IP or DNS
- bastion SSH username conventions
- cluster name
- AWS region
- kubeconfig update command

## Ansible Responsibilities

- create bastion users
- attach SSH public keys
- assign groups and sudo policy
- prepare kubeconfig access guidance for users

## Non-goals

- Ansible should not own AWS infrastructure resources created by Terraform
- Ansible should not replace ArgoCD for in-cluster application delivery
