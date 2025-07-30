#!/bin/bash

set -e

mkdir -p "$(dirname $0)/log"

# Regular
java -Dvisualvm.display.name="Regular" \
 -Dspring.application.name="Regular" \
 -Dserver.port=8080 \
 -Xmx200m \
 -Xms10m \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>>log/launch.txt &

# AOT Bean definitions
java -Dvisualvm.display.name="AOT_Bean_definitions" \
 -Dspring.application.name="AOT Bean definitions" \
 -Dserver.port=8081 \
 -Dspring.aot.enabled=true  \
 -Xmx200m \
 -Xms10m \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>>log/launch.txt &

# Regular + AppCDS
java -Dvisualvm.display.name="Regular_AppCDS" \
 -Dspring.application.name="Regular + AppCDS" \
 -Dserver.port=8082 \
 -Xmx200m \
 -Xms10m \
 -XX:SharedArchiveFile=application.jsa \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>>log/launch.txt &

# AOT Bean definitions + AppCDS
java -Dvisualvm.display.name="AOT_Bean_definitions_AppCDS" \
 -Dspring.application.name="AOT Bean definitions + AppCDS" \
 -Dserver.port=8083 \
 -Xmx200m \
 -Xms10m \
 -XX:SharedArchiveFile=application.jsa \
 -Dspring.aot.enabled=true \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>>log/launch.txt &

cat log/launch.txt | grep -i "Started PetClinicApplication"

# jps | grep -i spring-petclinic | awk '{print $1}' | xargs kill -SIGKILL

truncate -s 0 log/launch.txt
