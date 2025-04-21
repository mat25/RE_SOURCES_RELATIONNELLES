# Utiliser une image Java officielle comme base
FROM openjdk:23-jdk-slim AS builder

WORKDIR /app

# Copier le fichier JAR généré par Maven dans l'image Docker
COPY ./target/prod-0.0.1-SNAPSHOT.jar app.jar

# Lancer l'application Spring Boot avec la commande suivante
ENTRYPOINT ["java", "-jar", " .jar"]
