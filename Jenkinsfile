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

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        // Ensure Minikube's Docker environment is being used
                        sh '''
                        eval $(minikube docker-env)  # Set Minikube's Docker environment
                        sudo chmod 666 /var/run/docker.sock  # Grant permissions to Jenkins to access Docker
                        docker build -t ${IMAGE_NAME} .  # Build the Docker image
                        '''
                    } catch (Exception e) {
                        error "Docker build failed: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    try {
                        // Ensure kubectl is working before applying the deployment
                        sh 'kubectl version --client=true'  // Check kubectl version to verify it's set up correctly

                        // Deploy Kubernetes manifests
                        sh '''
                        kubectl apply -f k8s-deployment.yaml  # Apply the deployment YAML
                        kubectl apply -f k8s-service.yaml  # Apply the service YAML
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
                        // Verify the status of the deployment
                        sh 'kubectl get pods'  // Get the list of pods to verify the deployment
                        sh 'kubectl get services'  // Get the list of services to verify the deployment
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
                        // Clean up unused Docker resources
                        sh 'docker system prune -f'
                    } catch (Exception e) {
                        error "Cleanup failed: ${e.message}"
                    }
                }
            }
        }
    }
}
