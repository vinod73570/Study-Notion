pipeline {
    agent any

    environment {
        IMAGE_TAG = "${env.GIT_COMMIT[0..6]}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Images') {
            steps {
                sh """
                    echo "Building Frontend image..."
                    docker build -t frontend:${IMAGE_TAG} .

                    echo "Building Backend image..."
                    docker build -t backend:${IMAGE_TAG} ./server
                """
            }
        }

        stage('Run Containers (Same Server)') {
            steps {
                sh """
                    # Remove old containers
                    docker rm -f mongo backend frontend || true

                    echo "Starting MongoDB..."
                    docker run -d --name mongo \
                        -p 27017:27017 \
                        -e MONGO_INITDB_ROOT_USERNAME=admin \
                        -e MONGO_INITDB_ROOT_PASSWORD=admin123 \
                        mongo:latest

                    sleep 10

                    echo "Starting Backend..."
                    docker run -d --name backend \
                        --link mongo:mongo \
                        -e MONGO_URL="mongodb://admin:admin123@mongo:27017/studynotion?authSource=admin" \
                        -p 5000:4000 \
                        backend:${IMAGE_TAG}

                    echo "Starting Frontend..."
                    docker run -d --name frontend \
                        -p 3000:80 \
                        frontend:${IMAGE_TAG}
                """
            }
        }

        stage('Show URLs') {
            steps {
                script {
                    echo """
============================
 Deployment Completed
============================

Frontend : http://YOUR-SERVER-IP:3000
Backend  : http://YOUR-SERVER-IP:5000
MongoDB  : mongodb://admin:admin123@YOUR-SERVER-IP:27017/studynotion?authSource=admin
"""
                }
            }
        }

    }
}
