# OpenStack Helm

## Purpose

Setup system pre-requisites of machines for the easy deployment of k8s and openstack using opensource [openstack helm](https://docs.openstack.org/openstack-helm/latest/) project.

* [Gate-Based Kubernetes](https://docs.openstack.org/openstack-helm/latest/install/kubernetes-gate.html)
* [Multi Node Deployment](https://docs.openstack.org/openstack-helm/latest/install/multinode.html)
* [Single Node Deployment](https://docs.openstack.org/openstack-helm/latest/ko_KR/install/developer/kubernetes-and-common-setup.html)

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

| Node Type          | CPU  | Memory  | Packages and tools |
| ------------------ | ---- | ------- | ------------------ |
| Ansible Controller | 2    | 4 GB    | ansible-core 2.12+ |
| K8s Master         | 8+   | 10+ GB  |                    |
| K8s Worker         | 4+   | 6+ GB   |                    |
| Minikube Node      | 10+  | 16+ GB  |                    |

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

## Deployment Methods:

- **[Multinode Kubeadm based deployment](docs/kubeadm/INDEX.md)**
