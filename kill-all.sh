#!/bin/bash

jps | grep -i spring-petclinic | awk '{print $1}' | xargs kill -SIGKILL
