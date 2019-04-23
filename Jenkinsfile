pipeline {
    agent any

    stages {
        stage('Build') {    
            // agent {
            //     docker {
            //         image 'amazonlinux:latest'
            //         args '--volume $(pwd):/opt/app'
            //         args '/bin/bash -c "cd /opt/app && ./build_lambda.sh"'
            //     }
            // }
            steps {
                sh 'echo Configuring Build environment using docker..'
                sh '''
                    docker run --rm -i \
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