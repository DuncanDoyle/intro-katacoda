#!/bin/sh
export PATH=$GRAALVM_HOME/bin:$PATH

mkdir -p /root/projects/kogito
cd /root/projects/kogito
clear

# Clone our Coffee service
git clone git@github.com:DuncanDoyle/coffeeservice-quarkus.git /root/projects/kogito
