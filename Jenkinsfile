pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION=true
        TF_CLI_CONFIG_FILE = credentials('tfcloud')
    }
    stages {


        stage('ansible playbook'){
            steps{
                withAWS(credentials: 'AWS', region: 'us-east-1'){
                    ansiblePlaybook(credentialsId: 'ec2ssh', inventory: 'aws_web_servers', playbook: 'playbooks/main-playbook.yml')
                }
            }
        }
    }
}