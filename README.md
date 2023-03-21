# hosting

Infrastructure, playbooks and configuration for self-hosted services I run.

## Terraform

I have a number of fairly foundational Terraform projects that don't belong to any particular project repositories, so I keep them here.

|                              |                                                                             |
| ---------------------------- | --------------------------------------------------------------------------- |
| `terraform-backend`          | An AWS backend for all my other Terraform projects to use                   |
| `vault`                      | My self-hosted Vault instance for credential management in my projects      |
| `elastic-ci-stack`           | Autoscaling Buildkite agents, plus secrets needed by my Buildkite pipelines |
| `nicholas-dot-cloud`         | Infrastructure related to my personal website                               |
| `nicholas-dot-cloud-preview` | Generating previews of pull request changes to my personal website          |

Each project is deployed by its own `Makefile`.

```sh
make -C infrastructure/terraform-backend
```
