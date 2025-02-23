pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        GITHUB_CREDENTIALS = credentials('github-credentials')
        GARDENER_KUBECONFIG = credentials('gardener-kubeconfig')
        DOCKER_REPOSITORY = 'tushar1309'
        PROJECT_NAME = 'hello-world-python'
        NAMESPACE = 'devops-practice'
    }
    
    triggers {
        githubPush()
    }
    
    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    env.VERSION = sh(script: "echo \$(date +%Y%m%d)-\$(git rev-parse --short HEAD)", returnStdout: true).trim()
                    
                    sh """
                        docker build --no-cache -t ${DOCKER_REPOSITORY}/${PROJECT_NAME}:${VERSION} \
                        --platform="linux/amd64" .
                    """
                }
            }
        }
        
        stage('Push to DockerHub') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh "docker push ${DOCKER_REPOSITORY}/${PROJECT_NAME}:${VERSION}"
                }
            }
        }
        
        stage('Deploy to Gardener') {
            steps {
                script {
                    withEnv(["KUBECONFIG=${GARDENER_KUBECONFIG}"]) {
                        sh """
                            sed -i 's|image: docker.io/tushar1309/hello-world-python:.*|image: docker.io/${DOCKER_REPOSITORY}/${PROJECT_NAME}:${VERSION}|' yaml/deployment.yaml
                            kubectl apply -f yaml/deployment.yaml -n ${NAMESPACE}
                            kubectl apply -f yaml/ingress.yaml -n ${NAMESPACE}
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
    }
}