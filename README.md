# Terraform templates for Linode

This repository is a reference template for Anomaly projects provisioning and managing infrastructure on Linode using Terraform. The stack aims to the standard environment for our web based projects.

As Linode move services like Databases to a managed product. We will evolve this template to use those services. As a small team Anomaly wishes to leverage off the strengths of providers Linode and have them do as much of the heavy lifting as possible.

Our template provides a VCS (centred around branches and pull requests) based workflow.
## Typical Requirements

A typical web project at Anomaly features:

- Python 3.10+ based APIs
- Workers managed using Celery
- Postgres based backend
- Redis for managing queues
- Traefik as a reverse proxy (via K8s that in turn uses Load balancers)
- S3 compatible object stores to deliver the SPA
- Additionally provision an Object store for the application to store user (e.g images, data) or application (PDF reports, data exports, etc) generated content
- SSL certificates provisioned via Let's Encrypt

Each [server side component](https://github.com/anomaly/lab-python-server) e.g API, worker, is containerised using Docker.

We assume the use of Terraform Cloud to preserve the state of the infrastructure.

This template will provision the following:
- [X] A K8s cluster that will run the application and every other component not available as a managed service e.g Redis
- [ ] Managed Postgres database cluster (currently in beta) or a Postgres HA cluster via K8s.
- [X] Object stores for the SPA and user generated content
- [ ] DNS records for Linode to manage the application (includes MX records, pointers to other services like Netlify for the web site)
- [ ] Use Terraform cloud as the backend for state and variables

Additionally we provide:

- [ ] Examples of scaling the infrastructure up and down
- [ ] Specifically allocating resources for the API, workers to make proper use of the resources
- [ ] Provisioning QA and Production environments
- [ ] Teardown examples

## Secrets management

We will also explore using Hashicorp's Vault product offering to manage:
- [ ] API Keys
- [ ] Database secrets
- [ ] Security seeds for the application
- [ ] Cycle secrets and distribute it to the applications

# Resources

Useful repositories:
- https://github.com/linode/linode-cloud-controller-manager


Video tutorials:
- https://www.youtube.com/watch?v=JGtJj_nAA2s

# License
Content of this repository are licensed under the Apache 2.0 license.