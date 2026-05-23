# bastion-users Role

This role manages OS-level bastion access for approved users.

Expected data structure:

```yaml
bastion_users:
  - username: alice
    groups:
      - sudo
    ssh_public_key: "ssh-rsa AAAA..."
```
