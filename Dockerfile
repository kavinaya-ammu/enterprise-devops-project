# ============================================================
# Stage 1: Provision JBoss EAP 8.1 server
# ============================================================
FROM registry.redhat.io/jboss-eap-8/eap81-openjdk17-builder-openshift-rhel9:latest AS builder

ENV GALLEON_PROVISION_FEATURE_PACKS="org.jboss.eap:wildfly-ee-galleon-pack,org.jboss.eap.cloud:eap-cloud-galleon-pack"
ENV GALLEON_PROVISION_LAYERS="cloud-default-config"
ENV GALLEON_PROVISION_CHANNELS="org.jboss.eap.channels:eap-8.1"

RUN /usr/local/s2i/assemble


# ============================================================
# Stage 2: Runtime
# ============================================================
FROM registry.redhat.io/jboss-eap-8/eap81-openjdk17-runtime-openshift-rhel9:latest

COPY --from=builder --chown=jboss:root /opt/server /opt/server

COPY --chown=jboss:root \
     target/enterprise-devops-app-1.0.0-SNAPSHOT.war \
     /opt/server/standalone/deployments/enterprise-devops-app.war
