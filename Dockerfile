# Usa un'immagine di Maven per la build
FROM maven:3.8.7-eclipse-temurin-17 AS build

# Imposta la directory di lavoro
WORKDIR /app

# Copia il pom.xml
COPY spring-oratorio360-be/pom.xml ./

# Scarica le dipendenze
RUN mvn dependency:go-offline

# Copia la cartella src dalla posizione corretta
COPY spring-oratorio360-be/src ./src

# Compila il progetto e genera il JAR
RUN mvn clean package -DskipTests

# Usa un'immagine più leggera per eseguire l'app
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copia il JAR generato dalla fase di build
COPY --from=build /app/target/*.jar app.jar

# Comando di avvio
CMD ["java", "-jar", "app.jar"]
