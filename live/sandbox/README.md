# Sandbox Live Roots

Each folder here is a runnable Terraform root.

Recommended order:

1. `s3-backend`
2. `vpc-core-network`
3. `bastion-host`
4. `eks-cluster`
5. `cert-manager`
6. `traefik`
7. `external-dns`
8. `argocd`

Operational pattern:

1. Run `s3-backend` first with local state.
2. Copy `backend.hcl.example` to `backend.hcl` in the remaining roots.
3. Run `terraform init -backend-config=backend.hcl`.
4. Apply each root in the order above.

Example:

```powershell
cd live/sandbox/vpc-core-network
Copy-Item backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```
