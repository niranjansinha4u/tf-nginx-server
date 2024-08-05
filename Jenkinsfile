pipeline {
    agent any

    // enviroment set
    environment {
        RELEASE = "1.0.0"
        APP_NAME  = "nginx-webapp"
        //IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        //IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
        IMAGE_TAG = "latest"
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

        // Trivy File system scan ..
        stage("Trivy File system scan.."){
            steps{
                script{
                    echo "Trivy File system scan.."
                    sh "trivy fs . > trivyfs-report.txt"
                }
            }
        }


        
        stage("Build Code") {
            steps {
                script{
                    echo "Building new image.."
                    sh "docker build -t ${APP_NAME} ./nginx-webapp"
                    }
            }
            
        }

        // Trivy File system scan ..
        stage("Trivy Docker Image scan.."){
            steps{
                script {
                     sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image nginx-webapp:${IMAGE_TAG} --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table > trivyimage.txt')
                    }
            }
        }
        
        stage("Push to DockerHub") {
            steps {
                script{
                    echo "Pushing the image to DockerHub.."
                    withCredentials([usernamePassword(credentialsId:"dockerHub", passwordVariable:"dockerHubPass", usernameVariable:"dockerHubUser")]){
                        sh "docker tag nginx-webapp ${env.dockerHubUser}/nginx-webapp:${IMAGE_TAG}"
                        sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                        sh "docker push ${env.dockerHubUser}/nginx-webapp:${IMAGE_TAG}"
                    }
                
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
                    sh "docker rmi -f ${APP_NAME}:${IMAGE_TAG}"
                    sh "docker rmi -f demo-cicd-pipeline-web:${IMAGE_TAG}"
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
