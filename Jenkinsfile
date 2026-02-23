pipeline {
    agent any

    environment {
        LARAVEL_SERVER = '13.126.33.236'
        APP_DIR = '/home/ubuntu/marketing-app'
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo 'Cloning repository from GitHub...'
                git branch: 'main',
                    url: 'https://github.com/Ayush-js/marketing-laravel-docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sshagent(['laravel-ec2-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${LARAVEL_SERVER} '
                            cd ${APP_DIR} &&
                            docker-compose build --no-cache
                        '
                    """
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sshagent(['laravel-ec2-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${LARAVEL_SERVER} '
                            cd ${APP_DIR} &&
                            docker-compose down &&
                            docker-compose up -d &&
                            docker-compose exec -T app php artisan config:cache &&
                            docker-compose exec -T app php artisan route:cache
                        '
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying deployment...'
                sshagent(['laravel-ec2-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${LARAVEL_SERVER} '
                            docker-compose -f ${APP_DIR}/docker-compose.yml ps
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed! App is live at http://13.126.33.236'
        }
        failure {
            echo 'Pipeline failed! Check the logs above.'
        }
    }
}
