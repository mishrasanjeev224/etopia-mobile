node {
    def app

    stage('Clone repository') {
        /* Cloning the Repository to our Workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image */

        app = docker.build("sanjeev224/fonetwish")
    } 

    stage('Push image') {
        /* 
			You would need to first register with DockerHub before you can push images to your account
		*/
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
            } 
                echo "Trying to Push Docker Build to DockerHub"
    }

    stage('Kubernetes Deploy') {
                    sh 'cd /var/lib/jenkins/workspace/Fonetwish-Deployment/fonetwish-helm-chart'
                    sh 'helm upgrade --install fonetwish-app -n fonetwish-test --recreate-pods -f /var/lib/jenkins/workspace/Fonetwish-Deployment/fonetwish-helm-chart/values.yaml --set image.tag=latest /var/lib/jenkins/workspace/Fonetwish-Deployment/fonetwish-helm-chart/.'
    }
}