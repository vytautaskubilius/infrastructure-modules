# IAM OpenID Connect provider

This simple module creates an IAM OpenID Connect provider.

# Usage

```hcl
terraform {
  source = "git@github.com:vytautaskubilius/infrastructure-modules.git//modules/security/iam/oidc"
}

inputs = {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}
```
