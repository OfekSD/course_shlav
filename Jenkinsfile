def service_pipe(service_name){    
        def app
        stage("worker - Test Code"){
            container('node') {
                steps{
                    dir("worker"){
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }
        stage("worker - Build Image"){
            container('docker') {
                steps{
                    dir("worker"){
                        app = docker.build("pandalamdta/worker")
                    }
                }
            }
        }
        stage("worker - Push image") {
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
        
        stage("server - Test Code"){
            container('node') {
                when { changeset "server/**"}
                steps{
                    dir("server"){
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }
        stage("server - Build Image"){
            def app
            container('docker') {
                when { changeset "server/**"}
                steps{
                    dir("server"){
                        app = docker.build("pandalamdta/server")
                    }
                }
            }
        }
        stage("server - Push image") {
            container('docker') {
                when { changeset "server/**"}
                steps{
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
                stage("worker - Test Code"){
            container('node') {
                when { changeset "worker/**"}
                steps{
                    dir("worker"){
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }
        stage("worker - Build Image"){
            def app
            container('docker') {
                when { changeset "worker/**"}
                steps{
                    dir("worker"){
                        app = docker.build("pandalamdta/worker")
                    }
                }
            }
        }
        stage("worker - Push image") {
            container('docker') {
                when { changeset "worker/**"}
                steps{
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
                stage("client - Test Code"){
            container('node') {
                when { changeset "client/**"}
                steps{
                    dir("client"){
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }
        stage("client - Build Image"){
            def app
            container('docker') {
                when { changeset "client/**"}
                steps{
                    dir("client"){
                        app = docker.build("pandalamdta/client")
                    }
                }
            }
        }
        stage("client - Push image") {
            container('docker') {
                when { changeset "client/**"}
                steps{
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
    }
}
