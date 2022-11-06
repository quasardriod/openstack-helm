# Deploy OpenStack Helm with Minikube(Single Node Deployment)

Follow below instructions and execute commands on ansible controller.

## 1. Inventory and group vars:

- Update K8s node information and auth creds in `inventory/minikube.ini`.

```
minikube ansible_host=192.168.10.111

[all:vars]
ansible_user=ubuntu
ansible_password=redhat
ansible_become_password=redhat
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

#### 2. Configure hosts:
- If target machine is a KVM guest export `KVM=true`:

```bash
# export KVM if target nodes are KVM guests
unset KVM
export KVM=true

export MULTINODE=false

./setup.sh -p
```

- **NOTE:** Following changes will be made on target machines:
  * Static IP configuration to target machines
  * Disable BIOS dev name
  * Disable IPv6
  * Configure password less sudo for current user on target machines
