#!/bin/bash

set -e

# AOT Bean definitions + AppCDS
java -Dvisualvm.display.name=AOT_Bean_definitions_AppCDS \
 -Dspring.application.name=AOT_Bean_definitions_AppCDS \
 -Dserver.port=8083 \
 -Xmx400m \
 -Xms200m \
 -XX:AOTCache=app.aot \
 -Dspring.aot.enabled=true \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>log/launch-aot-cache.txt &

