FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /workspace

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package

FROM eclipse-temurin:21-jre

WORKDIR /app

RUN mkdir -p /app && chown 10001:10001 /app

COPY --from=build --chown=10001:10001 \
    /workspace/target/enterprise-devops-app-1.0.0-SNAPSHOT.jar \
    /app/app.jar

USER 10001:10001

EXPOSE 8085

ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-jar", "/app/app.jar"]
