#!/bin/bash

java -XX:+UnlockDiagnosticVMOptions \
     -Dspring.aot.enabled=true \
     -XX:AOTCacheOutput=app.aot \
     -Dspring.context.exit=onRefresh \
     -Dserver.port=8096 \
     -jar target/spring-petclinic-3.5.0-SNAPSHOT.jar
