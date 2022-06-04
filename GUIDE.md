# Terraform guide

The aim of this guide is not to reiterate what is found in Terraform or Github's documentation but rather to encapsulate the workflow that we have established at Anomaly. The guide will cover a few core concepts and followed by steps that will help you get a project setup quickly.

Whilst the defined stack should work for most applications at Anomaly, please review the resources required by your application.

## Concepts

- Terraform
- How to deploy our app 
- Traefik 

## Ingredients

The guide assumes the availability of the following tools:

- [Terraform](https://github.com/hashicorp/terraform) 1.1.x or higher
- [Linode CLI](https://github.com/linode/linode-cli) 5.16.x or higher
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

## The Plan

This guide assumes that we are, automating infrastructure provisioning for a new project with the aim of being able to evolve or tear down environment as the requirements change. Our plan assumes that we will Terraform Cloud to run the jobs and then use Github Actions to trigger Terraform jobs.

- Provision secrets and setup Terraform Cloud
- Provision secrets and setup Github Actions



### Notes on Linode's official provider

A provider is a plugin that Terramform relies on to interact with the API of a cloud provider. Each provider adds a set of resource types and/or data sources that Terraform can manage. Linode provides an official verified provider via the [Terraform registry](https://registry.terraform.io/providers/linode/linode/latest).

## Setup your Development Environment

Before you are able to use this guide, you must setup certain tools and components once and others per project.

Install the command line utilities via Homebrew:

```sh
brew install jq
brew install terraform
brew install helm
brew install linode-cli
```

You can install autocomplete for `Terraform CLI` using:

```sh
terraform -install-autocomplete
````

Login to Linode and Terraform via:

```sh
linode-cli login # Follow the prompts
terraform login # Follow the prompts
```
## Desired Workflow

Our aim is to get a `git` based workflow for our infrastructure deployment, a typical workflow would look like as following:

- Clone this template repository
- Perform the initial set of configuration changes
- Deploy the infrastructure to the provider (in our case Linode)
- Branch off for any changes 
- Deploy the branch and let Terraform cloud validate changes in a staging envirnonemtn
- All going well, lodge a pull request to the repository
- Merge it to the `main` branch for the changes to goto production

![workflow](https://mktg-content-api-hashicorp.vercel.app/api/assets?product=tutorials&version=main&asset=public%2Fimg%2Fterraform%2Fautomation%2Ftfc-gh-actions-workflow.png)

> Image courtesy of [Terraform](https://www.terraform.io/)

There's an initial setup required for each workspace on  Terraform cloud.

## Implementation

We are going to approach learning about the infrastructure setup in two steps, the first will be somewhat manual where you can see each cog working on it's own and then we will be able to automate the process.
### Querying Linode for Stackscripts

You can query Linode for stack scripts to automate teh deployment of various componet. This is largely a deprecated process as the preferred process is to deploy `pods` in a Kubernetes cluster.

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

Or `linode-cli stackscripts list --label="Docker One-Click"` for the Docker image.

> _Note_: you will be required to authenticate the cli once, before you can run this command using `linode-cli login`

## Getting a Linode token

With Linode's CLI setup you can get a token for Terraform Cloud using the following command. This will assign the newly generated tokent o a bash variable `linode-token`.

Our aim here is to handle secrets as securely as possible.

```zsh
➜  ~ linode_token=`linode-cli profile token-create --json --label="Terraform Cloud" | jq '.[0]["token"]'`
```

## Terraform Cloud


## Github


## Helm

```
 5278  helm search repo bitnami/redis
 5279  helm search repo bitnami/traefik
 5280  helm repo add traefik https://helm.traefik.io/traefik
 5281  helm repo update
 5650  helm search repo bitnami/postgres
 5652  helm search repo bitnami/postgres
 5653  helm install postgres bitnami postgres-ha
 5654  helm install postgres bitnami/postgres-ha
 5655  helm install postgres bitnami/bitnami/postgresql-ha
 5656  helm install postgres bitnami/postgresql-ha
 5663  helm repo add traefik https://helm.traefik.io/traefik
 5664  helm install traefik traefik/traefik
 ```

# Resources

The above guide has been put together from the knowledge available at these web resources. While most practices comes from Hashicorp's guide, there are pearls of wisdom from the team at Linode that have been thrown into the mix.

- [Linode Terraform guide](https://www.linode.com/docs/guides/how-to-build-your-infrastructure-using-terraform-and-linode/)
- [Hashicorp's guide to Github actions](https://learn.hashicorp.com/tutorials/terraform/github-actions)


## Terrform modules

Terraform also allows you to write modules, but there are selected usecase where you should be using Modules, this repository 

![module](https://www.terraform.io/img/docs/image2.png)
> Image courtesy of [Terraform](https://www.terraform.io/)
