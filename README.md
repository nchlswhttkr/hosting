# hosting

Infrastructure, playbooks and configuration for self-hosted services I run.

## Pipelines

I automate some maintenance tasks with Buildkite.

|                                                                                                                                                                               |                            |                                                  |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------- | ------------------------------------------------ |
| [![Build status](https://badge.buildkite.com/75b7bae85ee38f73966c32cef60f1251d3a186ef4d63ff7dc0.svg?branch=main)](https://buildkite.com/nchlswhttkr/hosting-plausible-backup) | `hosting-plausible-backup` | Runs a scheduled backup of my Plausible instance |

## Infrastructure

I have a number of Terraform projects that don't belong to any particular project repositories, so I keep them here.

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

## Self-hosted Deployments

I self-host a number of personal projects and services, and predominantly manage these with Ansible.

- `boyd` - A Raspberry Pi 3 Model A+ sitting on my desk
  - A [Buildkite agent](https://buildkite.com/) dedicated to uploading pipeline files
  - A [Writefreely](https://writefreely.org/) instance available to my Tailnet at https://write.nicholas.cloud/

```sh
make -C deploy/boyd
```
