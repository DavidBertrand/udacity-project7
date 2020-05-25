pipeline {
    environment {
        registry = "bertrand282/project7_2:latest"
        registryCredential = 'dockerhub'
    }
     agent any
     stages {
         /*
        stage('Install dependencies') {
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

        stage ('OWASP Dependency-Check Vulnerabilities - Docker'){
            steps {
                sh 'rm owasp* || true'
                sh 'chmod +x run_owasp_dependency_check.sh'
                sh 'bash run_owasp_dependency_check.sh'
            }
        } 
*/
        stage ("Lint dockerfile") {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }
            steps {
                //sh 'hadolint Dockerfile | tee -a hadolint_lint.txt'
                script {
                            def lintResult = sh returnStdout: true, script: 'docker run --rm -i lukasmartinelli/hadolint < Dockerfile'
                            if (lintResult.trim() == '') {
                                println 'Lint finished with no errors'
                            } else {
                                println 'Error found in Lint'
                                println "${lintResult}"
                                currentBuild.result = 'UNSTABLE'
                            }
                        }
            }
            post {
                 failure {
                    sh 'exit 1'
                }
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
        
        stage('Security Scan') {
              steps { 
                 aquaMicroscanner imageName: 'bertrand282/project7_2', notCompliesCmd: 'exit 1', onDisallowed: 'ignore', outputFormat: 'html'
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
                    

    //                  sh "ansible-playbook playbook.yml --extra-vars \"image_id=${image_id}\""
                        sh  '''. venv/bin/activate
                             ansible-playbook  ansible/playbook.yml --private-key=~/.ssh/udacity.pem --extra-vars image_id=$registry -vvv
                            '''

                }
            }
        }
        stage('Test Application'){
            steps{
                sh './run_app_status_check.sh '
            }
        }
       
    }
}