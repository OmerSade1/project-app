# Node.js Application with MongoDB on AWS using Terraform, Helm, and ArgoCD

## Project Overview

This project is designed to deploy a Node.js application with a MongoDB database on AWS using Terraform, Helm, and ArgoCD. The GitHub Actions CI pipeline builds the Node.js Docker image, tests it, tags it with the commit SHA, updates the Helm chart's `values.yaml` with the new image tag, and pushes the image to Amazon ECR. ArgoCD is used for continuous delivery, managing Kubernetes deployments from the Helm chart.

## Project Structure

```plaintext
graphql
├── app
│   ├── Dockerfile              # Dockerfile for building the Node.js application
│   ├── index.js               # Main entry file for the Node.js application
│   └── package.json           # NPM dependencies for the Node.js app
├── argocd
│   └── application.yaml       # ArgoCD application manifest for managing Kubernetes deployments
├── db
│   └── init-mongo.js          # MongoDB initialization script
├── docker-compose.yaml        # Local Docker Compose configuration for app and MongoDB
├── fruits
│   ├── Chart.yaml             # Helm chart metadata
│   ├── charts                 # Directory for Helm sub-charts (if any)
│   ├── templates              # Kubernetes manifest templates used by Helm
│   │   ├── configmap.yaml     # ConfigMap definition for the app
│   │   ├── deployment-app.yaml # Deployment definition for the Node.js app
│   │   ├── deployment-mongo.yaml # Deployment definition for MongoDB
│   │   └── ingress.yaml       # Ingress resource definition for the app
│   └── values.yaml            # Values file where Docker image tag for Node.js app is stored
├── terraform
│   ├── acm.tf                 # ACM configuration for SSL/TLS certificates
│   ├── argocd.tf              # Terraform configuration for ArgoCD setup
│   ├── backend.tf             # Terraform backend configuration for state storage
│   ├── ecr.tf                 # Terraform configuration for ECR repository
│   ├── eks.tf                 # Terraform configuration for Amazon EKS
│   ├── eks_blueprints_addons.tf # Terraform configuration for EKS addons
│   ├── iam-oidc.tf            # IAM OIDC setup for EKS
│   ├── ingress-nginx.tf       # Terraform configuration for NGINX ingress controller
│   ├── output.tf              # Output values for Terraform
│   ├── provider.tf            # Terraform provider configuration
│   ├── terraform.tfvars       # Terraform variable values
│   ├── variables.tf           # Terraform variables definition
│   └── vpc.tf                 # VPC configuration for AWS
└── terraform.tfstate          # Terraform state file

Key Components

Node.js Application (app)
Dockerfile: Builds the Docker image for the Node.js application.
index.js: Main entry file for the Node.js app.
package.json: Defines the app's dependencies.

MongoDB (db)
init-mongo.js: MongoDB initialization script used to set up the database.

Helm Chart (fruits)
The Helm chart contains the configuration for deploying both the Node.js app and MongoDB on Kubernetes.

deployment-app.yaml: Kubernetes deployment definition for the Node.js app.
deployment-mongo.yaml: Kubernetes deployment definition for MongoDB.
configmap.yaml: ConfigMap definition for app configuration or environment variables.
ingress.yaml: Ingress resource definition to expose the app to external traffic.
values.yaml: Configuration file containing the image tag for the Node.js app (updated by the CI pipeline).

Terraform (terraform)
Terraform is used to provision the required AWS infrastructure:

VPC: Defines the virtual private cloud for the project.
EKS: Sets up Amazon EKS for Kubernetes clusters.
ECR: Configures Amazon Elastic Container Registry for storing Docker images.
ACM: Sets up SSL/TLS certificates for secure communication.
NGINX Ingress: Configures NGINX Ingress controller for handling incoming traffic.
IAM: Sets up IAM OIDC for secure authentication with EKS.

ArgoCD (argocd)
application.yaml: ArgoCD application manifest that monitors the values.yaml file in the Helm chart and triggers redeployment in Kubernetes when the image tag is updated.

CI/CD Pipeline (GitHub Actions)
The CI pipeline builds, tests, and deploys the Node.js application with the following steps:

Build and Test: The Node.js Docker image is built and the app is tested.
Tagging: The image is tagged with the commit SHA.
Helm Chart Update: The values.yaml file in the Helm chart is updated with the new image tag.
Push to ECR: The Docker image is pushed to Amazon Elastic Container Registry (ECR).

## Usage

### Local Development with Docker Compose

To run the Node.js application and MongoDB locally using Docker Compose, follow these steps:

1. Ensure you have **Docker** and **Docker Compose** installed on your system.
2. Navigate to the root directory of the project.
3. Run the following command to start the Node.js app and MongoDB containers:

```bash
docker-compose up


## Terraform Setup

Terraform is used to provision AWS infrastructure, including VPC, EKS, ECR, ACM, NGINX Ingress, and IAM roles. Follow these steps to run Terraform.

### Prerequisites

1. **Install Terraform**: If you don't have Terraform installed, download it from the [official Terraform website](https://www.terraform.io/downloads.html).

2. **Configure AWS CLI**: Make sure you have the AWS CLI configured with the necessary credentials. To set up the AWS CLI, run the following command and follow the prompts:

    ```bash
    aws configure
    ```

### Steps to Run Terraform

#### 1. Initialize Terraform

Navigate to the `terraform` directory and initialize Terraform to download the required providers and modules.

```bash
cd terraform

terraform init

terraform plan

terraform apply

