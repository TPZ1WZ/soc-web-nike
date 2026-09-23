# ⚠️ LAB SOC — build image cho ứng dụng web (Spring Boot, Java 21)
# Multi-stage: build bằng Maven -> chạy bằng JRE nhẹ
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -B -e dependency:go-offline || true
COPY src ./src
RUN mvn -q -B -DskipTests package

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
# thư mục log + upload sẽ được mount ra host cho Wazuh đọc
RUN mkdir -p /app/logs /app/uploads
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
