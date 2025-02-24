# Fase di build: Usa l'immagine Maven con OpenJDK 17 per costruire l'app
FROM maven:latest AS build

# Imposta la directory di lavoro
WORKDIR /app

# Copia il pom.xml e il file di progetto
COPY ./spring-oratorio360-be/pom.xml /app/

# Scarica le dipendenze Maven
RUN mvn dependency:go-offline

# Copia il codice sorgente nel contenitore
COPY ./spring-oratorio360-be/src /app/src

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


# docker build --platform linux/amd64 -t francazumelli/spring-oratorio360-be:latest .
# docker login
# docker push francazumelli/spring-oratorio360-be:latest