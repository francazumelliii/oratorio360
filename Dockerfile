# Usa un'immagine base di OpenJDK
FROM openjdk:17-jdk-slim as build


# Imposta la cartella di lavoro nel container
WORKDIR /app

# Copia il pom.xml nel container
COPY spring-oratorio360-be/pom.xml /app/pom.xml


# Copia il codice sorgente nel container
COPY spring-oratorio360-be/src /app/src

# Esegui la build del progetto (senza test per velocizzare)
RUN ./mvnw clean install -DskipTests

# Usa un'immagine di base leggera per l'esecuzione
FROM openjdk:17-jdk-slim

# Imposta la cartella di lavoro nel container
WORKDIR /app

# Copia il file jar generato dalla build
COPY --from=build /app/target/*.jar /app/app.jar

# Esegui l'applicazione
ENTRYPOINT ["java", "-jar", "app.jar"]
