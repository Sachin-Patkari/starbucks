# ☕ Starbucks – Automated CI/CD Pipeline on AWS EKS

## 🚀 Overview
Starbucks is a Node.js-based web application that demonstrates a **fully automated CI/CD DevOps pipeline** using Jenkins, Docker, Kubernetes, and AWS cloud infrastructure.  
The application is deployed on **Amazon EKS (Elastic Kubernetes Service)**, provisioned using **Terraform** and configured using **Ansible**.

This project showcases complete DevOps automation — from infrastructure provisioning to deployment — following real-world industry practices.

---

## 🧱 Project Architecture

┌────────────────────────────┐
│ Developer │
│ (GitHub - Source Code) │
└──────────────┬─────────────┘
│ (git push)
▼
┌────────────────────────────┐
│ Jenkins EC2 │
│ CI/CD Pipeline Automation │
│ - SonarQube Analysis │
│ - OWASP Scan │
│ - Trivy Scan │
│ - Docker Build & Push │
│ - Deploy to EKS Cluster │
└──────────────┬─────────────┘
│
▼
┌────────────────────────────┐
│ DockerHub │
│ Stores versioned images │
└──────────────┬─────────────┘
│
▼
┌────────────────────────────┐
│ AWS EKS Cluster │
│ (Pods, Services, LoadBalancer)
└────────────────────────────┘

yaml
Copy code

---

## ⚙️ Technologies Used

| Category | Tools |
|-----------|-------|
| **Version Control** | Git, GitHub |
| **CI/CD Tool** | Jenkins |
| **Code Quality & Security** | SonarQube, OWASP Dependency Check, Trivy, Docker Scout |
| **Containerization** | Docker |
| **Container Registry** | DockerHub |
| **Orchestration** | Kubernetes (EKS) |
| **Infrastructure as Code** | Terraform |
| **Configuration Management** | Ansible |
| **Cloud Provider** | AWS (VPC, EC2, EKS, IAM, Subnets, etc.) |
| **Monitoring (optional)** | Prometheus, Grafana |

---

## 📁 Project Structure

starbucks/
│
├── ansible/
│ ├── inventory.ini # Jenkins server IP
│ └── playbook.yml # Installs Jenkins, Docker, and dependencies
│
├── infra/
│ └── main.tf # Terraform code for creating VPC, EKS, subnets, etc.
│
├── k8s/
│ ├── deployment.yaml # Kubernetes deployment (with IMAGE_PLACEHOLDER)
│ └── service.yaml # Kubernetes LoadBalancer service
│
├── Jenkinsfile # Full CI/CD pipeline configuration
├── Dockerfile # Defines Node.js app image build
├── package.json # Node.js dependencies
├── index.js # Main app source code
└── README.md # Documentation

yaml
Copy code

---

## 🧩 CI/CD Pipeline Stages (Jenkinsfile)

| Stage | Description |
|--------|-------------|
| **Clean Workspace** | Ensures a clean Jenkins environment |
| **Git Checkout** | Pulls latest code from GitHub |
| **SonarQube Analysis** | Runs static code analysis |
| **Quality Gate** | Checks code quality threshold |
| **Install NPM Dependencies** | Installs Node.js dependencies |
| **OWASP Dependency Check** | Scans open-source libraries for vulnerabilities |
| **Trivy File Scan** | Scans local files for vulnerabilities and secrets |
| **Build Docker Image** | Builds and tags image with `BUILD_NUMBER` |
| **Docker Scout Image** | Analyzes Docker image for vulnerabilities |
| **Push to DockerHub** | Pushes the image to DockerHub registry |
| **Apply aws-auth** | Grants Jenkins permissions on EKS cluster |
| **Deploy to EKS** | Deploys latest image on Kubernetes cluster |

---

## 🌐 Deployment Flow

1. **Developer makes code changes** → commits & pushes to GitHub.  
2. **GitHub Webhook triggers Jenkins** pipeline automatically.  
3. Jenkins runs:
   - SonarQube analysis
   - Vulnerability scans (OWASP, Trivy, Docker Scout)
   - Builds and pushes Docker image to DockerHub
   - Deploys updated version to AWS EKS  
4. **Kubernetes** pulls the latest Docker image and updates pods automatically.  
5. The **LoadBalancer service** exposes the app publicly.

---

## 🧰 Infrastructure Setup (Terraform)

1. Create all infrastructure:
   ```bash
   cd infra
   terraform init
   terraform apply
Terraform provisions:

VPC, subnets, Internet Gateway

NAT Gateway

Security groups

EKS cluster

Node groups

Verify cluster:

bash
Copy code
aws eks update-kubeconfig --region ap-south-1 --name starbucks-eks
kubectl get nodes
⚙️ Jenkins Setup (via Ansible)
Run Ansible playbook:

bash
Copy code
cd ansible
ansible-playbook -i inventory.ini playbook.yml
Installs:

Jenkins

Docker

AWS CLI

Kubectl

Terraform

Sonar Scanner

Configure credentials:

GitHub (github-creds)

DockerHub (docker)

AWS (aws-cred)

SonarQube Token (Sonar-token)

🐳 Kubernetes Deployment
Deployment file (k8s/deployment.yaml):

yaml
Copy code
apiVersion: apps/v1
kind: Deployment
metadata:
  name: starbucks-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: starbucks
  template:
    metadata:
      labels:
        app: starbucks
    spec:
      containers:
        - name: starbucks
          image: IMAGE_PLACEHOLDER
          ports:
            - containerPort: 3000
Jenkins replaces the image dynamically:

bash
Copy code
sed "s|IMAGE_PLACEHOLDER|sachinpatkari/starbucks:${BUILD_NUMBER}|g" k8s/deployment.yaml > k8s/deployment-final.yaml
kubectl apply -f k8s/deployment-final.yaml
💻 Running the Project Again
If you’ve destroyed the infra:

bash
Copy code
cd infra
terraform apply          # Recreate infrastructure
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml   # Reinstall Jenkins
Then just:

Trigger your Jenkins pipeline (or push to GitHub).

Jenkins automatically builds, scans, pushes, and deploys.

💰 Cost Management (Important)
To avoid AWS billing:

Delete resources after use:

bash
Copy code
terraform destroy
If errors occur, manually delete:

Load balancers

NAT gateways

Elastic IPs

Network interfaces

Subnets

Internet Gateway

Finally → VPC

📸 Screenshots (optional)
You can include:

Jenkins pipeline stages

SonarQube dashboard

DockerHub image

AWS EKS pods (kubectl get pods)

Live application URL

🏁 Conclusion
This project demonstrates end-to-end DevOps automation:

Infrastructure as Code (Terraform)

Configuration Management (Ansible)

Continuous Integration (Jenkins)

Continuous Deployment (EKS + Docker)

Security & Quality Gates (SonarQube, Trivy, OWASP)

It represents a production-grade CI/CD pipeline used in real organizations.

👤 Author
Sachin Patkari
💼 DevOps Engineer | Cloud Enthusiast | AWS | Jenkins | Docker | Kubernetes