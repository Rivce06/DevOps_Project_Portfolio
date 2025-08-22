 # 🚀 Terraform AWS Dockerized NGINX Project

This project was born as a hands-on exercise to practice Infrastructure as Code (IaC) and CI/CD automation.

The goal: **provision AWS infrastructure with Terraform, deploy a Dockerized NGINX web server on EC2, and fully automate it through GitHub Actions.**

It evolved into more than just a deployment — it became a journey of solving real-world problems with state management, pipelines, and automation.

## 🗺️ Final Architecture

**Custom VPC** with subnet, route table, and internet gateway

**Security group** allowing SSH + HTTP

**EC2 instance** running Dockerized NGINX

**Terraform remote backend** with S3 + DynamoDB

**GitHub Actions pipeline** for CI/CD automation

## 🗺️ Architecture Diagram

<img src="https://github.com/Rivce06/Bucket/blob/main/Diagrams/Untitled%20Diagram.drawio.png" />


## 📂 Project Structure
```
DevOps_Project_Portfolio/
├── .github/workflows/           # GitHub Actions CI/CD for Terraform
│   └── terraform.yaml
├── aws-terraform-docker-project/  # Main Terraform infrastructure
│   ├── backend.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── bootstrap/                   # Terraform bootstrap (S3 + DynamoDB)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── .gitignore
└── README.md
```
## ⚙️ How to Use
### 1. Bootstrap Terraform Backend

Create the S3 bucket and DynamoDB table to store state:
```
cd bootstrap
terraform init
terraform plan
terraform apply
```
### 2. Deploy Main Infrastructure with GitHub Actions

Push to `main` branch → triggers CI/CD pipeline.

Pipeline runs: `terraform fmt`, `init`, `validate`, `plan`, `apply`.

Secrets required in GitHub repo:

`AWS_ACCESS_KEY_ID`

`AWS_SECRET_ACCESS_KEY`

Result:

AWS VPC, subnet, route table, security group.

EC2 instance running Dockerized NGINX.

### 3. Access the Application

Visit the EC2 public IP over `http://` to see the NGINX default page.

## 🐳 What’s Running on EC2

The EC2 instance automatically installs Docker and starts NGINX:
```
#!/bin/bash
yum update -y
amazon-linux-extras enable docker
amazon-linux-extras install -y docker
systemctl enable docker
systemctl start docker
docker run -d -p 80:80 nginx
```
---

## 📘 Key Lessons Learned

Throughout this project, I encountered multiple real-world problems. Here are the **top three learnings** that shaped the project:

**1. Remote State Management Matters**

- **Problem**: Terraform `destroy` failed because GitHub Actions runners are ephemeral and the local state was lost.

- **Solution**: Configured S3 for remote state storage with DynamoDB for locking.

- **Why it matters**: Without persistent state, Terraform cannot track resources, leading to orphaned infrastructure and unexpected AWS charges.

**2. CI/CD Structure is Critical**

- **Problem**: GitHub Actions didn’t run because workflows weren’t in the correct directory.

- **Solution**: Moved `.github/workflows/` to repo root.

- **Why it matters**: Small structural mistakes can silently break automation.

- **3. Automation Must Verify Service Readiness**

- **Problem**: Docker didn’t start correctly on EC2, so NGINX never launched.

- **Solution**: Updated user_data script to enable/start Docker before running the container.

- **Why it matters**: Automation scripts must ensure services are running before moving on, otherwise failures remain hidden until manual checks.

👉 For a complete breakdown of all challenges (formatting issues, misreferenced resources, large files, HTTPS confusion, Codespaces secrets, etc.), see <a href="https://github.com/Rivce06/DevOps_Project_Portfolio/blob/main/aws-terraform-docker-project/LESSONS.md">🔗 LESSONS.md</a>

---
## ✅ Final Validation

- Verified that Terraform state was stored in S3 with DynamoDB lock.

- Triggered `terraform destroy` through GitHub Actions.

- Manually audited AWS account to confirm no resources left running.

This confirmed that the workflow works end-to-end and safely cleans up resources.

## 🛠️ Technologies Used

**Terraform** → IaC for AWS

**AWS (EC2, VPC, S3, DynamoDB)** → compute, networking, state backend

**Docker** → containerized NGINX web server

**GitHub Actions** → CI/CD automation

## 💡 Reflection

This project was more than spinning up an NGINX container.
It taught me:

- **Why remote state management is non-negotiable in Terraform.**

- **How CI/CD pipelines depend on correct repo structure and formatting.**

- **How small oversights (service readiness, HTTPS vs HTTP) can cause big delays.**

Most importantly: **documenting problems and solutions was as valuable as writing the code itself.**

---
```
📎 License

MIT — Feel free to use and modify!
```
---
