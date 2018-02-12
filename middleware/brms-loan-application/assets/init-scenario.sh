#/bin/bash
echo "Initialing environment... This may take a couple of moments."
echo

#Wait for the brms image to be pulled
#echo "Waiting for BRMS Docker Image to be pulled."
#until docker images duncandoyle/jboss-brms | grep "6.4"; do  echo -n . && sleep 5; done
#echo

#Wait for Container image to start
#echo "Waiting for BRMS Docker Container to start"
#until docker ps | grep "jboss-brms"; do echo -n . && sleep 5; done
#echo

#Wait for Business Central OpenShift deployment
echo "Waiting for the Red Hat Decision Manager workbench OpenShift Container to start"
until oc project loan-demo &>2; do echo -n . && sleep 5; done
until oc get dc/loan-demo-rhdmcentr &>2; do echo -n . && sleep 5; done
oc rollout status "dc/loan-demo-rhdmcentr" -n loan-demo
echo

#Wait for BRMS workbench availability
echo "Waiting for the Red Hat Decision Manager workbench to become available"
export DC_HOST=$(oc describe route "loan-demo-rhdmcentr" | grep "Requested Host" | sed 's/Requested Host://' | tr -d '[:blank:]')
until [ $(curl -sL -w "%{http_code}\\n" "http://$DC_HOST/kie-drools-wb.jsp" -o /dev/null) == 200 ]; do echo -n . && sleep 5; done
echo

echo "Enviroment ready!"
