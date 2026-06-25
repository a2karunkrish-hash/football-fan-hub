pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                    cp target/football-fan-hub.war /var/lib/tomcat10/webapps/
                '''
            }
        }
    }

    post {
        success {
            echo 'Football Fan Hub was built and deployed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check the console output for the error.'
        }
    }
}
