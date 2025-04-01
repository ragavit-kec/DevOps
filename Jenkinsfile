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
                    sh 'eval $(minikube docker-env) && docker build -t ${IMAGE_NAME} .' // Use Minikube's Docker daemon for build
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
                    sh 'kubectl get pods -o wide'
                    sh 'kubectl get services -o wide'
                }
            }
        }
        
        stage('Cleanup') {
            steps {
                script {
                    sh 'docker system prune -f --volumes'
                }
            }
        }
    }
}
