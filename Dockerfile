# Use Maven image
FROM maven:latest AS build

# work directory setup
WORKDIR /app

# copy pom.xml
COPY ./spring-oratorio360-be/pom.xml /app/

# download Maven dependencies
RUN mvn dependency:go-offline

# copy source code in the container
COPY ./spring-oratorio360-be/src /app/src

# compile maven project and generate .jar
RUN mvn clean package -DskipTests

# runtime: use maven image to run .jar file
FROM openjdk:17-jdk-slim

# work directory setup
WORKDIR /app

# copy .jar file generated during build phase
COPY --from=build /app/target/*.jar app.jar

# expose 8080 port
EXPOSE 8080

# execure SpringBoot application
ENTRYPOINT ["java", "-jar", "app.jar"]


# docker build --platform linux/amd64 -t francazumelli/spring-oratorio360-be:latest .
# docker login
# docker push francazumelli/spring-oratorio360-be:latest