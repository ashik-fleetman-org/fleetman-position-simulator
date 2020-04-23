pipeline {
   agent any

   environment {
     // You must set the following environment variables
     // ORGANIZATION_NAME
     // YOUR_DOCKERHUB_USERNAME (it doesn't matter if you don't have one)
     
     SERVICE_NAME = "fleetman-position-simulator"
     REPOSITORY_TAG="${YOUR_DOCKERHUB_USERNAME}/${ORGANIZATION_NAME}-${SERVICE_NAME}:${BUILD_ID}"
   }

   stages {
      stage('Preparation') {
         steps {
            cleanWs()
            git credentialsId: 'GitHub', url: "https://github.com/${ORGANIZATION_NAME}/${SERVICE_NAME}"
         }
      }
   stage('debug') {
         steps {
            echo "The build number is ${env.BUILD_NUMBER}"
            echo "The Branch ID  is ${GIT_BRANCH}"
            echo "The Commit ID  is ${GIT_COMMIT}"
            // echo "The Author name is ${GIT_AUTHOR_NAME}"
            // echo "The Commiter name is ${GIT_COMMITTER_NAME}"
         }
      }
      stage('Build') {
         steps {
            sh '''whoami'''
            sh '''pwd'''
            sh '''ls'''
            sh '''hostname'''
            sh '''mvn clean package'''
         }
      }

      stage('Build and Push Image') {
         steps {
           sh 'docker image build -t ${REPOSITORY_TAG} .'
         }
      }
      stage('Deliver for development') {
            when {
                branch 'dev'
            }
            steps {
                sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f - --namespace=dev'
               //  input message: 'Finished using the web site? (Click "Proceed" to continue)'
               //  sh './jenkins/scripts/kill.sh'
            }
        }
        stage('Deploy for Test') {
            when {
                branch 'test'
            }
            steps {
               sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f - --namespace=test'
               //  input message: 'Finished using the web site? (Click "Proceed" to continue)'
               //  sh './jenkins/scripts/kill.sh'
            }
        }
         stage('Deploy for Prod') {
            when {
                branch 'master'
            }
            steps {
               sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f - --namespace=prod'
               //  input message: 'Finished using the web site? (Click "Proceed" to continue)'
               //  sh './jenkins/scripts/kill.sh'
            }
        }
   }
}
