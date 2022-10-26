# OpenStack Helm

## Purpose

Setup system pre-requisites of machines for the easy deployment of k8s and openstack using opensource [openstack helm](https://docs.openstack.org/openstack-helm/latest/) project.

* [Gate-Based Kubernetes](https://docs.openstack.org/openstack-helm/latest/install/kubernetes-gate.html)
* [Multi node deployment](https://docs.openstack.org/openstack-helm/latest/install/multinode.html)

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

**Install ansible in ansible controller:**

```bash
pip3 install ansible-core --user
```

Following collections will be installed in ansible controller:

```
ansible-galaxy collection install community.crypto
ansible-galaxy collection install ansible.posix
```


## Features & changes list
- Disable biosdevname
- Disable IPv6
- Configure Static IP
- Install Google Cloud repo GPG Key
- Generate inventory for OSH multinode deployment
- Add new worker node to cluster deployed using kubeadm
- Automatically skip already added worker nodes on running `./add-worker.sh`

## Implementation

1. Clone code in ansible controller
```bash
git clone --recurse-submodules https://github.com/quasarenergy/openstack-helm.git
```

2. Update K8s node information and auth creds in inventory. `node_type` in above snippet is K8S node type

```
master ansible_host=192.168.10.235 node_type=master
worker1 ansible_host=192.168.10.17 node_type=worker

[all:vars]
ansible_user=ubuntu
ansible_password=redhat
ansible_become_password=redhat
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

3. Run below script in ansible controller to push pre-requisites changes for multinode k8s deployment
```bash
./multinode.sh
```

4. Login in k8s master and run below commands [source: Run the playbooks](https://docs.openstack.org/openstack-helm/latest/install/kubernetes-gate.html). These commands will deploy only k8s master.
	- Run command as `ansible_user` in inventory. Do not run as root.

```bash
cd /opt/openstack-helm-infra
make dev-deploy setup-host multinode
make dev-deploy k8s multinode
```

5. Run below script in ansible controller to add worker nodes in existing cluster
```bash
./add-worker.sh
```
