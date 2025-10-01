```mermaid
flowchart TD
    A[Developer Push] --> B[GitHub Repo]
    B --> C[Jenkins Pipeline]
    C --> D[SonarQube Analysis]
    C --> E[Trivy + OWASP Scan]
    C --> F[Docker Build + DockerHub Push]
    F --> G[Kubernetes Deployment on EKS]
    G --> H[LoadBalancer Service]
    H --> I[Starbucks App ☕]


# ☕ Starbucks DevSecOps Project

This project is a **fully automated CI/CD pipeline** that builds, scans, packages, and deploys a Starbucks clone application to **AWS EKS** using **Jenkins, Docker, Kubernetes, SonarQube, Trivy, OWASP, Docker Scout, Ansible, and Terraform**.

---

## 🚀 Project Flow

1. **Infrastructure Setup (Terraform + Ansible)**
   - Terraform provisions:
     - VPC, Subnets, Internet Gateway
     - EKS Cluster & Worker Nodes
     - Jenkins EC2 instance
   - Ansible installs:
     - Jenkins
     - Docker
     - Trivy
     - SonarQube (if required)

2. **CI/CD Pipeline (Jenkinsfile)**
   - Cleans workspace
   - Clones source code from GitHub
   - Runs **SonarQube** static code analysis
   - Waits for **Sonar Quality Gate**
   - Installs **npm dependencies**
   - Runs **OWASP Dependency Check**
   - Runs **Trivy File System Scan**
   - Builds Docker image of the app
   - Runs **Docker Scout** (quickview, CVEs, recommendations)
   - Pushes Docker image to **DockerHub**
   - Updates Kubernetes manifests (`deployment.yaml` & `service.yaml`) with new image tag
   - Deploys to **AWS EKS**
   - Verifies rollout

3. **Kubernetes Deployment**
   - `deployment.yaml` → Deploys app containers
   - `service.yaml` → Exposes app using AWS LoadBalancer

---

## 🛠 Tools & Technologies

- **Infrastructure:** Terraform, Ansible, AWS (EC2, VPC, EKS, IAM, ELB)
- **CI/CD:** Jenkins
- **Code Analysis:** SonarQube
- **Security Scanning:** Trivy, OWASP Dependency-Check, Docker Scout
- **Containerization:** Docker, DockerHub
- **Orchestration:** Kubernetes (EKS)

---

## 📂 Project Structure

starbucks/
├── ansible/
│ ├── inventory.ini
│ └── playbook.yml
├── infra/
│ └── main.tf
├── k8s/
│ ├── deployment.yaml
│ └── service.yaml
├── Jenkinsfile
└── src/ (app code, e.g., index.js, package.json)

yaml
Copy code

---

## ⚡ Setup Instructions

### 1️⃣ Provision Infrastructure
```bash
cd infra/
terraform init
terraform apply -auto-approve
2️⃣ Configure Jenkins Server
bash
Copy code
cd ansible/
ansible-playbook -i inventory.ini playbook.yml
3️⃣ Run Jenkins Pipeline
Access Jenkins → Create Pipeline job

Use project Jenkinsfile

Trigger build manually or via GitHub webhook

4️⃣ Verify Deployment
bash
Copy code
kubectl get pods
kubectl get svc
Copy EXTERNAL-IP of starbucks-service

Open in browser → App is live 🎉

🧹 Teardown (Avoid AWS Costs)
When done, destroy resources:

bash
Copy code
cd infra/
terraform destroy -auto-approve
Also manually check & delete:

Load Balancers (ELB/ALB)

NAT Gateways

Elastic IPs

Orphans ENIs

✅ Features
Automated CI/CD pipeline

Static code analysis with SonarQube

Dependency & vulnerability scans (OWASP, Trivy, Docker Scout)

Containerized deployment with Docker

Infrastructure-as-Code with Terraform

Config management with Ansible

Kubernetes-based deployment (EKS)