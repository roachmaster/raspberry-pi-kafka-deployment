node {

    stage("Clone"){
        git 'git@github.com:roachmaster/raspberry-pi-kafka-deployment.git'
    }

    stage("Docker Build"){
        withCredentials([usernamePassword(credentialsId: '87e61f11-079d-4052-b083-ea5859f0f85b',
                                          passwordVariable: 'DOCKER_PASSWORD',
                                          usernameVariable: 'DOCKER_USERNAME')]) {
            def dockerVersion = "2.0.0-SNAPSHOT"
            dockerBuild(dockerName:"${DOCKER_USERNAME}/pi-kafka:${dockerVersion}",
                        dockerOpt:"",
                        DOCKER_PASSWORD: "${DOCKER_PASSWORD}",
                        DOCKER_USERNAME:"${DOCKER_USERNAME}")
        }
    }

    stage("Create Kafka"){
        sh "kubectl delete --ignore-not-found=true statefulset.apps/kafka-k3s  service/kafka-k3s"
        sh "kubectl apply -f k3s/kafka.yml"
    }
}