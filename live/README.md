# Live

This directory contains runnable Terraform roots.

Each root loads shared values from `environments/` and calls one or more modules from `modules/`.

The `s3-backend` root is the bootstrap exception and should run first before the other roots rely on shared remote state.

After `s3-backend` is applied, the other roots should be initialized with a private `backend.hcl` copied from each root's `backend.hcl.example`.

Why this is separate:

- Terraform config in `main.tf` can read YAML locals during `plan` and `apply`
- Terraform backend settings are needed earlier during `init`
- because of that timing, backend config cannot come from `locals` or `yamldecode`
