# hosting

Infrastructure, playbooks and configuration for self-hosted services I run.

## Pipelines

I automate some maintenance tasks with Buildkite.

|                                                                                                                                                                         |                      |                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- | ------------------------------------ |
| [![Build status](https://badge.buildkite.com/c4820c1695baf489be6ca1eb3104096ac289c88602b1d91ac3.svg?branch=main)](https://buildkite.com/nchlswhttkr/backup-vault)       | `backup-vault`       | Backs up my Hashicorp Vault instance |
| [![Build status](https://badge.buildkite.com/1bebec299d9b84c6a43454cde22281d93a55370ce2a47d8dd7.svg?branch=main)](https://buildkite.com/nchlswhttkr/backup-writefreely) | `backup-writefreely` | Backs up my Writefreely instance     |

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

<!-- TODO: Graph dependencies of Terraform base infrastructure (Vault, Backups) and embed via https://excalidraw.com/ -->

## Self-hosted Deployments

I self-host a number of personal projects and services, and predominantly manage these with Ansible.

Once again each project has its own `Makefile`, but there a little bit of general setup required for Ansible too.

```sh
make -C deploy

make -C deploy/blog
make -C deploy/buildkite-uploader
make -C deploy/vault
make -C deploy/writefreely
```

Some projects include subcommands.

```sh
make -C deploy/writefreely backup
```

### Setting up new hosts

There's a couple of assumed tools and setup needed before a new host is good to go with Ansible.

- Install [Tailscale](https://tailscale.com/kb/1031/install-linux/) and add to your Tailnet
- Install [Certbot](https://certbot.eff.org/instructions)
  - Installing Certbot will require [Snap](https://snapcraft.io/docs/installing-snap-on-raspbian)
  - For now, use [the Cloudflare plugin](https://certbot-dns-cloudflare.readthedocs.io/en/stable/)

TLS certificate provisioning and automatic renewal will be set up as part of the `nginx` role.
