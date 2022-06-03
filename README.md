# Terraform templates for Linode

This repository is a reference template for Anomaly projects provisioning and managing infrastructure on Linode using Terraform. The stack aims to the standard environment for our web based projects.

As Linode move services like Databases to a managed product. We will evolve this template to use those services. As a small team Anomaly wishes to leverage off the strengths of providers Linode and have them do as much of the heavy lifting as possible.

Our template provides a VCS (centred around branches and pull requests) based workflow.
## Typical Requirements

A typical web project at Anomaly features:

- Python 3.9+ based APIs
- Workers managed using Celery
- Postgres based backend
- Redis for managing queues
- Traefik as a reverse proxy
- S3 compatible object stores to deliver the SPA
- Additionally provision an Object store for the application to store user (e.g images, data) or application (PDF reports, data exports, etc) generated content
- SSL certificates provisioned via Let's Encrypt

Each server side component e.g API, worker, is containerised using Docker.

We assume the use of Terraform Cloud to preserve the state of the infrastructure.

This template will provision the following:
- A dual node (soon to be migrated to a hosted database + a Linode) based deployment for Docker based applications or a Kubernetes based cluster to run the Docker containers.
- Managed Postgres database cluster (currently in beta)
- Object stores for the SPA and user generated content
- DNS records for Linode to manage the application (includes MX records, pointers to other services like Netlify for the web site)

Additionally we provide:

- Examples of scaling the infrastructure up and down
- Specifically allocating resources for the API, workers to make proper use of the resources
- Provisioning QA and Production environments
- Teardown examples

## Secrets management

We will also explore using Hashicorp's Vault product offering to manage:
- API Keys
- Database secrets
- Security seeds for the application
- Cycle secrets and distribute it to the applications

# Resources

Useful repositories:
- https://github.com/linode/linode-cloud-controller-manager


Video tutorials:
- https://www.youtube.com/watch?v=JGtJj_nAA2s

# License
Content of this repository are licensed under the Apache 2.0 license.