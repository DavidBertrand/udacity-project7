pipeline {
    environment {
        registry = "bertrand282/project7"
        registryCredential = 'dockerhub'
    }
     agent any
     stages {/*
        stage('install dependencies') {
            steps {
                sh  '''python3 -m venv venv
                    . venv/bin/activate
                    make install
                    '''
            }
        }
        stage('Build') {
            steps {
                sh 'echo "Hello World"'
                sh '''
                     echo "Multiline shell steps works too"
                     ls -lah
                '''
            }
        }
        stage('Lint app') {
            steps {
                sh ''' . venv/bin/activate
                    pylint --disable=R,C,W1203 app/**.py
                    '''
                //sh    'pylint --disable=R,C,W1203 app/**.py'
            }
        }
       stage ("lint dockerfile") {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }
            steps {
                sh 'hadolint dockerfiles/* | tee -a hadolint_lint.txt'
            }
            post {
                always {
                    archiveArtifacts 'hadolint_lint.txt'
                }
            }
        }
        stage('Build Docker image') {
            steps {
                sh '''dockerpath="bertrand282/project7"
                    # Build image and add a descriptive tag
                    docker build --tag=$dockerpath .    
                    '''
            }
        }
        stage('Publish') {
            steps {
                withDockerRegistry([ credentialsId: registryCredential, url: "" ]) {
                    sh 'docker push bertrand282/project7'
                }
            }
        }*/

        stage('Ansible Init') {
            steps {
                script {
                    /*def tfHome = tool name: 'Ansible'
                env.PATH = "${tfHome}:${env.PATH}"*/
                sh ''' . venv/bin/activate
                    ansible --version
                    '''
              }
            }
        }
        
        stage('Ansible Deploy') {
            steps {
                script {
                    
                    def image_id = 'bertrand282/project7'
 //                       sh "ansible-playbook playbook.yml --extra-vars \"image_id=${image_id}\""
                        sh ". venv/bin/activate"
                        sh "ansible-playbook  playbook.yml --private-key=~/.ssh/udacity.pem --extra-vars \"image_id=${image_id}\" -vvv"
                    }
            }
        }
       
    }
}