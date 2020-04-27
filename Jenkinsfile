pipeline {
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
        stage ("lint dockerfile") {
            //https://github.com/hadolint/hadolint/blob/master/docs/INTEGRATION.md
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }
            steps {
                sh 'hadolint Dockerfile | tee -a hadolint_lint.txt'
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
                withDockerRegistry([ credentialsId: "bertrand282", url: "" ]) {
                    sh 'docker push bertrand282/project7'
                }
            }
        }
       
    }
}