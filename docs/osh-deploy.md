# Deploy OpenStack Helm

#### 1. Deploy OpenStack controller components:
```bash
./setup.sh -o
```

**NOTE:** Code changes in upstream `openstack-helm` and `openstack-helm-infra` repo and how it's being done:
  - We will be using `inventory/hosts` as inventory to deploy openstack helm, and this approach is taken to make it work with zuul later
  - `openstack-helm/tools/gate/playbooks/multinode.yaml` playbook has been created to install OpenStack helm
  - Current changes will install only openstack controller components.

[Go To Home Page](../README.md)
