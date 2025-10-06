# ☕ Starbucks – Automated CI/CD Pipeline on AWS EKS

A **production-grade Node.js web application** demonstrating complete **DevOps automation** using **Jenkins CI/CD**, **Docker**, **Kubernetes (EKS)**, **Terraform**, and **Ansible** — deployed entirely on **AWS Cloud**.

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

### 🔑 Highlights:
- **Infrastructure as Code (IaC)** – Managed by Terraform  
- **Configuration Management** – Automated using Ansible  
- **CI/CD Automation** – Jenkins pipeline triggered via GitHub webhook  
- **Containerization** – Using Docker  
- **Orchestration** – On Kubernetes (EKS)  
- **Security Scanning** – Multi-stage scanning with SonarQube, OWASP, Trivy, Docker Scout  
- **Continuous Delivery** – Auto-deployment on successful pipeline execution  

---

## 🏗 Architecture

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
│ (Image Registry Storage) │
└──────────────┬─────────────┘
│
▼
┌────────────────────────────┐
│ AWS EKS Cluster │
│ - Pods & Services │
│ - Load Balancer Access │
└──────────────┬─────────────┘
▼
🌐 End Users

markdown
Copy code

---

## 🛠 Tech Stack

### 🧱 Infrastructure & Cloud
- **AWS Services:** VPC, EC2, EKS, IAM, NAT Gateway, Internet Gateway  
- **IaC:** Terraform  
- **Configuration Management:** Ansible  

### ⚙️ CI/CD & DevOps
- **CI/CD Tool:** Jenkins  
- **Version Control:** Git, GitHub  
- **Container Platform:** Docker  
- **Registry:** DockerHub  
- **Orchestration:** Kubernetes (EKS)

### 🔒 Security & Quality
- **Code Quality:** SonarQube  
- **Vulnerability Scanning:** OWASP, Trivy, Docker Scout  
- **Quality Gates:** Automated via SonarQube  

### 🧩 Application
- **Runtime:** Node.js  
- **Package Manager:** npm  

---

## ✨ Features

✅ **Automated Infrastructure** – AWS setup via Terraform  
✅ **Zero-Touch Deployment** – Fully automated CI/CD via Jenkins  
✅ **Multi-Stage Security** – OWASP, Trivy & Docker Scout scans  
✅ **Quality Assurance** – Code analysis with SonarQube  
✅ **Scalable Architecture** – Kubernetes-managed pods and services  
✅ **GitOps Workflow** – Triggered automatically via GitHub push  
✅ **High Availability** – Load-balanced EKS deployment  
✅ **Immutable Infrastructure** – Container-based builds  

---

## 📦 Prerequisites

Before starting, ensure you have:

- 🧾 AWS Account with IAM permissions  
- ☁️ AWS CLI installed and configured  
- 🔧 Terraform ≥ v1.0  
- ⚙️ Ansible ≥ v2.9  
- 🐳 Docker installed  
- 🧭 kubectl installed  
- 🔐 DockerHub Account  
- 💻 Git installed  
- 🌐 Access to Jenkins & SonarQube  

---

## 📁 Project Structure

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

yaml
Copy code

---

## 🚀 Setup Guide

### 1️⃣ Infrastructure Setup (Terraform)
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
2️⃣ Jenkins Configuration (Ansible)
bash
Copy code
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
This installs:

Jenkins, Docker, Terraform, Kubectl, AWS CLI

Sonar Scanner, OWASP Dependency Check

Access Jenkins:

bash
Copy code
http://<JENKINS_PUBLIC_IP>:8080
3️⃣ Configure Jenkins Credentials
Go to:

Manage Jenkins → Credentials → Global Credentials

Add:

ID	Type	Description
github-creds	Username/Password	GitHub Access
docker	Username/Password	DockerHub Access
aws-cred	AWS Credentials	Access Key ID & Secret
Sonar-token	Secret Text	SonarQube Token

🔄 CI/CD Pipeline
Stage	Purpose	Tool
Clean Workspace	Clear Jenkins workspace	Jenkins
Git Checkout	Clone source code	Git
SonarQube Analysis	Code quality check	SonarQube
Quality Gate	Approve/Reject build	SonarQube
Install Dependencies	Install Node packages	npm
OWASP Check	Dependency vulnerability scan	OWASP
Trivy File Scan	Filesystem security scan	Trivy
Build Docker Image	Build tagged image	Docker
Docker Scout Scan	Image vulnerability check	Docker Scout
Push to Registry	Upload to DockerHub	Docker
Apply aws-auth	Update kube permissions	kubectl
Deploy to EKS	Rollout deployment	Kubernetes

🚢 Deployment
Rolling Update Strategy:

yaml
Copy code
replicas: 2
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
Access Application:
bash
Copy code
kubectl get svc starbucks-service
Output example:

arduino
Copy code
EXTERNAL-IP: a1234b5678.elb.ap-south-1.amazonaws.com
🌐 Visit → http://<EXTERNAL-IP>:3000

🔒 Monitoring & Security
Implemented Layers:

Code: SonarQube

Dependencies: OWASP

Filesystem: Trivy

Container: Docker Scout

Network: AWS Security Groups

Access: IAM & RBAC

Optional Monitoring:

bash
Copy code
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
kubectl port-forward svc/prometheus-grafana 3000:80
Access Grafana → http://localhost:3000

🧰 Troubleshooting
🧩 EKS Nodes Not Joining
bash
Copy code
kubectl get nodes
kubectl get configmap aws-auth -n kube-system -o yaml
🐳 Docker Image Pull Error
bash
Copy code
docker pull sachinpatkari/starbucks:<BUILD_NUMBER>
kubectl describe pod <pod-name>
🕸 LoadBalancer Pending
Check subnet tags

Verify Security Groups

Inspect events:

bash
Copy code
kubectl describe svc starbucks-service
💰 Cost Management
To avoid AWS charges:

bash
Copy code
cd infra
terraform destroy -auto-approve
If destroy fails:

Delete Load Balancer

Delete NAT Gateway & Elastic IP

Delete ENIs

Delete EKS Cluster

Delete VPC

💡 Tip:
Use small EC2 types like t3.medium and enable auto-scaling.

Estimated Monthly Cost (if running 24x7):

Resource	Approx. Cost
EKS Control Plane	$72
2x Worker Nodes	$60
NAT Gateway	$32
Load Balancer	$16
Total	~$180/month

🤝 Contributing
Contributions are welcome!

bash
Copy code
git checkout -b feature/AmazingFeature
git commit -m "Add new feature"
git push origin feature/AmazingFeature
Then open a Pull Request.

👤 Author
👨‍💻 Sachin Patkari
💼 DevOps Engineer | Cloud Enthusiast
🌐 AWS | Jenkins | Docker | Kubernetes | Terraform

📧 your.email@example.com
🔗 LinkedIn
🐙 GitHub

🙏 Acknowledgments
AWS Documentation

Kubernetes Docs

Jenkins Community

Terraform Guides

OWASP & Trivy

⭐ If you found this project helpful...
Give it a ⭐ on GitHub — it helps others discover it too!

🧡 Made with love by Sachin Patkari

yaml
Copy code

---

Would you like me to add **GitHub badges** (like “Built with Jenkins”, “Terraform IaC”, “AWS Certified”) at the top to make it look like a professional open-source project?