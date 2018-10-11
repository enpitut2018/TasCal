#!/usr/bin/env groovy

pipeline {
    agent none

    stages {
        stage('launch-rails-container') {
            agent {
                docker { image 'ruby:2.4.4' }
            }
            when {
                branch 'setup-auto-test'
            }
            steps {
                sh 'apt-get update && apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*'
            }
        }

        stage('launch-postgrelsql-container') {
            agent {
                docker {image 'postgres:9.5'}
            }
            when {
                branch 'setup-auto-test'
            }
            steps {
                sh 'postgresql status'
            }
        }
    }
}