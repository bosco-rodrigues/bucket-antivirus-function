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
                sh 'echo $(date +"%F %T") - Configuring Build environment using docker..'
                sh '''
                    docker run --rm -i \
                    --name lambda_build \
		            --volume $(pwd):/opt/app \
		            amazonlinux:latest \
		            /bin/bash -c "cd /opt/app && ./build_lambda.sh"
                    '''
                sh 'ls -larth'
                sh 'ls -larth build/'
                sh 'echo $(date +"%F %T") - Build completed successfully'
            }
        }
        stage('Test') {
            steps {
                sh 'echo $(date +"%F %T") - Starting Tests in LAB...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}