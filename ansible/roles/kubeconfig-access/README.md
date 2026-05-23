# kubeconfig-access Role

This role prepares kubeconfig usage information for approved users.

Expected data structure:

```yaml
kubeconfig_users:
  - username: alice
```

Current scaffold behavior writes a simple helper file in each user's home directory with the recommended EKS kubeconfig command.
