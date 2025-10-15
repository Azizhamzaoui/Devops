# Use an official OpenJDK runtime as a parent image
FROM openjdk:21-jdk-slim

# Set a working directory inside the container
WORKDIR /app

# Copy the packaged Spring Boot JAR into the container
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your Spring Boot app runs on
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]

