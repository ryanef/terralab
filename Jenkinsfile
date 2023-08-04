pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION=true
        TF_CLI_CONFIG_FILE = credentials('tfcloud')
    }
    stages {
        stage('init'){
            steps {
                sh 'terraform init -no-color'
            }
        }
        stage('plan'){
            steps {
                sh 'terraform plan -no-color'
            }
        }
        stage('apply'){
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('destroy'){
            steps {
                sh 'terraform destroy -no-color'
            }
        }
    }
}