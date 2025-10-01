☕ Starbucks DevSecOps Project
This project is a fully automated CI/CD pipeline that builds, scans, packages, and deploys a Starbucks clone application to AWS EKS using Jenkins, Docker, Kubernetes, SonarQube, Trivy, OWASP, Docker Scout, Ansible, and Terraform.

🚀 Project Flow
1. Infrastructure Setup (Terraform + Ansible)
Terraform provisions:

VPC, Subnets, Internet Gateway
EKS Cluster & Worker Nodes
Jenkins EC2 instance

Ansible installs:

Jenkins
Docker
Trivy
SonarQube (if required)

2. CI/CD Pipeline (Jenkinsfile)
The automated pipeline performs the following steps:

Cleans workspace
Clones source code from GitHub
Runs SonarQube static code analysis
Waits for Sonar Quality Gate
Installs npm dependencies
Runs OWASP Dependency Check
Runs Trivy File System Scan
Builds Docker image of the app
Runs Docker Scout (quickview, CVEs, recommendations)
Pushes Docker image to DockerHub
Updates Kubernetes manifests (deployment.yaml & service.yaml) with new image tag
Deploys to AWS EKS
Verifies rollout

3. Kubernetes Deployment

deployment.yaml → Deploys app containers
service.yaml → Exposes app using AWS LoadBalancer


🛠 Tools & Technologies
CategoryToolsInfrastructureTerraform, Ansible, AWS (EC2, VPC, EKS, IAM, ELB)CI/CDJenkinsCode AnalysisSonarQubeSecurity ScanningTrivy, OWASP Dependency-Check, Docker ScoutContainerizationDocker, DockerHubOrchestrationKubernetes (EKS)

📂 Project Structure
starbucks/
├── ansible/
│   ├── inventory.ini
│   └── playbook.yml
├── infra/
│   └── main.tf
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── Jenkinsfile
└── src/
    ├── index.js
    ├── package.json
    └── (other app files)

⚡ Setup Instructions
1️⃣ Provision Infrastructure
bashcd infra/
terraform init
terraform apply -auto-approve
2️⃣ Configure Jenkins Server
bashcd ansible/
ansible-playbook -i inventory.ini playbook.yml
3️⃣ Run Jenkins Pipeline

Access Jenkins UI
Create a new Pipeline job
Point to your project's Jenkinsfile
Trigger build manually or configure GitHub webhook

4️⃣ Verify Deployment
bashkubectl get pods
kubectl get svc
Copy the EXTERNAL-IP of starbucks-service and open it in your browser. Your app is now live! 🎉

🧹 Teardown (Avoid AWS Costs)
When you're done testing, destroy all resources:
bashcd infra/
terraform destroy -auto-approve
Also manually check and delete:

Load Balancers (ELB/ALB)
NAT Gateways
Elastic IPs
Orphaned ENIs (Elastic Network Interfaces)


✅ Features

✨ Automated end-to-end CI/CD pipeline
🔍 Static code analysis with SonarQube
🛡️ Multi-layer security scanning (OWASP, Trivy, Docker Scout)
🐳 Containerized deployment with Docker
🏗️ Infrastructure-as-Code with Terraform
⚙️ Configuration management with Ansible
☸️ Kubernetes-based deployment on AWS EKS
📊 Quality gates and vulnerability reporting


📌 Important Notes

Keep deployment.yaml with IMAGE_PLACEHOLDER - Jenkins pipeline dynamically injects the image tag (sachinpatkari/starbucks:<build_number>)
Always run terraform destroy after testing to avoid unexpected AWS billing
Ensure AWS credentials are properly configured before running Terraform
SonarQube quality gate failures will stop the pipeline
Docker Scout provides detailed CVE analysis for container security


🔐 Prerequisites

AWS Account with appropriate permissions
AWS CLI configured
Terraform installed (v1.0+)
Ansible installed
kubectl installed
Docker Hub account
GitHub repository with source code


📝 Environment Variables
Configure these in Jenkins:

DOCKERHUB_CREDENTIALS - Docker Hub username and password
SONAR_TOKEN - SonarQube authentication token
AWS_CREDENTIALS - AWS access keys for EKS deployment