#!/bin/bash


echo "Running add-worker.yml playbook" && sleep 5
ansible-playbook -i inventory playbooks/add-worker.yml
[ $? != 0 ] && echo "Hosts pre-config failed" && exit 1


