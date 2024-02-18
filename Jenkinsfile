def app
pipeline{
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
                when { changeset "server/**"}
                steps{
                    container('node') {
                    dir("server"){
                        sh 'npm install'
                        sh 'npm test'
                    }
                    }
                }
        }
        stage("server - Build Image"){
                when { changeset "server/**"}
                steps{
                    container('docker') {

                    dir("server"){
                    script{
                        app = docker.build("pandalamdta/server")
                    }
                    }
                    }
                }
        }
        stage("server - Push image") {
                when { changeset "server/**"}
                steps{
                    container('docker') {
                    script{
                        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                            app.push("${env.BUILD_NUMBER}")
                            app.push("latest")
                        }
                    }
                    }
                }
        }
        stage("worker - Test Code"){
            when { changeset "worker/**"}
            steps{
                container('node') {
                dir("worker"){
                    sh 'npm install'
                    sh 'npm test'
                }
                }
            }
        }
        stage("worker - Build Image"){
                when { changeset "worker/**"}
                steps{
                    container('docker') {
                    dir("worker"){
                        script{
                            app = docker.build("pandalamdta/worker")
                        }
                    }
                    }
                }
        }
        stage("worker - Push image") {
                when { changeset "worker/**"}
                steps{
                    container('docker') {
                        script{

                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                        }
                    }
                }
        }
        stage("client - Test Code"){
            when { changeset "client/**"}
            steps{
                container('node') {
                    dir("client"){
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }
        stage("client - Build Image"){
                when { changeset "client/**"}
                steps{
                    container('docker') {
                    dir("client"){
                        script{
                        app = docker.build("pandalamdta/client")
                        }
                    }
                    }
                }
        }
        stage("client - Push image") {
                when { changeset "client/**"}
                steps{
                    container('docker') {
                        script{

                        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                            app.push("${env.BUILD_NUMBER}")
                            app.push("latest")
                        }
                        }
                    }
                }
        }
    }
}
