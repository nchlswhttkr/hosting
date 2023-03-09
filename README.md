# hosting

Infrastructure, playbooks and configuration for self-hosted services I run.

## Terraform

I have a number of fairly foundational Terraform projects that don't belong to any particular project repositories, so I keep them here.

|                     |                                                                                                                              |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `terraform-backend` | An AWS backend for all my other Terraform projects to use                                                                    |
| `vault`             | My self-hosted [Hashicorp Vault](https://www.hashicorp.com/products/vault) instance for credential management in my projects |
| `elastic-ci-stack`  | Autoscaling Buildkite agents, plus secrets needed by my Buildkite pipelines                                                  |

Each project is deployed by its own `Makefile`.

```sh
make -C infrastructure/terraform-backend
```
