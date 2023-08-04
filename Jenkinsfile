pipeline {
    agent any
    environment {
        TF_IN_AUTOMATION=true
        TF_CLI_CONFIG_FILE = credentials('tfcloud')
    }
    stages {
        stage('init'){
            steps{
                sh 'cat $BRANCH_NAME.tfvars'
                sh 'terraform init'
                
            }
        }
        stage('validate apply'){
            when{
                beforeInput true
                branch "dev"
            }
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
                sh 'terraform apply -auto-approve -var-file="$BRANCH_NAME.tfvars"'
                }
            }
        }

        stage('validate ansible'){
            when{
                beforeInput true
                branch "dev"
            }           
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
                 sh 'ansible-playbook -i aws_web_servers --private-key /var/lib/jenkins/terralab playbooks/main-playbook.yml'
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
                sh 'terraform destroy -auto-approve -var-file="$BRANCH_NAME.tfvars"'
            }
        }
    }
    post {
        success {
            echo 'Success'
        }
        failure {
            sh 'terraform destroy -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
        }
        aborted {
            sh 'terraform destroy -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'           
        }
    }
}