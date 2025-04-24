## Étape 1 : base Java (Java 23 slim)
#FROM openjdk:23-jdk-slim
#
## Crée un dossier de travail dans le conteneur
#WORKDIR /app
#
## Copie du fichier JAR (assure-toi qu’il existe bien à ce chemin)
#COPY ./target/prod-0.0.1-SNAPSHOT.jar app.jar
#
## Démarrage de l'application
#ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=docker"]


# Étape 1 : Utiliser une image de Maven pour construire le .jar
FROM maven:3.8.4-openjdk-11-slim AS build

# Copier le code source dans l'image
WORKDIR /app
COPY . .

# Construire le .jar
RUN mvn clean package -DskipTests

# Étape 2 : Utiliser une image Java pour exécuter le .jar
FROM openjdk:11-jre-slim

# Créer un répertoire pour l'application
WORKDIR /app

# Copier le fichier .jar depuis l'étape de build
COPY --from=build /app/target/mon-application.jar /app/mon-application.jar

# Exposer le port
EXPOSE 8080

# Commande pour démarrer l'application
CMD ["java", "-jar", "mon-application.jar"]
