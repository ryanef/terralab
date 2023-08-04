pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION=true
        TF_CLI_CONFIG_FILE = credentials('tfcloud')
    }
    stages {
        stage('validate apply'){
            input{
                message 'Do you want to apply?'
                ok "Apply this plan."
            }
            steps {
                echo 'Apply accepted'
            }
        }
        stage('apply'){
            steps {
                withAWS(credentials: 'AWS', region: 'us-east-1'){
                sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('validate ansible'){
            input{
                message 'do you want to run ansible'
                ok 'Run Ansible'
            }
            steps {
                echo 'Ansible now running....'
            }
        }

        stage('ansible playbook'){
            steps{
                 ansiblePlaybook(credentialsId: 'ec2ssh', inventory: 'aws_web_servers', playbook: 'playbooks/main-playbook.yml')
            }
        }

        stage ('do you want to destroy?') {
            input {
                message 'do you want to do destroy?'
                ok 'DESTROY DESTROY DESTROY ----- DO YOU WANT TO DESTROY -----  DESTROY DESTROY DESTROY?????'
            }
            steps {
                echo 'destruction!'
            }
        }

        stage('terraform destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}