#!/bin/bash

: ${INVENTORY:="inventory/hosts"}

anisble_setup(){
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

  pip3 install ansible-core --user

  git submodule update --init
  git submodule update --remote --merge
  
  echo "Installing ansible collections"
  ansible-galaxy collection install community.crypto
  ansible-galaxy collection install ansible.posix
}

##--------- Functions to install kubernetes cluster using kubeadm ----------------
pre_setup_hosts(){
  PLAYBOOK="playbooks/hosts-setup.yml"
  echo "Running $PLAYBOOK" && sleep 5
  ansible-playbook -i $INVENTORY $PLAYBOOK
  [ $? != 0 ] && echo "Hosts pre-config failed" && exit 1
}

presetup_kubeadm(){
  MULTINODE=true
  PLAYBOOK="playbooks/kubeadm-presetup.yml"
  echo "Running $PLAYBOOK" && sleep 5
  ansible-playbook -i $INVENTORY $PLAYBOOK -e multinode_deployment=$MULTINODE
  [ $? != 0 ] && echo "K8s pre-config failed" && exit 1
}

install_kubeadm(){
  MULTINODE=true
  PLAYBOOK="playbooks/install-kubeadm.yml"
  echo "Running $PLAYBOOK" && sleep 5
  ansible-playbook -i $INVENTORY $PLAYBOOK -e multinode_deployment=$MULTINODE
  [ $? != 0 ] && echo "K8s installation failed" && exit 1
}

## ------------ Functions to install openstack helm --------------

pull_inventory_to_local(){
  echo
  echo "Prepare OSH to start installation. Running playbook prepare-osh-inventory.yml"
  ansible-playbook -i inventory playbooks/prepare-osh-inventory.yml
}

install_osh(){
  #pull_inventory_to_local

  PLAYBOOK="$PWD/playbooks/files/openstack-helm/tools/gate/playbooks/multinode.yaml"

  cd playbooks/files/openstack-helm
  echo
  echo "PWD: $PWD"
  echo
  echo "Running $PLAYBOOK"
  ansible-playbook -i $INVENTORY $PLAYBOOK
}

usages(){
	echo
  echo " -a Install ansible and galaxy collections on localhost - MUST RUN ON FIRST SETUP"
  echo " -p Pre-setup target nodes - OS tuning"
  echo " -s Setup target nodes to deploy kubernetes using kubeadm"
  echo " -k Install kubeadm cluster"
  echo " -o Install Openstack Helm"
  echo " -h Show this help message"
  echo
	exit 0
}

while getopts 'apskoh' opt; do
  case $opt in
    a) anisble_setup;;
    p) pre_setup_hosts;;
    s) presetup_kubeadm;;
    k) install_kubeadm;;
    o) install_osh;;
    h) usages;;
    \?|*) echo "Invalid Option: -$OPTARG" && usages;;
  esac
done
