#!/bin/bash
sed -i 's/\.environments\.katacoda\.com/.openstack-environments.katacoda.com/g' /openshift.local.config/master/master-config.yaml && systemctl restart origin && ~/.launch.sh
#~/.launch.sh
~/.init/init-scenario.sh
