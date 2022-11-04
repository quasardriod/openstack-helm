# Deploy Kubernetes cluster using kubeadm for Openstack Helm

#### 1. Configure hosts following changes will be made on target machines:
- If K8s nodes are VMs and running on KVM hypervisor export `KVM=true`:

```bash
# export KVM if target nodes are KVM guests
unset KVM
export KVM=true

./setup.sh -p
```

- **NOTE:** Following changes will be made on target machines:
* Static IP configuration to target machines
* Disable BIOS dev name
* Disable IPv6
* Configure password less sudo for current user on target machines

#### 2. Prepare nodes for kubeadm deployment:

```bash
./setup.sh -s
```

**NOTE:** Following changes will be made on target machines:
  - Setup ssh keys
  - Configure system to use google clouds packages repo
  - Enable `br_netfilter` kernel module
  - Set hostname
  - Update /etc/hosts
  - Sync upstream `openstack-helm` and `openstack-helm-infra` code to target hosts in /opt
  - Update `multinode-inventory.yaml` with the current ansible inventory
  - Update `multinode-vars.yaml`

#### 3. Deploy kubeadm cluster and add worker nodes:
**NOTE**
  - `make` commands calls `openstack-helm-infra/tools/gate/devel/start.sh` with the arguments passed at position $1 and $2 and deploys only k8s master -> upstream code functionality.
  - I have tweaked `openstack-helm-infra/tools/gate/devel/start.sh` to call a playbook on running `make dev-deploy k8s multinode` command and add worker node in cluster, after installing kubernetes cluster on master.
  - To achieve this functionality I have added:
```
playbook: openstack-helm-infra/playbooks/osh-infra-add-worker.yaml
role: openstack-helm-infra/roles/add-worker
inventory: openstack-helm-infra/tools/gate/devel/multinode-inventory.yaml
```

-  Run on ansible controller to install kubeadm cluster(master and worker both). This would take time to complete. If deployment fails continuously, use `make` commands to install kubernetes cluster and debug.
 ```bash
 ./setup.sh -k
 ```

- **OR Login in k8s master** and run below commands [source: Run the playbooks](https://docs.openstack.org/openstack-helm/latest/install/kubernetes-gate.html). Run command as `ansible_user` in inventory. Do not run as root.
```bash
cd /opt/openstack-helm-infra
make dev-deploy setup-host multinode
make dev-deploy k8s multinode
```

#### 4. **OPTIONAL** Add worker node manually in existing cluster
```bash
./add-worker.sh
```

[Go To Home Page](../README.md)
