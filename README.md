# Terraform template for Linode

This repository is a reference template for Anomaly projects provisioning and managing infrastructure on Linode using Terraform. The stack aims to the standard environment for our web based projects. 

A typical web project at Anomaly features:
- Python 3.x based APIs
- Workers managed using Celery
- Postgres based backend
- Redis for managing queues
- Traefik as a reverse proxy
- S3 compatible object stores to deliver the SPA
- Additionally provision an Object store for the application to store user (e.g images, data) or application (PDF reports, data exports, etc) generated content

Each server side component e.g API, worker, is containerised using Docker.

We assume the use of Terraform Cloud to preserve the state of the infrastructure.

This template will provision the following:
- A Kubernetes based cluster to run the Docker containers
- Managed Postgres database cluster (currently in beta)
- Object stores for the SPA and user generated content
- DNS records for Linode to manage the application (includes MX records, pointers to other services like Netlify for the web site)

Additionally we provide:
- Examples of scaling the infrastructure up and down
- Specifically allocating resources for the API, workers to make proper use of the resources
- Provisioning QA and Production environments
- Teardown examples

# License
Content of this repository are licensed under the Apache 2.0 license.