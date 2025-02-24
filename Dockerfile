# Fase di build: Usa l'immagine Maven per costruire l'app
FROM maven:3.8.6-openjdk-17-slim AS build

# Imposta la directory di lavoro
WORKDIR /app

# Copia il pom.xml e il file di progetto
COPY spring-oratorio360-be/pom.xml ./

# Scarica le dipendenze Maven
RUN mvn dependency:go-offline

# Copia il codice sorgente nel contenitore
COPY spring-oratorio360-be/src ./src

# Compila il progetto Maven e crea il file .jar
RUN mvn clean package -DskipTests

# Fase di runtime: Usa l'immagine di Java per eseguire il file .jar
FROM openjdk:17-jdk-slim

# Imposta la directory di lavoro
WORKDIR /app

# Copia il file .jar generato dalla fase di build
COPY --from=build /app/target/*.jar app.jar

# Espone la porta su cui il server Spring Boot sarà in ascolto
EXPOSE 8080

# Esegui l'applicazione Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
