#!/bin/bash

# Setup template

cd roles && git pull
cd ../

echo "Running hosts-setup.yml playbook" && sleep 5
ansible-playbook -i inventory playbooks/hosts-setup.yml
[ $? != 0 ] && echo "Hosts pre-config failed" && exit 1

echo "Running osh-setup.yml playbook" && sleep 5
ansible-playbook -i inventory playbooks/osh-setup.yml
[ $? != 0 ] && echo "K8s pre-config failed" && exit 1


