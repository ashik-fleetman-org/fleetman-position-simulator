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
      stage('Build') {
          steps{
            withMaven(
                // Maven installation declared in the Jenkins "Global Tool Configuration"
                maven: 'maven-3'){
                // Maven settings.xml file defined with the Jenkins Config File Provider Plugin
                // We recommend to define Maven settings.xml globally at the folder level using 
                // navigating to the folder configuration in the section "Pipeline Maven Configuration / Override global Maven configuration"
                // or globally to the entire master navigating to  "Manage Jenkins / Global Tools Configuration"
                //mavenSettingsConfig: 'my-maven-settings') {
                // Run the maven build
                //sh "mvn clean verify" 
                sh "mvn clean package"
                // sh "mvn clean package"
                }
              }
      

      stage('Build and Push Image') {
         steps {
           sh 'docker image build -t ${REPOSITORY_TAG} .'
         }
      }

      stage('Deploy to Cluster') {
         when { anyOf { branch 'dev'; branch 'test' } }
          steps {
                    sh 'envsubst < ${WORKSPACE}/deploy.yaml | kubectl apply -f -'
          }
      }
   }
}
}
