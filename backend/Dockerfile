# Étape 1 : base Java (Java 23 slim)
FROM openjdk:23-jdk-slim

# Crée un dossier de travail dans le conteneur
WORKDIR /app

# Copie du fichier JAR (assure-toi qu’il existe bien à ce chemin)
COPY ./target/prod-0.0.1-SNAPSHOT.jar app.jar

# Démarrage de l'application
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=docker"]