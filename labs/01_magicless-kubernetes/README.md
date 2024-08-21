# Magicless Kubernetes

In this lab you will setup a Kubernetes Cluster from scratch, without any help from tools like kubeadm, kubeone or others.

## Setting up the HA Cluster

You will create a Kubernetes Cluster with 3 ControlPlane Nodes and 3 Worker Nodes.

### Infrastructure

Create the Network and VMs. (Docker network and containers)

#### Setup Network

Create the network:

```bash
cd /workspaces/kubernetes-fundamentals-for-ops/labs/01_magicless-kubernetes
cat ./010_network.sh
./010_network.sh
```

#### Create the VMs

Create the Containers for the HA Cluster
* 3 Containers for the ControlPlane
* 3 Containers for the Worker Nodes

```bash
cat ./020_instances.sh
./020_instances.sh
```

#### Create the needed Certs

Create the CA and the certificates for encrypted communication between the Kubernetes Components.

```bash
cat ./030_pki.sh
./030_pki.sh
```

#### Create the needed Kubeconfigs

Make use of the certificates to create the kubeconfigs for encrypted communication between the Kubernetes Components.

```bash
cat ./040_kubeconfigs.sh
./040_kubeconfigs.sh
```

#### Create the Encryption Config

Create a Kubernetes EncryptionConfig which ensures encrypted secrets in etcd.

```bash
cat ./050_encryption.sh
./050_encryption.sh
```

### Create the Controlplane

Create the 3 ControlPlane Nodes.

#### Copy the needed files to the master nodes

Copy the needed configs and sensitive data to the 3 VM instances.

```bash
./100_master-files.sh
```

#### Switch to master nodes via Tmux

Make use of Tmux for making changes on the 3 VMs

```bash
./110_master-tmux.sh
```

#### Create Etcd Cluster

Install and start the etcd cluster.

```bash
bash ./120_master-etcd.sh
```

#### Preps for starting Controlplane Components

Download ControlPlane binaries and install configs and certs to their proper location.

```bash
bash ./130_master-kube-services-preps.sh
```

#### Create the kube-apiserver services

Install and start the kube-apiserver.

```bash
bash ./140_master-kube-apiserver.sh
```

#### Create Load Balancer for kube-apiserver

Update `keepalived` configuration and restart the service.

```bash
bash ./145_master-keepalived.sh
```

#### Create the kube-controller-manager services

Install and start the kube-controller-manager.

```bash
bash ./150_master-kube-controller-manager.sh
```

#### Create the kube-scheduler services

Install and start the kube-scheduler.

```bash
bash ./160_master-kube-scheduler.sh
```

> Now you can exit tmux by typing `exit` twice

#### Ensure communication between kube-apiserver services and kubelets

Configure Kubernetes for enabling communication from the api-server to the kubelets via RBAC.

```bash
cat ./170_master-kubelet-rbac.sh
./170_master-kubelet-rbac.sh
```

### Create the worker nodes

Prepare 3 the Worker Nodes.

#### Copy the needed files to the worker nodes

Copy the needed configs and sensitive data to the 3 VM instances.

```bash
./200_worker-files.sh
```

#### Switch to worker nodes via Tmux

Make use of Tmux for making changes on the 3 VMs

```bash
./210_worker-tmux.sh
```

#### Create the containerd services

Install and start the containerd.

```bash
bash ./220_worker_cre.sh
```

#### Create the kubelet services

Install and start the kubelets.

```bash
bash ./230_worker_kubelet.sh
```

#### Create the kube-proxy services

Install and start the kube-proxys.

```bash
bash ./240_worker_kube-proxy.sh
```

#### Configure CNI-Plugins

Install the bridge CNI plugin and install config files to the proper location.

```bash
bash ./250_worker_cni.sh
```

> Now you can exit tmux by typing `exit` twice

### Ensure bridge CNI-Plugin is working

Due to the use of the bridge CNI plugin we have to create routes between the worker nodes.

```bash
./300_routes.sh
```

### Test your Kubernetes Cluster

Verify everything is working.

#### Pods

Test if workloads can be deployed and can be reached afterwards via curl.

```bash
./410_smoke-test-deployment.sh
```

#### Secrets

Test if secrets are encrypted in etcd.

```bash
./420_smoke-test-secret.sh
```
