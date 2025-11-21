#!/bin/bash

set -e

echo -e "Building the petclinic"

mvn clean package -Pprocess-aot

cp -f target/spring-petclinic-3.5.0-SNAPSHOT.jar spring-petclinic-3.5.0-SNAPSHOT/spring-petclinic-3.5.0-SNAPSHOT.jar

echo -e "Petclinic built. Creating JSA Archive"

bash create_jsa_archive.sh

echo -e "JSA Archive created. Launching Candidates"

bash launch_all.sh

grep -o -R -Ei "Started PetClinicApplication in [0-9]\.[0-9]{1,3}" log/
