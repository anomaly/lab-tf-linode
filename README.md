# Terraform templates for Linode

This repository is a reference template for Anomaly projects provisioning and managing infrastructure on Linode using Terraform. The stack aims to the standard environment for our web based projects.

As Linode move services like Databases to a managed product. We will evolve this template to use those services. As a small team Anomaly wishes to leverage off the strengths of providers Linode and have them do as much of the heavy lifting as possible.

Our template provides a VCS (centred around branches and pull requests) based workflow.

While this `README` outlines what we deliver, our [GUIDE](GUIDE.md) offers a step-by-step walk through of using the template and deploying your own apps.
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
- [ ] Traefik as a reverse proxy with rules to deliver the application 
- [ ] Certbot or the likes to provision SSL certificates 
- [ ] Provisioning `pods` from a private Docker repository (typical use case for deployments)
- [X] Managed Postgres database cluster (currently in beta) or a Postgres HA cluster via K8s.
- [X] Object stores for the SPA and user generated content
- [ ] DNS records for Linode to manage the application (includes MX records, pointers to other services like Netlify for the web site)
- [ ] Use Terraform cloud as the backend for state and variables

Additionally we provide:

- [ ] Examples of scaling the infrastructure up and down
- [ ] Specifically allocating resources for the API, workers to make proper use of the resources
- [ ] Provisioning QA and Production environments
- [ ] Teardown examples

## Secrets management

We will also explore using Kubernetes secrets and alternatively Hashicorp's Vault product offering to manage:
- [X] API Keys
- [X] Database secrets
- [X] Security seeds for the application
- [ ] Cycle secrets and distribute it to the applications

As resources are provisioned we will proxy the secrets to a managed services or the K8s cluster.

## Mock application

The setup uses a mock application to test the infrastructure. This application is __highly insecure__ and should not be used in production. The mock application is a Python endpoint designed to prove that a real life app will:

- Have access to the secrets for the Object store
- Have access to the details of the Redis cluster
- Have access to the secrets for the Postgres cluster
- Be able to serve a SPA which can communicate back to the Python server

The web page generated by this mock application displays these on the landing page. This is obviously for demonstration purposes only, in a real life scenario these credentials are used internally by the server Pods.

If you are interesting in building server side applications using Python please see [lab-python-server](https://github.com/anomaly/lab-python-server).

# Resources

Useful repositories:
- https://github.com/linode/linode-cloud-controller-manager


Video tutorials:
- https://www.youtube.com/watch?v=JGtJj_nAA2s

# License
Content of this repository are licensed under the Apache 2.0 license.