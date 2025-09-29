pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {
        stage ("Clean Workspace") {
            steps {
                cleanWs()
            }
        }
        stage ("Checkout") {
            steps {
                checkout scm
            }
        }
        stage("SonarQube Analysis"){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=starbucks \
                        -Dsonar.projectKey=starbucks
                    '''
                }
            }
        }
        stage("Quality Gate"){
            steps {
                script {
                    waitForQualityGate abortPipeline: true, credentialsId: 'Sonar-token' 
                }
            } 
        }
        stage("Install NPM Dependencies") {
            steps {
                sh "npm install"
            }
        }
        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage ("Trivy File Scan") {
            steps {
                sh "trivy fs . > trivy.txt"
            }
        }
        stage ("Build Docker Image") {
            steps {
                sh "docker build -t sachinpatkari/starbucks:${BUILD_NUMBER} ."
                sh "docker tag sachinpatkari/starbucks:${BUILD_NUMBER} sachinpatkari/starbucks:latest"
            }
        }
        stage('Docker Scout Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                        sh 'docker-scout quickview sachinpatkari/starbucks:latest'
                        sh 'docker-scout cves sachinpatkari/starbucks:latest'
                        sh 'docker-scout recommendations sachinpatkari/starbucks:latest'
                    }
                }
            }
        }
        stage ("Push to DockerHub") {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker') {
                        sh "docker push sachinpatkari/starbucks:${BUILD_NUMBER}"
                        sh "docker push sachinpatkari/starbucks:latest"
                    }
                }
            }
        }
        stage ("Deploy to EKS") {
            steps {
                withAWS(region: 'ap-south-1', credentials: 'aws-cred') {
                    sh '''
                        # Configure kubeconfig for EKS
                        aws eks update-kubeconfig --region ap-south-1 --name starbucks-eks
                        
                        # Update image in deployment (rolling update)
                        kubectl set image deployment/starbucks-app starbucks=sachinpatkari/starbucks:${BUILD_NUMBER} -n default || true
                        
                        # If deployment does not exist, apply manifests
                        kubectl apply -f k8s/deployment.yaml
                        kubectl apply -f k8s/service.yaml
                    '''
                }
            }
        }
    }
}
