# hosting

Infrastructure, playbooks and configuration for self-hosted services I run.

## Pipelines

I automate some maintenance tasks with Buildkite.

|                                                                                                                                                                               |                            |                                          |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- | ---------------------------------------- |
| [![Build status](https://badge.buildkite.com/97343e68892aa5fbb7fd00885adb0a28fdd9468cbb28763ef3.svg?branch=main)](https://buildkite.com/nchlswhttkr/hosting-backup-plausible) | `hosting-backup-plausible` | Backs up my Plausible Analytics instance |
| [![Build status](https://badge.buildkite.com/c4820c1695baf489be6ca1eb3104096ac289c88602b1d91ac3.svg?branch=main)](https://buildkite.com/nchlswhttkr/hosting-backup-vault)     | `hosting-backup-vault`     | Backs up my Hashicorp Vault instance     |
| [![Build status](https://badge.buildkite.com/8147d53ba87d1daeb8053ba266ab93c69984c51f9678fc0d56.svg?branch=main)](https://buildkite.com/nchlswhttkr/hosting-backup-write)     | `hosting-backup-write`     | Backs up my Writefreely instance         |

## Infrastructure

I have a number of Terraform projects that don't belong to any particular project repositories, so I keep them here.

|                              |                                                                              |
| ---------------------------- | ---------------------------------------------------------------------------- |
| `backups`                    | Automating backups of my self-hosted services                                |
| `elastic-ci-stack`           | Autoscaling Buildkite agents, plus secrets needed by my Buildkite pipelines  |
| `nicholas-dot-cloud`         | Infrastructure related to my personal website                                |
| `nicholas-dot-cloud-preview` | Generating previews of pull request changes to my personal website           |
| `terraform-backend`          | An AWS backend for all my other Terraform projects to use                    |
| `vault`                      | Backend and policy configuration for my self-hosted Hashicorp Vault instance |

Each project is deployed by its own `Makefile`.

```sh
make -C infrastructure/terraform-backend
```

## Self-hosted Deployments

I self-host a number of personal projects and services, and predominantly manage these with Ansible.

- `boyd` - A Raspberry Pi 3 Model A+ sitting on my desk
  - A [Buildkite agent](https://buildkite.com/) dedicated to uploading pipeline files
  - A [Writefreely](https://writefreely.org/) instance available to my Tailnet at https://write.nicholas.cloud/
- `gandra-dee` - A small DigitalOcean droplet
  - My [personal website](https://github.com/nchlswhttkr/website/) at https://nicholas.cloud/
  - A [Plausible Analytics instance](https://plausible.io/) at https://plausible.nicholas.cloud/
- `gyro` - A Raspberry Pi 4 Model B also sitting on my desk
  - A [Hashicorp Vault instance](https://www.hashicorp.com/products/vault) at https://vault.nicholas.cloud/

Once again each project has its own `Makefile`, but there a little bit of general setup required for Ansible too.

```sh
make -C deploy

make -C deploy/boyd
make -C deploy/gandra-dee
make -C deploy/gyro
```
