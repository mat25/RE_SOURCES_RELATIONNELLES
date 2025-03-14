# Utiliser une image Java officielle comme base
FROM openjdk:23-jdk-slim as builder

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier le fichier JAR généré par Maven dans l'image Docker
COPY target/prod-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port sur lequel l'application va tourner
EXPOSE 8080

# Lancer l'application Spring Boot avec la commande suivante
ENTRYPOINT ["java", "-jar", "app.jar"]
