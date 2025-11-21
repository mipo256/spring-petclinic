#!/bin/bash

set -e

mkdir -p "$(dirname $0)/log"

EXISTING_JAVA_PROCESSES=$(jps | grep -i spring-petclinic | awk '{print $1}')

if [[ -n $EXISTING_JAVA_PROCESSES ]]; then
  echo "Killing existing processes $EXISTING_JAVA_PROCESSES"
  echo $EXISTING_JAVA_PROCESSES | xargs kill -SIGKILL
fi

truncate -s 0 log/launch-aot.txt
truncate -s 0 log/launch-aot-appcds.txt

# Regular
java -Dvisualvm.display.name=Regular \
 -Dspring.application.name=Regular \
 -Dserver.port=8080 \
 -Xmx400m \
 -Xms200m \
 -XX:NativeMemoryTracking=summary \
 -XX:+UnlockDiagnosticVMOptions \
 -XX:+PrintNMTStatistics \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>log/launch.txt &

# AOT Bean definitions
java -Dvisualvm.display.name=AOT_Bean_definitions \
 -Dspring.application.name=AOT_Bean_definitions \
 -Dserver.port=8081 \
 -Dspring.aot.enabled=true  \
 -Xmx400m \
 -Xms200m \
 -XX:NativeMemoryTracking=summary \
 -XX:+UnlockDiagnosticVMOptions \
 -XX:+PrintNMTStatistics \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>log/launch-aot.txt &

# Regular + AppCDS
java -Dvisualvm.display.name=Regular_AppCDS \
 -Dspring.application.name=Regular_AppCDS \
 -Dserver.port=8082 \
 -Xmx400m \
 -Xms200m \
 -XX:+UnlockDiagnosticVMOptions \
 -XX:+AllowArchivingWithJavaAgent \
 -XX:SharedArchiveFile=application.jsa \
 -XX:NativeMemoryTracking=summary \
 -XX:+PrintNMTStatistics \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>log/launch-appcds.txt &

# AOT Bean definitions + AppCDS
java -Dvisualvm.display.name=AOT_Bean_definitions_AppCDS \
 -Dspring.application.name=AOT_Bean_definitions_AppCDS \
 -Dserver.port=8083 \
 -Xmx400m \
 -XX:+UnlockDiagnosticVMOptions \
 -XX:+AllowArchivingWithJavaAgent \
 -Xms200m \
 -XX:SharedArchiveFile=application.jsa \
 -XX:NativeMemoryTracking=summary \
 -XX:+PrintNMTStatistics \
 -Dspring.aot.enabled=true \
 -jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar &>log/launch-aot-appcds.txt &

#cat log/launch.txt | grep -i "Started PetClinicApplication"

echo "sleeping..."

sleep 15

echo "testing instances..."

PORTS=(8080 8081 8082 8083)

for p in "${PORTS[@]}"; do
  curl -q "http://localhost:$p"
  curl -q "http://localhost:$p/vets.html"
  curl -q "http://localhost:$p/owners/find"
done

echo "tested all"
