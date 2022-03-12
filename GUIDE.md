# Terraform guide

The aim of this guide is not to reiterate what is found in Terraform or Github's documentation but rather to encapsulate the workflow that we have established at Anomaly. The guide will cover a few core concepts and followed by steps that will help you get a project setup quickly.

Whilst the defined stack should work for most applications at Anomaly, please review the resources required by your application.

# Ingredients

The guide assumes the availability of the following tools:

- [Terraform](https://github.com/hashicorp/terraform) 1.1.x or higher
- [Linode CLI](https://github.com/linode/linode-cli) 5.16.x or higher, this is rarely used to query Stackscript and may be redundant as we moved to managed databases
- [`sed`](https://www.gnu.org/software/sed/)
- [`curl`](https://curl.se/)
- [`jq`](https://stedolan.github.io/jq/)

and the following services:

- [GitHub](https://github.com) for source control with their [Actions](https://github.com/features/actions) feature available
- [Terraform](https://www.terraform.io) for provisioning and managing infrastructure, with the [Terraform Cloud](https://www.terraform.io/cloud) feature available
- [Docker](https://www.docker.com) for containerisation of the infrastructure, with Docker Hub and Docker Compose available

> _Note_: this is a template repository and the requirements for the actual project may vary

You will require the following credentials:

- Linode API Key with full access for Terraform Cloud to run the jobs, [see here](https://www.linode.com/docs/security/api-access/)
- Terraform API Key for Github actions to trigger Terraform jobs, [see here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token-secret)

> This guide assumes you are using macOS 11+

# Notes on Linode's official provider

A provider


Terraform also allows you to write modules, but there are selected usecase where you should be using Modules, this repository 

![module](https://www.terraform.io/img/docs/image2.png)
> Image courtesy of [Terraform](https://www.terraform.io/)

# Setup

Install the command line utilities via Homebrew:

```zsh
brew install jq
brew install terraform
brew install linode-cli
```

# Querying Linode for Stackscripts

At the moment you require the [Stackscript IDs](https://www.linode.com/docs/guides/platform/stackscripts/) for:

- PostgreSQL One-Click
- Docker One-Click

Both these will likely deprecated into the future and replaced with managed services. For now it's handy to know how to query Linode for these:

```zsh
➜  ~ linode-cli stackscripts list --label="PostgreSQL One-Click"                                            
┌────────┬──────────┬──────────────────────┬─────────────────┬───────────┬─────────────────────┬─────────────────────┐
│ id     │ username │ label                │ images          │ is_public │ created             │ updated             │
├────────┼──────────┼──────────────────────┼─────────────────┼───────────┼─────────────────────┼─────────────────────┤
│ 611376 │ linode   │ PostgreSQL One-Click │ linode/debian11 │ True      │ 2019-11-13T06:05:28 │ 2022-02-22T15:08:31 │
└────────┴──────────┴──────────────────────┴─────────────────┴───────────┴─────────────────────┴─────────────────────┘
```

> _Note_: you will be required to authenticate the cli once, before you can run this command using `linode-cli login`

## Terraform Cloud


## Github


# Workflow

You will require to use the following features 

![workflow](https://mktg-content-api-hashicorp.vercel.app/api/assets?product=tutorials&version=main&asset=public%2Fimg%2Fterraform%2Fautomation%2Ftfc-gh-actions-workflow.png)

> Image courtesy of [Terraform](https://www.terraform.io/)

Managing between environments, from feature to staging through to prod

# Resources

The above guide has been put together from the knowledge available at these web resources. While most practices comes from Hashicorp's guide, there are pearls of wisdom from the team at Linode that have been thrown into the mix.

- [Linode Terraform guide](https://www.linode.com/docs/guides/how-to-build-your-infrastructure-using-terraform-and-linode/)
- [Hashicorp's guide to Github actions](https://learn.hashicorp.com/tutorials/terraform/github-actions)

