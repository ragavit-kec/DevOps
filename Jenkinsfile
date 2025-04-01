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
                git 'https://github.com/ragavit-kec/DevOps.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'eval $(minikube docker-env)' // Use Minikube's Docker daemon
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }
        
        stage('Deploy to Minikube') {
            steps {
                script {
                    sh '''
                    kubectl apply -f k8s-deployment.yaml
                    kubectl apply -f k8s-service.yaml
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh 'kubectl get pods'
                    sh 'kubectl get services'
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    sh 'docker system prune -f'
                }
            }
        }
    }
}
