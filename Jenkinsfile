pipeline {
  agent none
  stages {
    stage('prepare-psql-test-db') {
      agent any
      when {
        branch 'config-jenkinsfile'
      }
      steps {
        sh 'bash ./.jenkins/setup_test_db_container.sh'
      }
    }
    stage('rails-container') {
      agent {
        docker {
          image 'ruby:2.4.4'
          args '--link tascal-psql:tascal-psql'
        }

      }
      when {
        branch 'config-jenkinsfile'
      }
      steps {
        sh 'cat /etc/hosts'
        sh 'apt-get update'
        sh 'apt-get install -y postgresql-client'
        sh 'apt-get install -y nodejs'
        sh 'rm -rf /var/lib/apt/lists/*'
        sh 'bundle install'
        sh 'rake db:create RAILS_ENV=test'
      }
    }
  }
  post {
    always {
      node('master') {
        sh 'docker stop tascal-psql'
      }
    }

  }
}