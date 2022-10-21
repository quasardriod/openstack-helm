# OpenStack Helm

## Purpose

Complete prerequisites of K8s machines for the easy deployment of k8s and openstack using opensource [openstack helm](https://docs.openstack.org/openstack-helm/latest/)

* [Gate-Based Kubernetes](https://docs.openstack.org/openstack-helm/latest/install/kubernetes-gate.html)
* [Multi node deployment](https://docs.openstack.org/openstack-helm/latest/install/multinode.html)

### Features & changes list:
- Disable biosdevname
- Disable IPv6
- Configure Static IP
- Install Google Cloud repo GPG Key
- Generate inventory for OSH multinode deployment
- Add new worker node to cluster deployed using kubeadm

## Implementation

- Update K8s node information and auth creds in inventory. `node_type` in above snippet is K8S node type

```
master ansible_host=192.168.10.235 node_type=master
worker1 ansible_host=192.168.10.17 node_type=worker

[all:vars]
ansible_user=ubuntu
ansible_password=redhat
ansible_become_password=redhat
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

- Run `./multinode.sh` for multinode deployment

- Login in master node and run playbook for k8s master node setup [source: Run the playbooks](https://docs.openstack.org/openstack-helm/latest/install/kubernetes-gate.html)
```bash
#!/bin/bash
set -xe
cd /opt/openstack-helm-infra
make dev-deploy setup-host multinode
make dev-deploy k8s multinode
```
