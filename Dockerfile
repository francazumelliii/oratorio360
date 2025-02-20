# Usa un'immagine di base con Maven per la build
FROM maven:3.8.6-eclipse-temurin-17 AS build

# Imposta la cartella di lavoro
WORKDIR /app

# Copia il codice sorgente
COPY . .

# Compila il progetto e genera il .jar
RUN mvn clean package -DskipTests

# Usa un'immagine più leggera per eseguire l'app
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copia il file .jar dalla fase di build
COPY --from=build /app/target/*.jar app.jar

# Espone la porta dell'app (modifica se necessario)
EXPOSE 8080

# Comando per avviare l'app
CMD ["java", "-jar", "app.jar"]
