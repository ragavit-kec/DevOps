pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app"
        IMAGE_TAG = "latest"
        DOCKER_USERNAME = "ragavit"  // Change this if using a different Docker Hub account
        DOCKER_PASSWORD = "qwerty786!R"  // You should use Jenkins credentials instead!
        IMAGE_REGISTRY = "ragavit/my-app"  // Change this if using a different registry
        K8S_DEPLOYMENT = "my-app-deployment"
        K8S_SERVICE = "my-app-service"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/ragavit-kec/DevOps.git'
            }
        }

        stage('Reinstall Minikube') {
            steps {
                script {
                    try {
                        sh '''
                        # Stop and delete Minikube if it exists
                        minikube stop || true
                        minikube delete || true

                        # Reinstall Minikube (Ubuntu-based system)
                        sudo rm -rf /usr/local/bin/minikube
                        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
                        sudo install minikube-linux-amd64 /usr/local/bin/minikube
                        rm minikube-linux-amd64
                        '''
                    } catch (Exception e) {
                        error "Minikube reinstallation failed: ${e.message}"
                    }
                }
            }
        }

        stage('Setup Minikube & Docker') {
            steps {
                script {
                    try {
                        sh '''
                        # Start Minikube
                        minikube start --driver=docker

                        # Ensure Minikube is using the correct Docker environment
                        eval $(minikube docker-env)

                        # Grant Jenkins access to Docker
                        sudo chmod 666 /var/run/docker.sock
                        '''
                    } catch (Exception e) {
                        error "Minikube setup failed: ${e.message}"
                    }
                }
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    try {
                        sh '''
                        echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
                        '''
                    } catch (Exception e) {
                        error "Docker login failed: ${e.message}"
                    }
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    try {
                        sh '''
                        # Build the Docker image
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

                        # Tag the image for Docker Hub
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_REGISTRY}:${IMAGE_TAG}

                        # Push the image to Docker Hub
                        docker push ${IMAGE_REGISTRY}:${IMAGE_TAG}
                        '''
                    } catch (Exception e) {
                        error "Docker image build or push failed: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    try {
                        // Set Minikube as the Kubernetes context
                        sh 'kubectl config use-context minikube'

                        // Ensure Minikube pulls the latest image from Docker Hub
                        sh '''
                        kubectl delete deployment ${K8S_DEPLOYMENT} || true
                        kubectl run ${K8S_DEPLOYMENT} --image=${IMAGE_REGISTRY}:${IMAGE_TAG} --port=80 --restart=Always
                        '''

                        // Apply Kubernetes manifests
                        sh '''
                        kubectl apply -f k8s-deployment.yaml
                        kubectl apply -f k8s-service.yaml
                        '''
                    } catch (Exception e) {
                        error "Kubernetes deployment failed: ${e.message}"
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    try {
                        sh '''
                        kubectl get pods
                        kubectl get services
                        '''
                    } catch (Exception e) {
                        error "Verification of deployment failed: ${e.message}"
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    try {
                        sh 'docker system prune -f'
                    } catch (Exception e) {
                        error "Cleanup failed: ${e.message}"
                    }
                }
            }
        }
    }
}
