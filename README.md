Project Overview

This project is designed to deploy a Node.js application with a MongoDB database on AWS using Terraform, Helm, and ArgoCD. The GitHub Actions CI pipeline builds the Node.js Docker image, tests it, tags it with the commit SHA, updates the Helm chart's values.yaml with the new image tag, and pushes the image to Amazon ECR. ArgoCD is used for continuous delivery, managing Kubernetes deployments from the Helm chart.

Project Structure
graphql
Copy
Edit
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
This folder contains the Node.js application that interacts with a MongoDB database. The Dockerfile is used to build the Docker image for the app, and index.js is the main entry file. The package.json defines the application's dependencies.

MongoDB (db)
The db folder contains the MongoDB initialization script, init-mongo.js, which is used to set up the database.

Helm Chart (fruits)
The fruits folder contains a Helm chart for deploying the Node.js application and MongoDB on Kubernetes. It includes Kubernetes manifest templates for:

deployment-app.yaml: Deploys the Node.js application
deployment-mongo.yaml: Deploys MongoDB
configmap.yaml: Configures environment variables or configuration for the app
ingress.yaml: Defines ingress resources for external access to the app
The values.yaml file contains the configuration for the Helm chart, including the image tag for the Node.js app. This tag will be updated by the CI pipeline with the latest commit SHA.

Terraform (terraform)
The terraform folder contains Terraform configuration files to provision the AWS infrastructure required for the project:

VPC, EKS, ACM, ECR, IAM, and Ingress NGINX resources are defined here.
The terraform.tfvars file contains variables used in the Terraform configurations.
ArgoCD (argocd)
The argocd/application.yaml file is an ArgoCD application definition that links the Helm chart (fruits) with Kubernetes. It monitors the values.yaml file for updates to the Node.js Docker image tag and triggers redeployment in Kubernetes.

CI/CD Pipeline (GitHub Actions)
The CI pipeline is configured in GitHub Actions and performs the following steps:

Build and Test: The Node.js Docker image is built, and the app is tested.
Tagging: The image is tagged with the commit SHA.
Helm Chart Update: The values.yaml file in the fruits Helm chart is updated with the new image tag.
Push to ECR: The Docker image is pushed to the Amazon Elastic Container Registry (ECR).