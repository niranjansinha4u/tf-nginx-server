pipeline {
    agent any
    
    stages {
        stage("Clone Code") {
            steps {
                echo "cloning the GitHub repo code.."
                git url: "https://github.com/niranjansinha4u/tf-nginx-server.git", branch:"main"
            }
            
        }
        
        stage("Build Code") {
            steps {
                echo "Building new image.."
                sh "docker build -t nginx-webapp ./nginx-webapp/*"
            }
            
        }
        
        stage("Push to DockerHub") {
            steps {
                echo "Pushing the image to DockerHub.."
                withCredentials([usernamePassword(credentialsId:"dockerHub", passwordVariable:"dockerHubPass", usernameVariable:"dockerHubUser")]){
                    sh "docker tag nginx-webapp ${env.dockerHubUser}/nginx-webapp:latest"
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                    sh "docker push ${env.dockerHubUser}/nginx-webapp:latest"
                }
            }
            
        }
        
        stage("Deploy Code") {
            echo "Deploying the container"
            sh "docker-compose down && docker-compose up -d"
            
        }
    }
    
}