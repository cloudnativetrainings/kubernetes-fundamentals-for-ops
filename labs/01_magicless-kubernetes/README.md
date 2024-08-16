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
./010_network.sh
```

#### Create the VMs

Create the Containers for the HA Cluster
* 3 Containers for the ControlPlane
* 3 Containers for the Worker Nodes

```bash
./020_instances.sh
```

#### Create the needed Certs

Create the CA and the certificates for encrypted communication between the Kubernetes Components.

```bash
./030_pki.sh
```

#### Create the needed Kubeconfigs

Make use of the certificates to create the kubeconfigs for encrypted communication between the Kubernetes Components.

```bash
./040_kubeconfigs.sh
```

#### Create the Encryption Config

Create a Kubernetes EncryptionConfig which ensures encrypted secrets in etcd.

```bash
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

You can check the logs:

```bash
tail -f /var/log/etcd.log
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

#### Ensure communication between kube-apiserver services and kubelets

Configure Kubernetes for enabling communication from the api-server to the kubelets via RBAC.

### Create the worker nodes

Create 3 the Worker Nodes.

#### Copy the needed files to the worker nodes

Copy the needed configs and sensitive data to the 3 VM instances.

#### Switch to worker nodes via Tmux

Make use of Tmux for making changes on the 3 VMs

#### Create the containerd services

Install and start the containerd.

#### Create the kubelet services

Install and start the kubelets.

#### Create the kube-proxy services

Install and start the kube-proxys.

#### Configure CNI-Plugins

Install the bridge CNI plugin and install config files to the proper location.

#### Ensure bridge CNI-Plugin is working

Due to the use of the bridge CNI plugin we have to create routes between the worker nodes.

### Test your Kubernetes Cluster

Verify everything is working.

#### Pods

Test if workloads can be deployed and can be reached afterwards via curl.

#### Secrets

Test if secrets are encrypted in etcd.
