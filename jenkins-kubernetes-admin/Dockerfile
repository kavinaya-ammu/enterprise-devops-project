FROM registry.redhat.io/jboss-eap-8/eap81-openjdk17-runtime-openshift-rhel9:latest

COPY --chown=jboss:root target/devops-admin-demo-2.0.war \
    /opt/server/standalone/deployments/devops-admin-demo.war

EXPOSE 8080
