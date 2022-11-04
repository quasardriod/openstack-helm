# OpenStack Helm

## Purpose

Setup system pre-requisites of machines for the easy deployment of k8s and openstack using opensource [openstack helm](https://docs.openstack.org/openstack-helm/latest/) project.

* [Gate-Based Kubernetes](https://docs.openstack.org/openstack-helm/latest/install/kubernetes-gate.html)
* [Multi node deployment](https://docs.openstack.org/openstack-helm/latest/install/multinode.html)

## Features & changes list
- Disable biosdevname
- Disable IPv6
- Configure Static IP
- Install Google Cloud repo GPG Key
- Generate inventory for OSH multinode deployment
- Add new worker node to cluster deployed using kubeadm
- Automatically skip already added worker nodes on running `./add-worker.sh`

## Requirements

**System Requirements:**
- Ansible controller:
	- cpu: 2
	- memory: 4GB
	- Packages:
		- ansible-core 2.12+
		- ansible-galaxy
		- python3
		- pip3

- K8s master:
	- cpu: 6+
	- memory: 8GB+

- K8s worker:
	- cpu: 2+
	- memory: 4GB+


## Clone code in ansible controller
```bash
git clone --recurse-submodules https://github.com/quasarenergy/openstack-helm.git
```

## Prerequisites: Install ansible in ansible controller:

-  Install and configure ansible on localhost

```bash
./setup.sh -h
./setup.sh -a
```

## Implementation

Follow below instructions and execute commands on ansible controller.

**1. Inventory and group vars:**

- Update K8s node information and auth creds in `inventory/hosts`. `node_type` in above snippet is K8S node type.

```
[primary]
master ansible_host=192.168.10.236 node_type=master

[nodes]
worker1 ansible_host=192.168.10.235 node_type=worker

[all:vars]
ansible_user=ubuntu
ansible_password=redhat
ansible_become_password=redhat
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```
**2. [Deploy Kubernetes cluster using kubeadm for OpenStack Helm](docs/osh-kubeadm.md)**

**3. [Deploy OpenStack Helm](docs/osh-deploy.md)**
