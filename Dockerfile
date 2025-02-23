# Usa un'immagine di base con JDK 17
FROM openjdk:17-jdk-slim AS build

# Imposta la directory di lavoro
WORKDIR /app

# Copia il pom.xml nella directory di lavoro
COPY spring-oratorio360-be/pom.xml /app/pom.xml

# Esegui il comando Maven per scaricare le dipendenze senza compilarle
RUN mvn dependency:go-offline -B

# Copia il codice sorgente nel container
COPY spring-oratorio360-be/src /app/src

# Esegui la build del progetto (senza test per velocizzare)
RUN mvn clean package -DskipTests

# Usa un'immagine di base per l'esecuzione del progetto
FROM openjdk:17-jdk-slim

# Imposta la directory di lavoro
WORKDIR /app

# Copia il file JAR costruito nella fase di build
COPY --from=build /app/target/*.jar /app/app.jar

# Espone la porta su cui il tuo app Spring Boot sta ascoltando
EXPOSE 8080

# Esegui il comando per avviare l'applicazione Spring Boot
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
