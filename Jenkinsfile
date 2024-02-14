

def service_pipe(service_name){    
        stage('${service_name} - Test Code'){
            container('node') {
            dir('${service_name}'){
                sh 'npm install'
                sh 'npm test'
            }
            }
        }
        stage('${service_name} - Build Image'){
            container('docker') {
                app = docker.build('pandalamdta/${service_name}')
            }
        }
        stage('${service_name} - Push image') {
            container('docker') {
                docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                    app.push("${env.BUILD_NUMBER}")
                    app.push("latest")
                }
            }
        }
}
podTemplate(containers:
    [containerTemplate(name: 'node', image: 'node:16-alpine', command: 'sleep', args: 'infinity'),
    containerTemplate(name: 'docker', image: 'docker', command: 'sleep', args: 'infinity'),],
    ,volumes: [hostPathVolume(mountPath:'/var/run/docker.sock',hostPath: '/var/run/docker.sock'),]
    ){
    node(POD_LABEL) {
        def app
        stage('checkout'){
        git branch: 'main', credentialsId: 'github-creds', url: 'git@github.com:OfekSD/fib_calculator_k8s.git'
        }
        stage{

        }
        stage('server'){
            service_pipe('server')
        }
        stage('worker'){
            service_pipe('worker')
        }
        stage('client'){
            service_pipe('client')
        }
    }
}
