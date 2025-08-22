# 🚀 Terraform AWS Dockerized NGINX Project

This project automates the provisioning of a simple AWS infrastructure using Terraform, and manages deployments using GitHub Actions CI/CD. The infrastructure includes an EC2 instance running a Dockerized NGINX container, inside a custom VPC with networking components. It uses remote state management with S3 and DynamoDB for team-safe workflows.

---

📂 Project Structure
```
DevOps_Project_Portfolio/
├── .github/workflows/           # GitHub Actions CI/CD for Terraform
│   └── terraform.yaml
├── aws-terraform-docker-project/  # Main Terraform infrastructure
│   ├── backend.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md                # This file
├── bootstrap/                   # Terraform bootstrap (S3 + DynamoDB)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── .gitignore
└── README.md                    
```
## 🧱 What This Project Does

### Bootstraps Terraform state management:

- Creates an S3 bucket to store Terraform .tfstate files

- Creates a DynamoDB table for state locking

### Provisions AWS infrastructure:

- A custom VPC

- Subnet, Internet Gateway, Route Table

- Security Group (SSH + HTTP)

- EC2 Instance with Docker + NGINX

### Automates deployments using GitHub Actions:

#### On push to main, runs:

`terraform fmt`

`terraform init`

`terraform validate`

`terraform plan`

`terraform apply`

---

🗺️ Architecture Diagram

---


## ⚙️ Step-by-Step Usage
### 1. 🏗️ Bootstrap the Terraform Backend

Before deploying the infrastructure, we need a place to store the remote state.
```
cd bootstrap
```
```
terraform init
```
```
terraform plan
```
```
terraform apply
```


### This will:

- Create an S3 bucket (e.g., andresr-devops-20250821)

- Create a DynamoDB table (e.g., terraform-locks)

#### These values should match your backend.tf configuration in the main project.

---
### 2. 🚀 Deploy Main Infrastructure with GitHub Actions CI/CD

Every time you `push` to **main**, GitHub Actions will:

- Checkout the code

- Set up Terraform

- Format check (`terraform fmt`)

`Initialize`, `validate`, and `plan`

- Apply changes to AWS

#### Workflow file: .github/workflows/terraform.yaml
```
on:
  push:
    branches: [ main ]
```

Make sure you’ve set these repository secrets in GitHub:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

#### Once the action is executed it will deploy:

- A VPC and public subnet

- An Internet Gateway

- A Route Table

- An EC2 instance running Dockerized NGINX

---
### 🐳 What’s Running on EC2?

Your EC2 instance runs a simple NGINX web server inside a Docker container. The user_data script installs Docker and launches the container automatically:
```
docker run -d -p 80:80 nginx
```

Accessible via the EC2's `public IP`.

### 🛠️ Technologies Used
#### Tool	Purpose:

- Terraform	Infrastructure as Code (IaC)

- AWS EC2	Host for NGINX container

- AWS S3	Remote backend for tfstate

- AWS DynamoDB	State lock management

- Docker	Containerization

- GitHub Actions	CI/CD pipeline for automation

---
```
📎 License

MIT — Feel free to use and modify!
```
---
