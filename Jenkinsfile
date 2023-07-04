pipeline{
    agent any
    stages{
        stage("prepration"){
            steps{
                script{
                    echo "=============increment pom version=========="
                    sh 'mvn build-helper:parse-version versions:set \
                    -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} versions:commit'
                    def matcher=readFile("pom.xml")=~'<version>(.+)</version>'
                    def version=matcher[0][1]
                    env.IMAGE_VERSION = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage("bulding application"){
            steps{
                  script{
                     echo "=========building jar==========="
                     sh "mvn clean package"
                     sh "mvn package"
                  }
            }
        }

        stage("buling container and push to repo"){
            steps{
                script{
                   echo "=========== bulding image ============"
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        echo "=========building container image ==========="
                        sh "docker build -t  mar97/java-web-app:v$IMAGE_VERSION ."
                        sh "echo $PASSWORD | docker login -u $USERNAME  --password-stdin"
                        echo "docker push image"
                        sh "docker push mar97/java-web-app:v$IMAGE_VERSION"
                    }
                }
            }
        }

        stage("update ansible config files"){
            steps{
                script{
                    echo "============= update ansible files ==========="
                    sh 'shell/sed.sh $IMAGE_VERSION ansible/deploy.yaml'
                    sh 'shell/sed.sh $IMAGE_VERSION k8s/deployment.yaml'                    
                    echo "============= push changes ==========="
                    withCredentials([usernamePassword(credentialsId: 'jenkins_github_cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh 'git remote set-url origin  https://${PASSWORD}@github.com/mohamedAhmed97/java-maven-app.git'
                        sh 'git add .'
                        sh 'git commit -m "ci: update version in ansible file"'
                        sh 'git push origin master'
                    }

                }
            }
        }

        // stage('copy edited files using ssh') {
        //     steps {
        //         script{
                    
        //             // cleanWs()
        //             command='ansible-playbook -i java-webapp/ansible/hosts  java-webapp/ansible/test_k8s.yaml'
        //             sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible',
        //             transfers: [ sshTransfer(flatten: false,
        //                          remoteDirectory: 'java-webapp',
        //                          sourceFiles: 'k8s/'
        //             )])
        //           ])
        //           // Copy file to remote server 
        //           sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible',
        //             transfers: [ sshTransfer(flatten: false,
        //                          remoteDirectory: 'java-webapp',
        //                          sourceFiles: 'ansible/'
        //             )])
        //           ])
                   
        //           // Execute commands
        //           sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible',
        //             transfers: [ sshTransfer(execCommand: command    )])])
                     
        //         }
        //     }
        // }    
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}