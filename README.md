# Cloud Native Infrastructure Blueprint

Welcome to the Cloud Native Infrastructure Blueprint! This repository provides a comprehensive, production-ready template for deploying, managing, and scaling cloud-native applications and infrastructure using modern DevOps and SRE best practices.

## Overview

This blueprint is designed for teams looking to accelerate their cloud adoption journey. It brings together proven patterns for infrastructure-as-code, Kubernetes, serverless, CI/CD, and observability, all organized in a modular and easy-to-navigate structure.

## Repository Structure

- **app/**  
  Contains a sample Python Flask application, including Dockerfile, configuration, and static assets. This is a reference app for demonstrating deployment patterns.

- **chart/**  
  Helm chart for deploying the sample application to Kubernetes clusters.

- **datasets/**  
  Example datasets for testing and demonstration.

- **schema/**  
  Database schema and migration scripts.

- **serverless/**  
  AWS Lambda function example, including code and requirements.

- **terraform/**  
  Infrastructure-as-code for AWS, organized by region and environment. Includes modules for VPC, EKS, RDS, ALB, ACM, S3, Route53, WAF, and more.

  - `eu-central-1/` and `global/`: Regional and global infrastructure definitions.
  - `modules/`: Reusable Terraform modules for common AWS resources.

- **.github/workflows/**  
  GitHub Actions workflow for CI/CD automation.

## Key Features

- **Modular Terraform**: Clean separation of concerns with reusable modules for networking, compute, storage, security, and more.
- **Kubernetes Ready**: Helm charts and manifests for easy deployment to EKS or any Kubernetes cluster.
- **Serverless Support**: Example Lambda function and infrastructure.
- **CI/CD**: GitHub Actions workflow for automated testing and deployment.
- **Best Practices**: Follows security, scalability, and cost-optimization guidelines.

## Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/nishantabanik/cloud-native-infra-blueprint.git
   cd cloud-native-infra-blueprint
   ```

2. **Review and customize Terraform variables**  
   Edit the relevant `terraform.tfvars` and `variables.tf` files in your target environment directory.

3. **Initialize and apply Terraform**

   ```bash
   cd terraform/eu-central-1
   terraform init
   terraform plan
   terraform apply
   ```

4. **Deploy the application**

   - Build and push the Docker image from `app/`
   - Use the Helm chart in `chart/` to deploy to your Kubernetes cluster

5. **Serverless Functions**
   - Review the Lambda example in `serverless/lambda/` and corresponding Terraform module.

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured
- Docker
- kubectl & Helm
- Python 3.x (for the sample app)

## Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements, bug fixes, or new features.

## License

This project is licensed under the MIT License.
