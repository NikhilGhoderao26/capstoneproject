pipeline {
  agent any

  parameters {
    string(name: 'REGISTRY', defaultValue: 'docker.io', description: 'Container registry (e.g. docker.io)')
    string(name: 'IMAGE_PREFIX', defaultValue: 'NikhilGhoderao26/capstoneproject', description: 'Image prefix/repo (e.g. ghcr.io/org/repo)')
    string(name: 'K8S_NAMESPACE', defaultValue: 'capstoneproject', description: 'Kubernetes namespace to deploy into')
  }

  environment {
    SERVICES = "product-service order-service inventory-service frontend"
    TAG = "${env.BUILD_NUMBER ?: 'latest'}"
    K8S_MANIFEST_DIR = 'k8s'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build frontend') {
      steps {
        dir('frontend') {
          sh 'npm install --silent'
          sh 'npm run build'
        }
      }
    }

    stage('Build images') {
      steps {
        script {
          sh "docker build -t ${params.REGISTRY}/${params.IMAGE_PREFIX}-product-service:${env.TAG} ./product-service"
          sh "docker build -t ${params.REGISTRY}/${params.IMAGE_PREFIX}-order-service:${env.TAG} ./order-service"
          sh "docker build -t ${params.REGISTRY}/${params.IMAGE_PREFIX}-inventory-service:${env.TAG} ./inventory-service"
          sh "docker build -t ${params.REGISTRY}/${params.IMAGE_PREFIX}-frontend:${env.TAG} ./frontend"
        }
      }
    }

    stage('Push images') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-registry-creds', usernameVariable: 'REG_USER', passwordVariable: 'REG_PASS')]) {
          sh 'echo $REG_PASS | docker login -u $REG_USER --password-stdin ${params.REGISTRY}'
          sh "docker push ${params.REGISTRY}/${params.IMAGE_PREFIX}-product-service:${env.TAG}"
          sh "docker push ${params.REGISTRY}/${params.IMAGE_PREFIX}-order-service:${env.TAG}"
          sh "docker push ${params.REGISTRY}/${params.IMAGE_PREFIX}-inventory-service:${env.TAG}"
          sh "docker push ${params.REGISTRY}/${params.IMAGE_PREFIX}-frontend:${env.TAG}"
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
          sh "kubectl --kubeconfig=$KUBECONFIG apply -f ${env.K8S_MANIFEST_DIR} --namespace=${params.K8S_NAMESPACE} || true"
          sh "kubectl --kubeconfig=$KUBECONFIG -n ${params.K8S_NAMESPACE} set image deployment/product-deployment product=${params.REGISTRY}/${params.IMAGE_PREFIX}-product-service:${env.TAG} --record || true"
          sh "kubectl --kubeconfig=$KUBECONFIG -n ${params.K8S_NAMESPACE} set image deployment/order-deployment order=${params.REGISTRY}/${params.IMAGE_PREFIX}-order-service:${env.TAG} --record || true"
          sh "kubectl --kubeconfig=$KUBECONFIG -n ${params.K8S_NAMESPACE} set image deployment/inventory-deployment inventory=${params.REGISTRY}/${params.IMAGE_PREFIX}-inventory-service:${env.TAG} --record || true"
          sh "kubectl --kubeconfig=$KUBECONFIG -n ${params.K8S_NAMESPACE} set image deployment/frontend-deployment frontend=${params.REGISTRY}/${params.IMAGE_PREFIX}-frontend:${env.TAG} --record || true"
        }
      }
    }
  }

  post {
    always {
      echo 'Pipeline finished.'
    }
  }
}
