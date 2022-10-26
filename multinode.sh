#!/bin/bash

MULTINODE=true

if ! which pip3 > /dev/null 2>&1;then
	if egrep -q "ID=ubuntu" /etc/os-release;then
		sudo apt update
		sudo apt install python3-pip -y
	fi
fi

if ! which ansible-galaxy > /dev/null 2>&1;then
	if egrep -q "ID=ubuntu" /etc/os-release;then
		sudo apt update
		sudo apt install ansible -y
	fi
fi

cd roles && git pull
cd ../

echo "Installing ansible collections"
ansible-galaxy collection install community.crypto
ansible-galaxy collection install ansible.posix

echo
echo "Running hosts-setup.yml playbook" && sleep 5
ansible-playbook -i inventory playbooks/hosts-setup.yml
[ $? != 0 ] && echo "Hosts pre-config failed" && exit 1

echo "Running osh-setup.yml playbook" && sleep 5
ansible-playbook -i inventory playbooks/osh-setup.yml -e multinode_deployment=$MULTINODE
[ $? != 0 ] && echo "K8s pre-config failed" && exit 1


