pipeline {
    environment {
        registry = "bertrand282/project7_2:latest"
        registryCredential = 'dockerhub'
    }
     agent any
     stages {
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
            }
        }
        stage ('OWASP Dependency-Check Vulnerabilities') {
            steps {
                dependencyCheck additionalArguments: ''' 
                    -o "./" 
                    -s "./"
                    -f "ALL" 
                    --prettyPrint''', odcInstallation: 'OWASP-DC'

                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
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
                
                    // Build image and add a descriptive tag
                  sh 'docker build --tag=$registry .'    
                    
            }
        }
        stage('Publish') {
            steps {
                withDockerRegistry([ credentialsId: registryCredential, url: "" ]) {
                    sh 'docker push $registry'
                }
            }
        }

        stage('Ansible Init') {
            steps {
                script {
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
                        sh ''' . venv/bin/activate
                            ansible-playbook  playbook.yml --private-key=~/.ssh/udacity.pem --extra-vars image_id=$registry -vvv
                            '''
                    }
            }
        }
       
    }
}