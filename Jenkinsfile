#!/usr/bin/env groovy

pipeline {
    agent none

    stages {
        stage('prepare-psql-test-db') {
            when {
                branch 'config-jenkinsfile'
            }
            steps {
                sh './.jenkins/setup.sh'
            }
        }

        stage('prepare-environment-containers') {
            when {
                branch 'setup-auto-test'
            }
            failFast true
            parallel {
                stage('rails-container') {
                    agent {
                        docker {image 'ruby:2.4.4'}
                    }
                    when {
                        branch 'setup-auto-test'
                    }
                    steps {
                        sh 'apt-get update && apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*'
                    }
                }
                stage('psql-container') {
                    agent {
                        docker {image 'postgres:9.5'}
                    }
                    when {
                        branch 'setup-auto-test'
                    }
                    steps {
                        sh 'psql --version'
                    }
                }
            }
        }
    }
}