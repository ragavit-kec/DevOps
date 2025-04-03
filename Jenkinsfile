pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app"
        CONTAINER_NAME = "my-app-container"
        K8S_DEPLOYMENT = "my-app-deployment"
        K8S_SERVICE = "my-app-service"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/ragavit-kec/DevOps.git'
            }
        }

        stage('Setup Minikube & Docker') {
            steps {
                script {
                    try {
                        sh '''
                        # Ensure Minikube is running
                        minikube start

                        # Set up Docker to use Minikube’s environment
                        eval $(minikube docker-env)

                        # Grant permissions to Jenkins for Docker
                        sudo chmod 666 /var/run/docker.sock
                        '''
                    } catch (Exception e) {
                        error "Minikube setup failed: ${e.message}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        sh '''
                        docker build -t ${IMAGE_NAME} .
                        '''
                    } catch (Exception e) {
                        error "Docker image build failed: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    try {
                        // Ensure Minikube context is set
                        sh 'kubectl config use-context minikube'

                        // Apply Kubernetes manifests with TLS verification disabled
                        sh '''
                        kubectl apply --insecure-skip-tls-verify -f k8s-deployment.yaml
                        kubectl apply --insecure-skip-tls-verify -f k8s-service.yaml
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
                        kubectl get pods --insecure-skip-tls-verify
                        kubectl get services --insecure-skip-tls-verify
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
