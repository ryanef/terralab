pipeline {
    agent any
    stages {
        stage('init'){
            steps {
                sh 'ls'
                sh 'export TF_IN_AUTOMATION=true'
                sh 'terraform init -no-color'
            }
        }
        stage('plan'){
            sh 'terraform plan -no-color'
        }
    }
}