#!/bin/bash
ssh root@host01 'echo "Importing middleware Image Streams into OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json -n openshift && break || sleep 2; done'
ssh root@host01 'echo "Importing Decision Server template into OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/decisionserver/decisionserver64-basic-s2i.json -n openshift && break || sleep 2; done'
ssh root@host01 'echo "Logging into OpenShift as developer." >> script.log'
ssh root@host01 'for i in {1..200}; do oc login -u developer -p developer && break || sleep 2; done'
ssh root@host01 'echo "Creating new loan-demo project in OpenShift." >> script.log'
ssh root@host01 'for i in {1..200}; do oc new-project loan-demo --display-name="Loan Demo" --description="Red Hat JBoss BRMS Decision Server Loan Demo" && break || sleep 2; done'
