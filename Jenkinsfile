pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION=true
        TF_CLI_CONFIG_FILE = credentials('tfcloud')
    }
    stages {
        stage('destroy'){
            steps {
                withAWS(credentials: 'AWS', region: 'us-east-1'){
                sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}