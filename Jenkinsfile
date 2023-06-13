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
                    sh 'sed -i "s/java-web-app[^ ]*/java-web-app:v$IMAGE_VERSION" ansible/deploy.yaml'
                }
            }
        }

        // stage('ssh') {
        //     steps {
        //         script{
                     
        //             cleanWs()
        //             // sh "echo 'hello' >> file1.txt"
        //             // sh "echo 'hello' >> file2.txt"
        //             // sh "zip -r oneFile.zip file1.txt file2.txt"
                     
        //             // echo 'Local files.....'       
        //             // sh 'ls -l'
 
        //             command='ansible-playbook play.yaml'
                         
 
        //         //   // Copy file to remote server 
        //         //   sshPublisher(publishers: [sshPublisherDesc(configName: 'dummy-server',
        //         //     transfers: [ sshTransfer(flatten: false,
        //         //                  remoteDirectory: './',
        //         //                  sourceFiles: 'oneFile.zip'
        //         //     )])
        //         //   ])
                   
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