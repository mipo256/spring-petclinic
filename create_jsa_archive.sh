#!/bin/bash

java -XX:+UnlockDiagnosticVMOptions \
     -Dspring.aot.enabled=true \
     -Xshare:on \
     -XX:ArchiveClassesAtExit=application.jsa \
     -Dspring.context.exit=onRefresh \
     -XX:+AllowArchivingWithJavaAgent \
     -Dserver.port=8096 \
     -jar target/spring-petclinic-3.5.0-SNAPSHOT.jar
