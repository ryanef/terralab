pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION=true
        TF_CLI_CONFIG_FILE = credentials('tfcloud')
    }
    stages {
        stage('ansible install'){
            steps {
                withAWS(credentials: 'AWS', region: 'us-east-1'){
                sh 'apt install ansible -y'
                }
            }
        }
        stage('apply'){
            steps {
                withAWS(credentials: 'AWS', region: 'us-east-1'){
                sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('ansible playbook'){
            steps{
                withAWS(credentials: 'AWS', region: 'us-east-1'){
                    ansiblePlaybook(credentialsId: 'ec2ssh', inventory: 'aws_web_servers', playbook: 'playbook/main-playbook.yml')
                }
            }
        }
    }
}