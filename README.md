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

- Run following commands to install ansible on localhost
```bash
pip3 install ansible-core --user
```

Following collections will be installed in ansible controller:

```bash
ansible-galaxy collection install community.crypto
ansible-galaxy collection install ansible.posix
```
- **OR** use `setup.sh` to install ansible on localhost

```bash
./setup.sh -h
./setup.sh -a
```

## Implementation

Follow below instructions and execute commands on ansible controller.

1. Update K8s node information and auth creds in inventory. `node_type` in above snippet is K8S node type

```
master ansible_host=192.168.10.235 node_type=master
worker1 ansible_host=192.168.10.17 node_type=worker

[all:vars]
ansible_user=ubuntu
ansible_password=redhat
ansible_become_password=redhat
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

2. Host configuration, following changes will be made on target machines:
> * Static IP configuration to target machines
  * Disable BIOS dev name
	* Disable IPv6
	* Configure password less sudo for current user on target machines

```bash
./setup.sh -p
```

3. Prepare nodes for kubeadm deployment, following changes will be made on target machines:
> * Setup ssh keys
  * Configure system to use google clouds packages repo
	* Enable `br_netfilter` kernel module
	* Set hostname
	* Update /etc/hosts
	* Sync upstream `openstack-helm` and `openstack-helm-infra` code to target hosts in /opt
	* Update `multinode-inventory.yaml` with the current ansible inventory
	* Update `multinode-vars.yaml`

```bash
./setup.sh -s
```

4. Deploy kubeadm cluster and add worker nodes.

> Note:
	* Below make commands calls `openstack-helm-infra/tools/gate/devel/start.sh` with the arguments passed at position $1 and $2 and deploys only k8s master -> upstream code functionality.
	* I have tweaked `openstack-helm-infra/tools/gate/devel/start.sh` to call a playbook on running `make dev-deploy k8s multinode` command and add worker node in cluster, post kubeadm setup on master node.
	* To achieve this functionality I have added:
	```
	playbook: openstack-helm-infra/playbooks/osh-infra-add-worker.yaml
	role: openstack-helm-infra/roles/add-worker
	```

	- Login in k8s master and run below commands [source: Run the playbooks](https://docs.openstack.org/openstack-helm/latest/install/kubernetes-gate.html).
	> Run command as `ansible_user` in inventory. Do not run as root.

```bash
cd /opt/openstack-helm-infra
make dev-deploy setup-host multinode
make dev-deploy k8s multinode
```

 - **OR** run command to setup kubeadm cluster on target machines and add worker
```bash
./setup.sh -k
```

5. **OPTIONAL** Add worker node manually in existing cluster
```bash
./add-worker.sh
```
