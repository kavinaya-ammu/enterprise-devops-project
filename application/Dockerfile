FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /workspace
COPY pom.xml .
COPY src ./src
RUN mvn -B -DskipTests=false clean verify

FROM eclipse-temurin:17-jre-jammy
RUN sed -i 's|http://security.ubuntu.com/ubuntu|https://security.ubuntu.com/ubuntu|g; s|http://archive.ubuntu.com/ubuntu|https://archive.ubuntu.com/ubuntu|g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --uid 10001 --create-home appuser

WORKDIR /app
COPY --from=build /workspace/target/enterprise-wms.jar /app/app.jar
USER 10001
EXPOSE 8085
ENV SERVER_PORT=8085
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError"
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 CMD ["curl", "-fsS", "http://127.0.0.1:8085/actuator/health"]
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
