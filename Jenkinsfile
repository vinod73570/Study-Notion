pipeline {
    agent any

    environment {
        IMAGE_TAG = "${env.GIT_COMMIT[0..6]}"
        EC2_USER = "ubuntu"
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

        stage('Save Images as Tar') {
            steps {
                sh """
                    docker save frontend:${IMAGE_TAG} -o frontend.tar
                    docker save backend:${IMAGE_TAG} -o backend.tar
                """
            }
        }

        stage('Copy Images to EC2') {
            steps {
                sshagent(credentials: ['EC2_SSH_KEY']) {
                    sh """
                        scp -o StrictHostKeyChecking=no frontend.tar ${EC2_USER}@${EC2_PUBLIC_IP}:/home/${EC2_USER}/
                        scp -o StrictHostKeyChecking=no backend.tar ${EC2_USER}@${EC2_PUBLIC_IP}:/home/${EC2_USER}/
                    """
                }
            }
        }

        stage('Start Containers on EC2') {
            steps {
                sshagent(credentials: ['EC2_SSH_KEY']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_PUBLIC_IP} '

                        # Install Docker if missing
                        if ! command -v docker &> /dev/null
                        then
                            sudo apt update
                            sudo apt install -y docker.io
                            sudo systemctl start docker
                            sudo systemctl enable docker
                        fi

                        # Load images
                        sudo docker load -i frontend.tar
                        sudo docker load -i backend.tar

                        # Remove old containers
                        sudo docker rm -f mongo frontend backend || true

                        # Start MongoDB
                        sudo docker run -d --name mongo \
                            -p 27017:27017 \
                            -e MONGO_INITDB_ROOT_USERNAME=admin \
                            -e MONGO_INITDB_ROOT_PASSWORD=admin123 \
                            mongo:latest

                        sleep 10

                        # Start Backend
                        sudo docker run -d --name backend \
                            --link mongo:mongo \
                            -e MONGO_URL="mongodb://admin:admin123@mongo:27017/studynotion?authSource=admin" \
                            -p 5000:5000 \
                            backend:${IMAGE_TAG}

                        # Start Frontend
                        sudo docker run -d --name frontend \
                            -p 3000:3000 \
                            frontend:${IMAGE_TAG}
                    '
                    """
                }
            }
        }

        stage('Show Info') {
            steps {
                echo """
==========================
 Deployment Completed
==========================

Frontend → http://${EC2_PUBLIC_IP}:3000
Backend  → http://${EC2_PUBLIC_IP}:5000

MongoDB Connection:
mongodb://admin:admin123@${EC2_PUBLIC_IP}:27017/studynotion?authSource=admin
"""
            }
        }

    }
}
