pipeline {
  agent none
  stages {
    stage('prepare-psql-test-db') {
      agent any
      when {
        branch 'config-jenkinsfile'
      }
      steps {
        sh 'bash ./.jenkins/setup.sh'
      }
    }
    stage('rails-container') {
      agent {
        docker {
          image 'ruby:2.4.4'
          args '--add-host=host_jenkins:172.18.0.2 --expose 5432'
        }

      }
      when {
        branch 'config-jenkinsfile'
      }
      steps {
        sh 'apt-get update && apt-get install -y --no-install-recommends postgresql-client && rm -rf /var/lib/apt/lists/*'
        sh 'cat /etc/hosts'
        sh 'psql status -h host_jenkins'
      }
    }
  }
  post {
    always {
      node('master') {
        sh 'su postgres -c "pg_ctl stop -D /usr/local/pgsql/data"'
      }


    }

  }
}