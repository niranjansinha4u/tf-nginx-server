pipeline {
    agent any

    // enviroment set
    environment {
        //APP_NAME  = "nginx-webapp"
        //IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }
    
    stages {
        stage("Clone Code") {
            steps {
                script{
                    echo "cloning the GitHub repo code.."
                    git url: "https://github.com/niranjansinha4u/tf-nginx-server.git", branch:"main"
                    sh 'git pull origin main'
                }
            }
            
        }

        //  Cleanup old Dockerfile
        stage("Cleanup Old Images..") {
            steps {
                script{
                    echo "Cleanup old image.."
                    //sh "docker image prune -a -f"
                    // sh 'docker image prune -f $(docker images -q --filter "before=nginx-webapp-web:latest" nginx-webapp-web)'
                    sh "docker rmi -f nginx-webapp-web:latest"
                    }
            }
            
        }

        // Trivy File system scan ..
        // stage("Trivy File system scan.."){
        //     steps{
        //         script{
        //             dir(nginx-webapp){
        //                 echo "Trivy File system scan.."
        //                 sh "trivy fs . > trivyfs-report.txt"  
        //             }
                    
        //         }
        //     }
        // }

        
        stage("Build Code") {
            steps {
                script{
                    echo "Building new image.."
                    sh "docker build -t nginx-webapp ./nginx-webapp"
                    }
            }
            
        }

        // Trivy File system scan ..
        // stage("Trivy Docker Image scan.."){
        //     steps{
        //         script{
        //             sh "trivy image nginx-webapp > trivy-img-report.txt"
                    
        //         }
        //     }
        // }
        
        stage("Push to DockerHub") {
            steps {
                script{
                    echo "Pushing the image to DockerHub.."
                    withCredentials([usernamePassword(credentialsId:"dockerHub", passwordVariable:"dockerHubPass", usernameVariable:"dockerHubUser")]){
                        sh "docker tag nginx-webapp ${env.dockerHubUser}/nginx-webapp:latest"
                        sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                        sh "docker push ${env.dockerHubUser}/nginx-webapp:latest"
                    }
                
                }
            }
            
        }
        
        stage("Deploy Code") {
            steps{
                script{
                    echo "Deploying the container"
                    sh "docker-compose down && docker-compose up -d"
                    //sh "docker run -dp 80:80 devopsbasic/nginx-webapp:latest"
                }
            }
        }
    }
    
}
