pipeline {
  agent any
  options { timestamps(); timeout(time: 30, unit: 'MINUTES'); buildDiscarder(logRotator(numToKeepStr: '20')) }
  environment { IMAGE_NAME = 'enterprise-wms'; IMAGE_TAG = "${BUILD_NUMBER}" }
  stages {
    stage('Checkout') { steps { checkout scm; sh 'git rev-parse --short HEAD' } }
    stage('Build and Unit Tests') { steps { dir('application') { sh 'mvn -B clean verify' } } }
    stage('SonarQube Analysis') { when { expression { return env.SONARQUBE_SERVER != null } } steps { withSonarQubeEnv('SonarQube') { dir('application') { sh 'mvn -B sonar:sonar' } } } }
    stage('Trivy Filesystem Scan') { steps { sh 'trivy fs --scanners vuln,misconfig,secret --severity HIGH,CRITICAL --exit-code 1 .' } }
    stage('Build Image') { steps { sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ./application' } }
    stage('Trivy Image Scan') { steps { sh 'trivy image --severity HIGH,CRITICAL --exit-code 1 ${IMAGE_NAME}:${IMAGE_TAG}' } }

    stage('Release Container Smoke Test') {
      steps {
        sh '''
          set -eu

          CONTAINER_NAME="enterprise-wms-smoke-${BUILD_NUMBER}"
          IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"

          cleanup() {
            docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
          }

          # Ensure cleanup runs even if a check fails.
          trap cleanup EXIT

          # Remove a leftover container from an earlier attempt.
          cleanup

          echo "Starting isolated release verification container..."
          docker run -d \
            --name "$CONTAINER_NAME" \
            "$IMAGE"

          echo "Waiting for Docker healthcheck..."

          STATUS="starting"

          for attempt in $(seq 1 30); do
            STATUS=$(docker inspect \
              --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}' \
              "$CONTAINER_NAME")

            echo "Health attempt ${attempt}/30: ${STATUS}"

            if [ "$STATUS" = "healthy" ]; then
              break
            fi

            if [ "$STATUS" = "unhealthy" ] ||
               [ "$STATUS" = "no-healthcheck" ]; then
              break
            fi

            sleep 2
          done

          if [ "$STATUS" != "healthy" ]; then
            echo "ERROR: Release container health validation failed."
            docker logs "$CONTAINER_NAME" || true
            exit 1
          fi

          echo "PASS: Release container is healthy."
          docker logs --tail 50 "$CONTAINER_NAME"
        '''
      }
    }

    stage('Publish Image') { when { branch 'main' } steps { echo 'Configure registry credentials and immutable image push after reviewing registry policy.' } }
    stage('Deploy to QA') { when { branch 'main' } steps { echo 'Add environment-specific authenticated deployment and post-deploy smoke tests.' } }
    stage('Production Approval') { when { branch 'main' } steps { input message: 'Approve production promotion after QA evidence review?', ok: 'Approve' } }
  }
  post { always { archiveArtifacts artifacts: 'application/target/surefire-reports/**', allowEmptyArchive: true; junit testResults: 'application/target/surefire-reports/*.xml', allowEmptyResults: true } }
}
