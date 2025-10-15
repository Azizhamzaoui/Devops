pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-21-openjdk-amd64"
        M2_HOME = "/opt/apache-maven-3.6.3"
        PATH = "${M2_HOME}/bin:${JAVA_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        DOCKER_REGISTRY = "azizhmz"
        DOCKER_IMAGE = "student-managementV2 "
        KUBECONFIG = "/var/lib/jenkins/.kube/config" 
    }

    stages {
        stage('Checkout') {
            steps {
                echo '🔄 Cloning repository...'
                git branch: 'main', url: 'https://github.com/Azizhamzaoui/Devops.git'
            }
        }

        stage('Build') {
            steps {
                echo '🔨 Building application with Maven...'
                sh 'mvn clean compile'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '🔍 Running SonarQube analysis...'
                withSonarQubeEnv('MySonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=student-management -Dsonar.host.url=http://192.168.61.157:9000'
                }
            }
        }

        stage('Package') {
            steps {
                echo '📦 Packaging the Spring Boot app...'
                sh 'mvn package -DskipTests'
            }
        }

        stage('Archive Artifact') {
            steps {
                echo '📂 Archiving JAR...'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo '⬆️ Pushing Docker image to registry...'
                sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo '🚀 Deploying to Kubernetes...'
		sh 'kubectl apply-f k8s/mysql-deployment.yaml'
                sh 'kubectl apply -f k8s/student-management.yaml'
		

            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}

