# Ansible Playbook DevOps Infrastructure `[v1.3 - Stable]`

This Ansible Playbook deploys a kubernetes cluster

## Prerequisites

To run this project, you must install Ansible on your computer and have at least 2 GNU/Debian 12.2.0 servers running.
#### Warning: Kubernetes needs at least 2 cores and 2 GB of RAM to run.

Home Lab :
```
- Proxmox Server (64 Core - 128 Gb RAM)
    - Master
        - Node_1
        - Node_2
```

## Get Started

### Dependencies
```
python3 -m pip install --user ansible
```

Ansible work by SSH, so it's mandatory to have an ssh key configured and added in root authorized_keys file of target hosts.

You can transfer your user's ssh key to all servers by running:
```
cat ~/.ssh/id_rsa.pub | ssh user@remote_host "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
ssh user@remote_host
su
cp -r .ssh /root/.ssh
```

### Running make

Once the environment is set up, simply run `make`.\
Every informations will be asked by a prompt and a ping test is perform to check the configuration:
```
user@computer:~# make
 ┏━ Master ━━━━━━━━━━━━━━━━━━━━━┓
 ┃ How many Master do you need? ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
1
Master 1 IP address:
[...]
 ┏━ Setup ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
 ┃ Please, check the configuration. Continue? [y/N] ┃
 ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
y
k8s-node-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
k8s-master | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

PLAY [all] ******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [k8s-node]
ok: [k8s-master]

TASK [Including vars] *******************************************************************************************************************************************************************************************************************************************************************************************************************************************************
ok: [k8s-master]
ok: [k8s-node-1]
[...]
```

#### Your (small) infrastructure is now configured !

Here are some examples of my environment to guide you :
```
root@master:~# kubectl get nodes
NAME         STATUS   ROLES           AGE     VERSION
k8s-master   Ready    control-plane   7m      v1.28.2
k8s-node-1   Ready    <none>          7m      v1.28.2
```
We can see that all nodes are currently connected.

```
root@master:~# kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-7ddc4f45bc-wxvjt   1/1     Running   0          7m
kube-system   calico-node-mjt2w                          1/1     Running   0          7m
kube-system   calico-node-mktfz                          1/1     Running   0          7m
kube-system   coredns-5dd5756b68-bhqpb                   1/1     Running   0          7m
kube-system   coredns-5dd5756b68-g2jnr                   1/1     Running   0          7m
kube-system   etcd-k8s-master                            1/1     Running   0          8m
kube-system   kube-apiserver-k8s-master                  1/1     Running   0          8m
kube-system   kube-controller-manager-k8s-master         1/1     Running   0          8m
kube-system   kube-proxy-h4qdh                           1/1     Running   0          7m
kube-system   kube-proxy-szcpz                           1/1     Running   0          7m
kube-system   kube-scheduler-k8s-master                  1/1     Running   0          8m
```
The `-A` option is for "--all-namespaces".

<!-- ```
root@Master:~# kubectl describe pod/jenkins-deployment-667fb997fb-ncdwb --namespace jenkins
Name:         jenkins-deployment-667fb997fb-ncdwb
Namespace:    jenkins
Priority:     0
Node:         node-1/192.168.1.20
Start Time:   Tue, 22 Sep 2020 01:04:45 +0200
Labels:       app=jenkins
              pod-template-hash=667fb997fb
Annotations:  <none>
Status:       Running
IP:           10.244.1.2
IPs:
  IP:           10.244.1.2
Controlled By:  ReplicaSet/jenkins-deployment-667fb997fb
[...]
```
Here is a description of the jenkins pod, it currently works on the node-1 whose IP is 192.168.1.20

```
root@master:~# kubectl get services -A
NAMESPACE     NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
default       kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP                  48m
jenkins       jenkins      NodePort    10.108.213.130   <none>        8080:30000/TCP           48m
kube-system   kube-dns     ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   48m
```
And finally, the list of all services and their open ports.

With all this information, I can deduce that jenkin is accessible with a browser on IP `192.168.1.20:30000`. -->

## Built With

| Package                                                       | Usage                                             | Version |
| :------------------------------------------------------------ | :------------------------------------------------ | :------ |
| [Proxmox](https://www.proxmox.com/en/)                        | Level 1 hypervisor                                | 8.1.10  |
| [Debian](https://www.debian.org/index.fr.html)                | Servers operating system                          | 12.5.0  |
| [Ansible](https://docs.ansible.com/ansible/latest/index.html) | Automation tool for servers configuration         | 2.16.6  |
| [Kubernetes](https://kubernetes.io/)                          | Docker container orchestrator                     | v1.28.9 |
| [Calico](https://docs.tigera.io/calico/3.26/about/)           | Fine grained network configuration in the cluster | v3.26.1 |

## Authors

* **Thibaut Choppy** - *Initial work* - [Linkedin](https://www.linkedin.com/in/thibaut-choppy/)
