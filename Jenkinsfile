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
                aws eks update-kubeconfig --region ap-south-1 --name study-notion-cluster
                '''
            }
        }

        stage("Deploy to Private EKS") {
            steps {
                sh '''
                kubectl apply -f k8s
                kubectl rollout status deployment/frontend
                kubectl rollout status deployment/backend
                '''
            }
        }
    }
}
