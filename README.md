☕ Starbucks - Automated CI/CD Pipeline on AWS EKS
Show Image
Show Image
Show Image
Show Image
Show Image
A production-grade Node.js web application demonstrating complete DevOps automation with Jenkins CI/CD, Docker containerization, Kubernetes orchestration on AWS EKS, and infrastructure provisioned via Terraform and Ansible.
📋 Table of Contents

Overview
Architecture
Tech Stack
Features
Prerequisites
Project Structure
Setup Guide

Infrastructure Provisioning
Jenkins Configuration
Pipeline Setup


CI/CD Pipeline
Deployment
Monitoring & Security
Troubleshooting
Cost Management
Contributing
Author


🚀 Overview
This project showcases a fully automated CI/CD DevOps pipeline that takes code from development to production on AWS EKS. The application demonstrates real-world industry practices including:

Infrastructure as Code (IaC) using Terraform
Configuration Management with Ansible
Continuous Integration/Continuous Deployment via Jenkins
Container Orchestration on Kubernetes (EKS)
Security scanning at multiple stages
Automated quality gates and code analysis


🏗 Architecture
┌─────────────────────────────────────────────────────────────────┐
│                         Developer Workflow                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ git push
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                       GitHub Repository                          │
│                    (Source Code & Webhook)                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ triggers
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Jenkins CI/CD Server                        │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Pipeline Stages:                                        │  │
│  │  • Code Quality Analysis (SonarQube)                     │  │
│  │  • Security Scanning (OWASP, Trivy, Docker Scout)       │  │
│  │  • Docker Image Build                                    │  │
│  │  • Push to Container Registry                            │  │
│  │  • Deploy to EKS Cluster                                 │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                          DockerHub                               │
│              (Container Image Registry)                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             │ kubectl apply
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      AWS EKS Cluster                             │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  • Worker Nodes (EC2 Instances)                          │  │
│  │  • Application Pods (2 replicas)                         │  │
│  │  • LoadBalancer Service                                  │  │
│  │  • Auto-scaling & Self-healing                           │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
                      ┌──────────────┐
                      │   End Users  │
                      └──────────────┘

🛠 Tech Stack
Infrastructure & Cloud

AWS Services: VPC, EC2, EKS, IAM, NAT Gateway, Internet Gateway
IaC: Terraform
Configuration Management: Ansible

CI/CD & DevOps

CI/CD Tool: Jenkins
Version Control: Git, GitHub
Container Platform: Docker
Container Registry: DockerHub
Orchestration: Kubernetes (Amazon EKS)

Security & Quality

Code Quality: SonarQube
Vulnerability Scanning: OWASP Dependency Check, Trivy, Docker Scout
Quality Gates: Automated quality thresholds

Application

Runtime: Node.js
Package Manager: NPM


✨ Features

✅ Automated Infrastructure - Complete AWS infrastructure provisioned via Terraform
✅ Zero-Touch Deployment - Code push triggers automatic build and deployment
✅ Multi-Stage Security - Vulnerability scanning at code, dependency, and image levels
✅ Quality Assurance - Automated code quality checks with SonarQube
✅ Container Orchestration - Self-healing, auto-scaling Kubernetes deployments
✅ High Availability - Multi-replica deployment with LoadBalancer
✅ GitOps Workflow - Git as single source of truth
✅ Immutable Infrastructure - Container-based deployment strategy


📦 Prerequisites
Before starting, ensure you have:

AWS Account with appropriate permissions
AWS CLI configured with credentials
Terraform (v1.0+)
Ansible (v2.9+)
kubectl installed
Git installed
DockerHub Account
Domain/Access to set up Jenkins, SonarQube


📁 Project Structure
starbucks/
│
├── ansible/
│   ├── inventory.ini           # Jenkins server IP configuration
│   └── playbook.yml            # Ansible playbook for Jenkins setup
│
├── infra/
│   └── main.tf                 # Terraform configuration for AWS resources
│
├── k8s/
│   ├── deployment.yaml         # Kubernetes deployment manifest
│   └── service.yaml            # Kubernetes service (LoadBalancer)
│
├── src/                        # Application source code
│   ├── index.js               # Main Node.js application
│   └── ...                    # Additional application files
│
├── Jenkinsfile                 # Jenkins pipeline configuration
├── Dockerfile                  # Docker image build instructions
├── package.json               # Node.js dependencies
├── sonar-project.properties   # SonarQube configuration
└── README.md                  # This file

🚀 Setup Guide
1. Infrastructure Provisioning (Terraform)
Step 1: Clone the repository
bashgit clone https://github.com/yourusername/starbucks-cicd.git
cd starbucks-cicd
Step 2: Initialize and apply Terraform
bashcd infra
terraform init
terraform plan
terraform apply -auto-approve
This creates:

VPC with public and private subnets
Internet Gateway and NAT Gateway
Security Groups
EKS Cluster (Control Plane)
EKS Node Group (Worker Nodes)
IAM Roles and Policies

Step 3: Configure kubectl
bashaws eks update-kubeconfig --region ap-south-1 --name starbucks-eks
kubectl get nodes
Expected output: 2-3 worker nodes in Ready state

2. Jenkins Configuration (Ansible)
Step 1: Update inventory file
bashcd ../ansible
nano inventory.ini
Add your Jenkins server IP:
ini[jenkins_server]
<JENKINS_EC2_PUBLIC_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem
Step 2: Run Ansible playbook
bashansible-playbook -i inventory.ini playbook.yml
This installs:

Jenkins with required plugins
Docker and Docker Compose
AWS CLI
kubectl
Terraform
Sonar Scanner CLI
OWASP Dependency Check

Step 3: Access Jenkins
bash# Get initial admin password
ssh ubuntu@<JENKINS_IP>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
Navigate to: http://<JENKINS_IP>:8080

3. Pipeline Setup
Step 1: Configure Jenkins Credentials
Go to Manage Jenkins > Credentials > System > Global credentials
Add the following credentials:
IDTypeDescriptiongithub-credsUsername/PasswordGitHub credentialsdockerUsername/PasswordDockerHub credentialsaws-credSecret textAWS Access Key ID and SecretSonar-tokenSecret textSonarQube authentication token
Step 2: Configure SonarQube

Install and configure SonarQube server
Generate authentication token
Add token to Jenkins credentials as Sonar-token
Configure SonarQube server in Jenkins system settings

Step 3: Create Jenkins Pipeline

New Item → Pipeline
Name: Starbucks-CICD
Pipeline definition: Pipeline script from SCM
SCM: Git
Repository URL: Your GitHub repository
Credentials: github-creds
Branch: */main
Script Path: Jenkinsfile

Step 4: Configure GitHub Webhook
In your GitHub repository:

Settings → Webhooks → Add webhook
Payload URL: http://<JENKINS_IP>:8080/github-webhook/
Content type: application/json
Events: Just the push event


🔄 CI/CD Pipeline
The Jenkins pipeline consists of the following stages:
StagePurposeToolsClean WorkspaceEnsures clean build environmentJenkinsGit CheckoutFetches latest code from repositoryGitSonarQube AnalysisStatic code analysis and quality metricsSonarQubeQuality GateEnforces code quality standardsSonarQubeInstall DependenciesInstalls Node.js packagesNPMOWASP Dependency CheckScans dependencies for vulnerabilitiesOWASPTrivy File ScanScans filesystem for vulnerabilitiesTrivyBuild Docker ImageCreates container image with build number tagDockerDocker Scout ScanAnalyzes Docker image for security issuesDocker ScoutPush to RegistryUploads image to DockerHubDockerConfigure EKS AccessUpdates aws-auth ConfigMapkubectlDeploy to EKSDeploys application to Kuberneteskubectl
Pipeline Execution Flow
bash# Automated on git push:
Developer commits → GitHub webhook → Jenkins trigger
    ↓
Code quality & security checks
    ↓
Docker image build (tagged with BUILD_NUMBER)
    ↓
Push to DockerHub
    ↓
Update Kubernetes deployment
    ↓
Rolling update on EKS cluster
    ↓
Application accessible via LoadBalancer URL

🚢 Deployment
Kubernetes Deployment Strategy
The application uses a Rolling Update strategy:
yaml# k8s/deployment.yaml
replicas: 2
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
Benefits:

Zero downtime deployments
Automatic rollback on failure
Gradual traffic shifting

Accessing the Application
Step 1: Get LoadBalancer URL
bashkubectl get service starbucks-service
Step 2: Access application
http://<LOADBALANCER-DNS>:3000
Verifying Deployment
bash# Check pods
kubectl get pods -l app=starbucks

# Check deployment
kubectl describe deployment starbucks-app

# Check service
kubectl get svc starbucks-service

# View logs
kubectl logs -l app=starbucks --tail=100

🔒 Monitoring & Security
Security Measures Implemented

Code Level: SonarQube static analysis
Dependency Level: OWASP vulnerability scanning
Filesystem Level: Trivy security scanning
Container Level: Docker Scout image analysis
Network Level: Security groups and VPC isolation
Access Control: IAM roles and RBAC policies

Adding Monitoring (Optional)
Deploy Prometheus and Grafana for monitoring:
bash# Add Prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack

# Port forward Grafana
kubectl port-forward svc/prometheus-grafana 3000:80
Access Grafana at http://localhost:3000 (admin/prom-operator)

🔧 Troubleshooting
Common Issues
Issue: EKS nodes not joining cluster
bash# Check node status
kubectl get nodes

# Verify aws-auth ConfigMap
kubectl get configmap aws-auth -n kube-system -o yaml

# Update aws-auth if needed
kubectl apply -f aws-auth-cm.yaml
Issue: Jenkins unable to deploy to EKS
bash# Verify Jenkins has kubectl configured
kubectl config view

# Check IAM permissions for Jenkins EC2 role
aws sts get-caller-identity

# Ensure Jenkins is added to aws-auth ConfigMap
Issue: Docker image pull failures
bash# Verify DockerHub credentials
docker login

# Check deployment image name
kubectl describe pod <pod-name>

# Pull image manually to test
docker pull sachinpatkari/starbucks:<BUILD_NUMBER>
Issue: LoadBalancer stuck in pending
bash# Check service events
kubectl describe svc starbucks-service

# Verify security groups allow traffic
# Ensure subnets are tagged for ELB discovery

💰 Cost Management
AWS Cost Optimization
Important: Running this project incurs AWS costs. Follow these practices:

Delete resources when not in use:

bashcd infra
terraform destroy -auto-approve

If terraform destroy fails, manually delete:

Load Balancers (EC2 Console)
NAT Gateways (VPC Console)
Elastic IPs (VPC Console)
Network Interfaces (EC2 Console)
EKS Cluster (EKS Console)
Then run terraform destroy again


Cost-saving tips:

Use t3.medium instances for worker nodes
Configure auto-scaling to scale down during off-hours
Use spot instances for non-production
Set up AWS Budget alerts



Estimated Monthly Cost (if running 24/7):

EKS Control Plane: $72/month
Worker Nodes (2x t3.medium): ~$60/month
NAT Gateway: ~$32/month
Load Balancer: ~$16/month
Total: ~$180/month


🤝 Contributing
Contributions are welcome! Please follow these steps:

Fork the repository
Create a feature branch (git checkout -b feature/AmazingFeature)
Commit your changes (git commit -m 'Add some AmazingFeature')
Push to the branch (git push origin feature/AmazingFeature)
Open a Pull Request


📝 License
This project is licensed under the MIT License - see the LICENSE file for details.

👤 Author
Sachin Patkari

💼 DevOps Engineer | Cloud Enthusiast
🌐 Specialization: AWS | Jenkins | Docker | Kubernetes | Terraform
📧 Email: your.email@example.com
🔗 LinkedIn: linkedin.com/in/sachinpatkari
🐙 GitHub: @sachinpatkari


🙏 Acknowledgments

AWS Documentation
Kubernetes Official Docs
Jenkins Community
HashiCorp Terraform Guides
DevOps Community


📸 Screenshots
Jenkins Pipeline Success
Show Image
SonarQube Analysis
Show Image
EKS Cluster
Show Image
Application Running
Show Image

<div align="center">
⭐ Star this repo if you find it helpful!
Made by Sachin Patkari
</div>