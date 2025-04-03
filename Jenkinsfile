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

        stage('Setup Docker Environment') {
            steps {
                script {
                    try {
                        sh '''
                        # Ensure Minikube Docker environment is used
                        eval $(minikube docker-env)

                        # Grant Jenkins access to Docker
                        sudo chmod 666 /var/run/docker.sock
                        '''
                    } catch (Exception e) {
                        error "Docker environment setup failed: ${e.message}"
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
                        // Set Minikube as the Kubernetes context
                        sh 'kubectl config use-context minikube'

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
