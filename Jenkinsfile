pipeline {
    agent any

    stages {

        stage("Checkout Code") {
            steps {
                checkout scm
            }
        }

        stage("Login to ECR") {
            steps {
                sh '''
                aws ecr get-login-password --region ap-south-1 \
                | docker login --username AWS --password-stdin 953675642713.dkr.ecr.ap-south-1.amazonaws.com
                '''
            }
        }

        stage("Build & Push Frontend Image") {
            steps {
                sh '''
                docker build -t 953675642713.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest -f Dockerfile .
                docker push 953675642713.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest
                '''
            }
        }

        stage("Build & Push Backend Image") {
            steps {
                sh '''
                docker build -t 953675642713.dkr.ecr.ap-south-1.amazonaws.com/backend:latest -f server/Dockerfile server
                docker push 953675642713.dkr.ecr.ap-south-1.amazonaws.com/backend:latest
                '''
            }
        }

        stage("Configure Private EKS") {
            steps {
                sh '''
                aws eks update-kubeconfig --region ap-south-1 --name study-notion-cluster-2
                kubectl get nodes
                '''
            }
        }

        stage("Deploy to EKS") {
            steps {
                sh '''
                kubectl apply -f k8s

                kubectl set image deployment/frontend frontend=953675642713.dkr.ecr.ap-south-1.amazonaws.com/frontend:latest
                kubectl set image deployment/backend backend=953675642713.dkr.ecr.ap-south-1.amazonaws.com/backend:latest

                kubectl rollout status deployment/frontend
                kubectl rollout status deployment/backend
                '''
            }
        }
    }
}
