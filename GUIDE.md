# Terraform guide

The aim of this guide is not to reiterate what is found in Terraform or Github's documentation but rather to encapsulate the workflow that we have established at Anomaly. The guide will cover a few core concepts and followed by steps that will help you get a project setup quickly.

Whilst the defined stack should work for most applications at Anomaly, please review the resources required by your application.

# Ingredients

The guide assumes the availability of the following tools:

- Terraform 1.1.x or higher
- Linode CLI 5.16.x or higher, this is rarely used to query Stackscript and may be redundant as we moved to managed databases
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

# Notes on Linode's official provider

A provider is 

# Setup

## Terraform Cloud


## Github


# Workflow

You will require to use the following features 

![https://mktg-content-api-hashicorp.vercel.app/api/assets?product=tutorials&version=main&asset=public%2Fimg%2Fterraform%2Fautomation%2Ftfc-gh-actions-workflow.png][workflow]


# Resources

The above guide has been put together from the knowledge available at these web resources. While most practices comes from Hashicorp's guide, there are pearls of wisdom from the team at Linode that have been thrown into the mix.

- [Linode Terraform guide](https://www.linode.com/docs/guides/how-to-build-your-infrastructure-using-terraform-and-linode/)
- [Hashicorp's guide to Github actions](https://learn.hashicorp.com/tutorials/terraform/github-actions)