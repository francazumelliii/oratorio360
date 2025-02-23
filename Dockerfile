# Step 1: Usa un'immagine base di Maven per compilare il progetto
FROM maven:3.8.6-openjdk-11 AS build

# Imposta la cartella di lavoro
WORKDIR /app

# Copia il file pom.xml e scarica le dipendenze
COPY spring-oratorio360-be/pom.xml /app/pom.xml

RUN mvn clean install -DskipTests

# Step 2: Usa un'immagine base di OpenJDK per eseguire il jar generato
FROM openjdk:11-jre-slim

# Imposta la cartella di lavoro
WORKDIR /app

# Copia il jar dal contesto di build
COPY --from=build /app/target/*.jar /app/app.jar

# Esponi la porta su cui Spring Boot si avvia
EXPOSE 8080

# Comando per avviare l'applicazione Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
