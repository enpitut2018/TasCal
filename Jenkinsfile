pipeline {
    agent any

    stages {
        stage('prepare-docker') {
            when {
                branch 'setup-auto-test'
            }
            agent {
                docker {
                    image 'ruby:2.4.4'
                    args  'apt-get update && apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*'
                }
            }
            steps {
                echo 'parepare docker containers...'
                
            }
        }
    }
}