# Architecture

## Goal

Provision the ShopLite platform with Terraform in a way that is easy to redeploy and easy to hand off to ArgoCD afterward.

## Core Idea

There are two control planes:

- Terraform bootstraps AWS and the minimum Kubernetes platform components
- ArgoCD manages the ongoing in-cluster platform and application lifecycle

## Terraform-managed Components

- VPC
- bastion host
- EKS control plane and worker nodes
- IAM, security groups, and IRSA prerequisites
- cert-manager
- Traefik
- External DNS
- ArgoCD

## ArgoCD-managed Components

- External Secrets Operator
- policy engines
- observability
- service mesh
- Kafka operator
- Kafka cluster and topics
- ShopLite applications

## Why This Split

- ArgoCD needs a cluster and access path before it can manage anything
- ingress and certificates are core platform prerequisites
- the cluster should be reproducible from Terraform without relying on manual bootstrap steps
- once ArgoCD exists, it becomes the better owner for broader platform layering
