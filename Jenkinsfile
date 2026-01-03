# this is automation script to build and push docker images to ECR
pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
        ACCOUNT_ID = "953675642713"

        FRONTEND_IMAGE = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/study-notion-frontend:latest"
        BACKEND_IMAGE  = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/study-notion-backend:latest"
    }

    stages {

        stage("Checkout Code") {
            steps {
                git url: "https://github.com/vinod73570/Study-Notion.git", branch: "main"
            }
        }

        stage("Login to ECR") {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin \
                  $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage("Build & Push Frontend") {
            steps {
                sh '''
                docker build -t $FRONTEND_IMAGE .
                docker push $FRONTEND_IMAGE
                '''
            }
        }

        stage("Build & Push Backend") {
            steps {
                sh '''
                docker build -t $BACKEND_IMAGE ./server
                docker push $BACKEND_IMAGE
                '''
            }
        }
    }
}
