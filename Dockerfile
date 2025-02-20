# Usa un'immagine con Maven per la build
FROM maven:3.8.7-eclipse-temurin-17 AS build

# Imposta la directory di lavoro
WORKDIR /app

# Copia i file di configurazione di Maven
COPY pom.xml ./

# Scarica le dipendenze per velocizzare la build
RUN mvn dependency:go-offline

# Copia il codice sorgente
COPY src ./src

# Compila il progetto
RUN mvn clean package -DskipTests

# Usa un'immagine più leggera per eseguire l'app
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copia il JAR dalla fase di build
COPY --from=build /app/target/*.jar app.jar

# Comando di avvio
CMD ["java", "-jar", "app.jar"]
