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

### Setup your Development Environment

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

## The Plan

This guide assumes that we are, automating infrastructure provisioning for a new project with the aim of being able to evolve or tear down environment as the requirements change. Our plan assumes that we will Terraform Cloud to run the jobs and then use Github Actions to trigger Terraform jobs.

- Provision secrets and setup Terraform Cloud
- Provision secrets and setup Github Actions



### Notes on Linode's official provider

A provider is a plugin that Terramform relies on to interact with the API of a cloud provider. Each provider adds a set of resource types and/or data sources that Terraform can manage. Linode provides an official verified provider via the [Terraform registry](https://registry.terraform.io/providers/linode/linode/latest).

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

## Step by step walk through

We are going to approach learning about the infrastructure setup in two steps, the first will be somewhat manual where you can see each cog working on it's own and then we will be able to automate the process.

The files are structures for logical reasons alone. Terraform will merge the contents of all files with the `.tf` extension. `terraform.vars` is the name of the default input variables file.

| File | Description |
--- | --- 
| main.cf | The main configuration file, this is where you will define your infrastructure |
| k8s.tf | The Kubernetes configuration file, this is where you will define your Kubernetes infrastructure |
| providers.tf | The provider configuration file, this is where you will define your providers e.g Linode + Kubernetes |
| variables.tf | The variables configuration file, this is where you will define your Terraform input variables |

### Understanding variables for Terraform

Input variables are defined in the `variables.tf` file. You must provide a value (unless a default is provided and you are happy with it) for each of these via either:

- defining it in the `terraforms.tfvars` file
- provide it as a an environment variable `export TF_VAR_token=70a1416a9.....d182041e1c6bd2c40eebd`
- via keyboard input when prompted by the Terraform CLI

The finished version of our setup will use Terraform Cloud to managed these.

### Getting a Linode token

With Linode's CLI setup you can get a token for Terraform Cloud using the following command. This will assign the newly generated tokent o a bash variable `linode-token`.

Our aim here is to handle secrets as securely as possible.

```zsh
➜  ~ linode_token=`linode-cli profile token-create --json --label="Terraform Cloud" | jq '.[0]["token"]'`
```

Linode's CLI can do everything that Linode has to offer. To create your Terraform configuraiton you will find the following commands handy:

| Command | Description |
--- | --- 
| `linode-cli regions list` | Lists all the regions that Linode operates in, you will require the `id` of the relevant region |
| `linode-cli linodes types` | Lists all the types of Linodes that are available, you will require the `id` of the relevant type |

> Setting TF_LOG=TRACE in your environment will enable tracing of Terraform commands.

### Provisioning a Kubernetes Cluster




```
export KUBE_VAR=`terraform output kubeconfig` && echo $KUBE_VAR | python -m base64 -d 
```

> The native macOS tools fails to decode base64 complaining about an illegal character which happens to be the quote marks.
### Provisioning our web application in the cluster


### Upgrade / Changing elements

### Teardown


## Moving services to managed products




---

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
