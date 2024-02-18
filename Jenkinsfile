def service_pipe(service_name){    
        def app
        stage("${service_name} - Test Code"){
            container('node') {
                steps{
                    dir("${service_name}"){
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }
        stage("${service_name} - Build Image"){
            container('docker') {
                steps{
                    dir("${service_name}"){
                        app = docker.build("pandalamdta/${service_name}")
                    }
                }
            }
        }
        stage("${service_name} - Push image") {
            container('docker') {
                steps{
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
}

pipeline {
    agent {
        kubernetes {
            podTemplate(containers:
                [containerTemplate(name: 'node', image: 'node:16-alpine', command: 'sleep', args: 'infinity'),
                containerTemplate(name: 'docker', image: 'docker', command: 'sleep', args: 'infinity'),],
                ,volumes: [hostPathVolume(mountPath:'/var/run/docker.sock',hostPath: '/var/run/docker.sock'),]
            )
        }
    }

    stages{

        stage('checkout'){
            steps{
                git branch: 'main', credentialsId: 'github-creds', url: 'git@github.com:OfekSD/fib_calculator_k8s.git'
            }
        }
        
        if (anyOf { changeset "server/**" }){
            service_pipe('server')
        }
        if (anyOf { changeset "worker/**" }){
        service_pipe('worker')
        }
        if (anyOf { changeset "client/**" }){
        service_pipe('client')
        }
    }
}
