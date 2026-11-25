# Multi-stage Docker build for Athenaeum Library (Spring Boot + JSP Executable WAR)
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests -B

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

COPY --from=builder /build/target/library.war /app/library.war

ENV PORT=8080
ENV JAVA_OPTS="-Xms128m -Xmx384m"
EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Dserver.port=${PORT} -jar /app/library.war"]

