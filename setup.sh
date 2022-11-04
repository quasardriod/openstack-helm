#!/bin/bash

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

  cd roles && git pull
  cd ../

  echo "Installing ansible collections"
  ansible-galaxy collection install community.crypto
  ansible-galaxy collection install ansible.posix
}

pre_setup_hosts(){
  echo "Running hosts-setup.yml playbook" && sleep 5
  ansible-playbook -i inventory playbooks/hosts-setup.yml
  [ $? != 0 ] && echo "Hosts pre-config failed" && exit 1
}

presetup_kubeadm(){
  MULTINODE=true
  echo "Running osh-setup.yml playbook" && sleep 5
  ansible-playbook -i inventory playbooks/osh-setup.yml -e multinode_deployment=$MULTINODE
  [ $? != 0 ] && echo "K8s pre-config failed" && exit 1
}


install_kubeadm(){
  MULTINODE=true
  echo "Running install-kubeadm.yml playbook" && sleep 5
  ansible-playbook -i inventory playbooks/install-kubeadm.yml -e multinode_deployment=$MULTINODE
  [ $? != 0 ] && echo "K8s installation failed" && exit 1
}

usages(){
	echo
  echo " -a Install ansible and galaxy collections on localhost - MUST RUN ON FIRST SETUP"
  echo " -p Pre-setup target nodes - OS tuning"
  echo " -s Setup target nodes to deploy kubernetes using kubeadm"
  echo " -k Install kubeadm cluster"
  echo " -h Show this help message"
  echo
	exit 0
}


while getopts 'apskh' opt; do
  case $opt in
    a) anisble_setup;;
    p) pre_setup_hosts;;
    s) presetup_kubeadm;;
    k) install_kubeadm;;
    h) usages;;
    \?|*) echo "Invalid Option: -$OPTARG" && usages;;
  esac
done
