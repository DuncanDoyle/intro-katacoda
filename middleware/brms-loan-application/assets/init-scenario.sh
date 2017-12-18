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
echo "Waiting for the JBoss BRMS workbench OpenShift Container to start"
until oc project loan-demo &>2; do echo -n . && sleep 5; done
oc rollout status dc/jboss-bpmsuite -n loan-demo
echo

#Wait for BRMS workbench availability
echo "Waiting for the BRMS workbench to become available"
export BC_HOST=oc describe route jboss-bpmsuite | grep "Requested Host" | sed 's/Requested Host://' | tr -d '[:blank:]'
until [ $(curl -sL -w "%{http_code}\\n" "http://$BC_HOST/business-central" -o /dev/null) == 200 ]; do echo -n . && sleep 5; done
echo

echo "Logging into OpenShift with 'developer' account."
oc login -u developer -p developer
echo

echo "Logging into the OpenShift loan-demo project."
oc project loan-demo
echo

echo "Enviroment ready!"
