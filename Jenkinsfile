pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timestamps()
        timeout(time: 30, unit: 'MINUTES')
    }

    environment {
        IMAGE_REPO     = 'charles1984/enterprise-devops-app'
        OCP_SERVER     = 'https://api.rm3.7wse.p1.openshiftapps.com:6443'
        OCP_NAMESPACE  = 'charles-devops-dev'
        OCP_DEPLOYMENT = 'qa-enterprise-admin-app'
        OCP_CONTAINER  = 'enterprise-admin-app'
    }

    stages {
        stage('Build and push image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-charles',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )]) {
                    sh '''
                        set +x
                        set -eu
                        trap 'docker logout >/dev/null 2>&1 || true' EXIT
                        IMAGE="$IMAGE_REPO:$BUILD_NUMBER"
                        printf '%s' "$DOCKERHUB_TOKEN" |
                            docker login --username "$DOCKERHUB_USER" --password-stdin
                        docker build -t "$IMAGE" .
                        docker push "$IMAGE"
                    '''
                }
            }
        }

        stage('Deploy to OpenShift QA') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'openshift-deployer-token',
                        variable: 'OCP_TOKEN'
                    ),
                    file(
                        credentialsId: 'openshift-api-ca',
                        variable: 'OCP_CA'
                    )
                ]) {
                    sh '''
                        set +x
                        set -eu
                        umask 077
                        export KUBECONFIG="$(mktemp)"
                        trap 'rm -f "$KUBECONFIG"' EXIT

                        kubectl config set-cluster openshift \
                            --server="$OCP_SERVER" \
                            --certificate-authority="$OCP_CA"
                        kubectl config set-credentials jenkins-deployer \
                            --token="$OCP_TOKEN"
                        kubectl config set-context qa \
                            --cluster=openshift \
                            --user=jenkins-deployer \
                            --namespace="$OCP_NAMESPACE"

                        IMAGE="$IMAGE_REPO:$BUILD_NUMBER"
                        kubectl --context=qa -n "$OCP_NAMESPACE" \
                            set image "deployment/$OCP_DEPLOYMENT" \
                            "$OCP_CONTAINER=$IMAGE"
                        kubectl --context=qa -n "$OCP_NAMESPACE" \
                            rollout status "deployment/$OCP_DEPLOYMENT" \
                            --timeout=300s
                    '''
                }
            }
        }
    }
}
