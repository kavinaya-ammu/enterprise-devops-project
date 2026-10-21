FROM jenkins/jenkins:lts-jdk21

USER root

# Use HTTPS for Debian repositories
RUN if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
      sed -i 's|http://deb.debian.org|https://deb.debian.org|g' \
        /etc/apt/sources.list.d/debian.sources; \
    fi \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       maven docker.io curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG TRIVY_VERSION=0.76.0

RUN curl -fsSL \
    -o /tmp/trivy.deb \
    "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.deb" \
    && dpkg -i /tmp/trivy.deb \
    && rm -f /tmp/trivy.deb

USER jenkins
