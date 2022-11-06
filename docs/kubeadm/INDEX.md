# Deploy Kubernetes cluster using kubeadm and Openstack Helm

Follow below instructions and execute commands on ansible controller.

**1. Inventory and group vars:**

- Update K8s node information and auth creds in `inventory/hosts`. In below snippet `node_type` K8S node type.
- Do not remove/change group names `primary & nodes`.

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
**2. [Deploy Kubernetes cluster using kubeadm for OpenStack Helm](./osh-kubeadm.md)**

**3. [Deploy OpenStack Helm](./osh-deploy.md)**

[Go To Home Page](../../README.md)
