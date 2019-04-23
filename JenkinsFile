pipeline {
    agent any

    stages {
        stage('Build') {    
            steps {
                sh 'echo Configuring Build environment using docker..'
                sh '''
                    docker run --rm -ti \
                    --name lambda_build \
		            --volume $(pwd):/opt/app \
		            amazonlinux:latest \
		            /bin/bash -c "cd /opt/app && ./build_lambda.sh"
                    '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}