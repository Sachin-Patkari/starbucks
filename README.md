# ☕ Starbucks – Automated CI/CD Pipeline on AWS EKS

A **production-grade Node.js web application** demonstrating **complete DevOps automation** using **Jenkins CI/CD**, **Docker**, **Kubernetes (EKS)**, **Terraform**, and **Ansible** — deployed entirely on **AWS Cloud**.

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Project Structure](#-project-structure)
- [Setup Guide](#-setup-guide)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Deployment](#-deployment)
- [Monitoring & Security](#-monitoring--security)
- [Troubleshooting](#-troubleshooting)
- [Cost Management](#-cost-management)
- [Contributing](#-contributing)
- [Author](#-author)

---

## 🚀 Overview

This project showcases a **fully automated CI/CD DevOps pipeline** that takes code from development to production on **AWS EKS**.

### 🔑 Highlights

- **Infrastructure as Code (IaC)** – Managed by Terraform  
- **Configuration Management** – Automated using Ansible  
- **CI/CD Automation** – Jenkins pipeline triggered via GitHub webhook  
- **Containerization** – Using Docker  
- **Orchestration** – On Kubernetes (EKS)  
- **Security Scanning** – Multi-stage scanning with SonarQube, OWASP, Trivy, and Docker Scout  
- **Continuous Delivery** – Automatic deployment on successful builds  

---

## 🏗 Architecture
```bash

┌────────────────────────────┐
│ Developer │
│ (Code Push to GitHub) │
└──────────────┬─────────────┘
│
▼
┌────────────────────────────┐
│ Jenkins CI/CD │
│ - SonarQube Analysis │
│ - OWASP & Trivy Scans │
│ - Docker Build & Push │
│ - Deploy to EKS Cluster │
└──────────────┬─────────────┘
│
▼
┌────────────────────────────┐
│ DockerHub │
│ (Container Image Registry) │
└──────────────┬─────────────┘
│
▼
┌────────────────────────────┐
│ AWS EKS Cluster │
│ - Pods & Services │
│ - LoadBalancer Access │
└──────────────┬─────────────┘
▼
🌐 End Users

```
---

## 📁 Project Structure

```bash

starbucks/
├── ansible/
│ ├── inventory.ini # Jenkins server inventory
│ └── playbook.yml # Ansible automation script
│
├── infra/
│ └── main.tf # Terraform script for AWS setup
│
├── k8s/
│ ├── deployment.yaml # Kubernetes Deployment
│ └── service.yaml # Kubernetes Service
│
├── Jenkinsfile # Jenkins CI/CD pipeline
├── Dockerfile # Docker image instructions
├── package.json # Node.js dependencies
├── index.js # Application entry point
└── README.md # Project documentation
---
```

## 🚀 Setup Guide

### 🧩 1️⃣ Infrastructure Setup (Terraform)

```bash
cd infra
terraform init
terraform plan
terraform apply -auto-approve
This provisions:

VPC, Subnets, IGW, NAT Gateway

Security Groups

EKS Cluster and Node Groups

Verify setup:

bash
Copy code
aws eks update-kubeconfig --region ap-south-1 --name starbucks-eks
kubectl get nodes
```

⚙️ 2️⃣ Jenkins Configuration (Ansible)

```bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
This installs:

Jenkins, Docker, Terraform, Kubectl, AWS CLI

Sonar Scanner, OWASP Dependency Check

Access Jenkins at:
👉 http://<JENKINS_PUBLIC_IP>:8080
```

🔐 3️⃣ Configure Jenkins Credentials

```bash
Go to:
Manage Jenkins → Credentials → Global Credentials

Add the following credentials:

ID	Type	Description
github-creds	Username/Password	GitHub Access
docker	Username/Password	DockerHub Access
aws-cred	AWS Credentials	Access Key ID & Secret
Sonar-token	Secret Text	SonarQube Token
```

### Access the application:
```bash
kubectl get svc starbucks-service
Example Output:
EXTERNAL-IP: a1234b5678.elb.ap-south-1.amazonaws.com
🌐 Visit → http://<EXTERNAL-IP>:3000
```

### 🔒 Monitoring & Security
   Implemented Layers

   Code: SonarQube

   Dependencies: OWASP

   Filesystem: Trivy

   Container: Docker Scout

   Network: AWS Security Groups

   Access: IAM & RBAC


### 🧰 Troubleshooting

🧩 EKS Nodes Not Joining
```bash
kubectl get nodes
kubectl get configmap aws-auth -n kube-system -o yaml
```

🐳 Docker Image Pull Error
```bash
docker pull sachinpatkari/starbucks:<BUILD_NUMBER>
kubectl describe pod <pod-name>
```

🕸 LoadBalancer Pending
```bash
Check subnet tags

Verify Security Groups

Inspect events:

kubectl describe svc starbucks-service
```

### 💰 Cost Management

To avoid AWS charges:
```bash
cd infra
terraform destroy -auto-approve
#If destroy fails, delete resources manually in this order:

Load Balancer

NAT Gateway & Elastic IP

ENIs (Network Interfaces)

EKS Cluster

VPC

```

### 💡 Cost Saving Tips
```bash

Use small EC2 instances like t3.medium

Enable auto-scaling

Shut down resources after testing

Resource	Approx. Cost
EKS Control Plane	$72
2x Worker Nodes	$60
NAT Gateway	$32
Load Balancer	$16
Total	~$180/month
```

👤 Author
👨‍💻 Sachin Patkari

💼 DevOps Engineer | Cloud Enthusiast

🌐 AWS | Jenkins | Docker | Kubernetes | Terraform

📧 sachinx2003x@gmail.com

🔗 LinkedIn - https://www.linkedin.com/in/sachin-patkari-a863042b7/

🐙 GitHub - https://github.com/Sachin-Patkari

