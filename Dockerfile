
FROM maven:3-jdk-8 
VOLUME /tmp
COPY --from=build_image target/positionsimulator-0.0.1-SNAPSHOT.jar webapp.jar


FROM openjdk:8u131-jre AS build_image
ADD target/positionsimulator-0.0.1-SNAPSHOT.jar webapp.jar
CMD ["java","-Xmx50m","-jar","webapp.jar"]
