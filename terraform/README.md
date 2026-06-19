This folder contains a simple Terraform example to build and run the project's Docker images on your local machine (using the Docker provider).

Purpose
- Demonstrate how Terraform can be used to provision local resources (Docker images & containers). This is useful for local testing and CI pipelines before pushing images to a registry.

Prerequisites
- Docker daemon running locally and accessible to your user
- Terraform v1.0+ installed and on PATH
- Optional: GNU make for convenience (not required)

Quick start
1. Change into this directory:

   cd terraform

2. Initialize Terraform (this creates a local state file in ./terraform.tfstate):

   terraform init

3. Review plan:

   terraform plan

4. Apply (this will build images from the repo and create short-lived containers for smoke-testing):

   terraform apply

5. When done, destroy created resources:

   terraform destroy

Notes
- This example uses the `docker` Terraform provider and the `docker_image` resource to build images from the local repository. It stores state locally (file `terraform.tfstate`). For team usage, switch to a remote backend (S3, GCS, Terraform Cloud).
- To push images to a registry or create cloud-native resources (ECR, EKS), extend the configuration to use providers for the cloud platform and remote state.
