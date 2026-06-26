pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    rm -rf /var/lib/tomcat10/webapps/football-fan-hub
                    cp target/football-fan-hub.war /var/lib/tomcat10/webapps/
                    sudo systemctl restart tomcat10
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    sleep 10
                    curl -f http://localhost:8080/football-fan-hub/
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Football Fan Hub deployed successfully.'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
