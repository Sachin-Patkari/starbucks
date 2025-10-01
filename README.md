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
